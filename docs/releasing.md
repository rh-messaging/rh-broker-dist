How to Release AMQ Broker
=========================

There are several steps to releasing the broker. Since temporary builds have been running against master upstream there 
should be some certainty that test suites etc are passing. This process should start a few weeks before the release itself is due
to give time to handle any prod issues etc.

Releasing a new minor
---------------------

1. Creating a new Artemis product branch

    If possible a new release upstream, this should be if possible a new minor release upstream based of master. 
    If not a new micro version should be used. Create a new downstream branch from the release tag
    if this upstream version is x.y.z then the new branch should be called x.y.x.jbossorg-x, for instance like [this](https://github.com/rh-messaging/activemq-artemis/tree/2.7.0.jbossorg-x)
    The next step is to apply any patches needed, see [here](patching.md) for more details.
    
2. Creating a new AMQ 7 product branch

    Since the assembly rarely change this is just a case of taking the the last product branch such as [this](https://github.com/rh-messaging/A-MQ7/tree/7.3.x)
    and branching from this the next version, for instance 7.4.x, and updating the poms with new versions and the new version of Artemis to use.
     
3. Migrating the build configurations.

    The next step is to migrate the current nightly build configuration to use the correct branch and build a temporary build for smoke testing.
    The build configuration for each AMQ release and the nightly builds are found in the [build configurations repo](https://gitlab.cee.redhat.com/middleware/build-configurations)
    specifically under the [amq broker folder](https://gitlab.cee.redhat.com/middleware/build-configurations/tree/master/amq/broker).
    The first thing to do is change the milestone from an ER to a CR, for instance
    
    >milestone: CR1  
    
    Then change the branch used in the Artemis build to use the new branch created, for instance 
    
    >scmRevision: 2.7.0.jbossorg-x
    
    Then change the AMQ 7 assembly branch used, for instance
    
    >scmRevision: 7.4.x 
    
    Commit and push these changes these changes.
    
    >NOTE: at this point you should disable the nightly build until you have time to update to a new nightly build
    based of the next minor or major version. see [Creating a new Nightly Build](creating-new-nightly.md) 
    
    Now you can kick off a new nightly build from [the PNC build](http://messaging-ci-01.mw.lab.eng.bos.redhat.com:8080/view/Productisation/job/amq-pnc-build/build?delay=0sec)
    use the path to the build config you want to use for the BUILDCONGIG parameter
    so for instance if you were building [7.4](https://gitlab.cee.redhat.com/middleware/build-configurations/tree/master/amq/broker/7.4)
    you would set it to 7.3. Make sure that TEMPBUILD is set to true. This should build you somethinmg you can smoke test 
    against before continuing with the first CR
    
4.  Tagging the build

    Let's assume that we are building 7.4.0.CR1 for the first candidate release for 7.4.0.
    firstly make sure you have the branch checked out and up to date. Then make an empty commit to make it easy to find the commit for a specific version, so
    
    >git commit -m "Release X" --allow-empty  
    Where X may be 7.4.0.CR1
    
    Then tag that commit, something like
    
    >git tag -a 7.4.0.CR1 -m "release for 7.4.0.CR1"
    
    and push the new tag.<p>
    
    Now do the same for the AMQ 7 assembly branch and push this tag as well.
    
5. Update the build configurations for the tags

    So now update the build configurations for both Artemis and AMQ 7, for a tag of 7.4.0.CR1 this would be
    
    >scmRevision: 7.4.0.CR1
    
    and commit and push the changes.
    
6. Build the release

    Now we are in a position to build the actual release, again as in step 3 go to
    [the PNC build](http://messaging-ci-01.mw.lab.eng.bos.redhat.com:8080/view/Productisation/job/amq-pnc-build/build?delay=0sec)
    But this time make sure TEMPBUILD is false.
    
7. Create the release artifacts

   