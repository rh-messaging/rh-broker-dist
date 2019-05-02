The Nightly Pipeline
====================

The nightly pipeline will take any changes on upstream master and bring them to a downstream branch and then kick off a productised build in PNC. It will prepare the binaries and other artifacts that would make up most of a release

Running the Pipeline
--------------------

The pipeline should be set up to run nightly, but if you want to kick it of simple go to jenkins pipeline build [here](http://messaging-ci-01.mw.lab.eng.bos.redhat.com:8080/view/Productisation/job/AMQ7-PNC-pipeline/)
and click Build Now.

The pipeline has 5 stages.

1. [Update Master Branch](http://messaging-ci-01.mw.lab.eng.bos.redhat.com:8080/view/Productisation/job/update_master_branch/) 

    This takes [upstream master](https://github.com/apache/activemq-artemis) and will pull all the commits and push them to 
[downstream master](https://github.com/rh-messaging/activemq-artemis) 

2. [Prepare PNC Branch](http://messaging-ci-01.mw.lab.eng.bos.redhat.com:8080/view/Productisation/job/amq-prepare-pnc-branch/)

   This takes a temporary product branch, for instance [pre-7.4.x](https://github.com/rh-messaging/activemq-artemis/tree/pre-7.4.x)
and will merge all the commits that were brought down into master in step 1.
   >The branch used here needs to be prepared in advance after every release, it incorporates any changes needed for productisation
   >check out the [managing branches](managing-branches.md) chapter

3. [amq pnc build](http://messaging-ci-01.mw.lab.eng.bos.redhat.com:8080/view/Productisation/job/amq-pnc-build/)

   This actually kicks of the build in PNC. and will do several steps
    - This [repository](https://github.com/rh-messaging/rh-broker-dist.git) will be checked out.
    This is where all the jenkins files and scripts are kept. The [run pnc](https://github.com/rh-messaging/rh-broker-dist/blob/master/scripts/runpnc.sh) script will be called
    - The [Build Configurations](https://gitlab.cee.redhat.com/middleware/build-configurations) willbe checked out, this is 
    where we keep the configurations for the builds we want to do. The AMQ builds are [here](https://gitlab.cee.redhat.com/middleware/build-configurations/tree/master/amq/broker)
    - The [product files generator](https://gitlab.cee.redhat.com/middleware/product-files-generator) project is checked out. 
    This is the project that will create the binaries from a PNC build.
    - A PNC build is kicked off and the product files are generated using the output from the PNC build 

4. [Update Stagger](http://messaging-ci-01.mw.lab.eng.bos.redhat.com:8080/view/Productisation/job/updateStagger/)

    This takes the location of the created binaries and uploads the new builds to [stagger broker tags](https://stagger-rhm.cloud.paas.upshift.redhat.com/api/repos/rh-broker-dist/branches/master/tags/untested).
This is then used to trigger the nightly QE pipeline.
    > For more info on stagger see the [docs](https://stagger-rhm.cloud.paas.upshift.redhat.com/docs.html)

5. [Success email](http://messaging-ci-01.mw.lab.eng.bos.redhat.com:8080/view/Productisation/job/sendSuccessEmail/)

This sends out an email to the broker agile list with the status of this build.


The QE Pipeline
===============

The QE pipeline is kicked of by the update to the stagger tags by the AMQ pipeline. 
This is triggerd by the [AMQ Nightly Trigger](https://mw-messaging-qe-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/AMQ%20Broker/job/AMQ%20Nightly%20Trigger/) Job.

This in turn will kick of the [AMQ Broker Nightly](https://mw-messaging-qe-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/AMQ%20Broker/job/AMQ%20Broker%20Nightly/)
which is what kicks of the tests.

The tests that are run are all contained within the [AMQ Broker Nightly](https://mw-messaging-qe-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/AMQ%20Broker%20Nightly/) view.
To add builds to the pipeline simply add them to the view.

The QE Pipeline Results Collator
=================================

Once the Nightly test run has completed the [test aggregator](http://messaging-ci-01.mw.lab.eng.bos.redhat.com:8080/view/Productisation/job/test-aggregator/) will collate
all the results into a single location. This should be checked every day.


