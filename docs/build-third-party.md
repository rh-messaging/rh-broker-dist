How to Build 3rd party dependencies
===================================

AMQ Broker 3rd party dependencies are all jars included in lib directory and war files of a distribution. Before releasing a distribution, check that the lib directory and the war files contain only 'redhat' jars (except the artemis-boot.jar which is striped of the version at build time).

Check missing dependencies
--------------------------

The missing dependencies can be found in the file DependencyTreeMissingAlignment.txt included in the directory extras of the last PNC build:
http://messaging-ci-01.mw.lab.eng.bos.redhat.com:8080/job/amq-pnc-build/lastBuild/artifact/amq-broker-VERSION/extras/DependencyTreeMissingAlignment.txt

Before to build a missing dependency, look for an existing maven artifact on brew. Go to [brew web](https://brewweb.engineering.redhat.com/brew/), click on the search box, select the type “Maven Artifacts” and input the dependency name using wildcards, for instance guava*redhat*

PNC Build
--------------------------

1. Create a new project

    Go to [PNC web projects](http://orch.psi.redhat.com/pnc-web/#/projects) and search for the project related to the missing dependency, if not, create a new project using the create button and set the name, for instance guava.

2. Build locally

    Download the missing dependency sources and try to build locally before to create a new build configuration, for instance to build guava:
    >mvn clean package -DskipTests=true

3. Create new build configuration

    Go to PNC project related to the missing dependency and look for the build configuration, if not, create a new build configuration using the create button and set the required parameters, for instance:
    >Name: guava-24.1.1  
    >Environment: OracleJDK8u192; Mvn 3.5.4  
    >Build Script: mvn deploy dependency:tree -DskipTests=true  
    >Repository URL: https://github.com/google/guava  
    >Version: v24.1.1  
    >Pre-build sync: enabled


4. Build

    Make a temporary build to check the configuration before to execute a persistent build, which can be used for product release. To select a temporary build click the button next to Build and choose Temporary. To launch a build click the button Build.

5. Push to brew

    When the persistent building is completed click the button “Push To Brew” and input the AMQ Broker tag. To find the AMQ Broker tag go to [brew web](https://brewweb.engineering.redhat.com/brew/), click on the search box, select the type “Tags” and input the dependency name using wildcards: amq-broker*

6. Update productisation registry

    Update the document [Productisation patches and builds](https://docs.google.com/spreadsheets/d/1QTwssX6mVXA2fueXG_G2WG3AnalSePr_s2s8DajSGpg/edit#gid=694905137), adding a record with: project link, build configuration link and build link.
