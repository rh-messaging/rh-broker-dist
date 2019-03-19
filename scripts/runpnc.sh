#!/usr/bin/env bash

export PATH=$PATH:/home/jenkins-slave/.local/bin/
export GIT_SSL_NO_VERIFY=false
export WORKING_DIR=`pwd`

echo "WORKING DIR: $WORKING_DIR"
ls

# Ensure there's enough space in /tmp.
rm -rf /tmp/* || true

# Apply the additional patches to the branch required for PROD build
git config --global user.email "rh-messaging-ci@redhat.com"
git config --global user.name "RH Messaging CI"


# Checkout the build configurations
git clone https://gitlab.cee.redhat.com/middleware/build-configurations
cd build-configurations
git checkout origin/master
cd ../

# Checkout the PFG tooling
git clone https://gitlab.cee.redhat.com/middleware/product-files-generator.git
cd product-files-generator
git checkout origin/master

# Set up a virtual environment for Python (to install and run the PNC Client)
virtualenv `pwd`
chmod 700 bin/activate
export PATH=`pwd`/bin:$PATH
activate

# Install the PNC CLI
pip install -r docker/root/requirements.txt
pip install https://github.com/project-ncl/pnc-cli/archive/version-1.4.x.zip

# Build (currently required as there is not official release) and Run the PFG tool
cd core
mvn clean install -DskipTests
cd target
java -Djavax.net.ssl.trustStore=/etc/pki/java/cacerts -jar product-files-generator.jar -c ../../../build-configurations/amq/broker/7.3/ --skipJavadoc --rebuildMode=FORCE --tempBuild --skipLicenses

# Unpack maven repo and restructure directory to align with staging requirements
cd target/amq-broker*
unzip amq-broker-*-maven-repository.zip
cp amq-broker-*-maven-repository/maven-repository/org/jboss/rh-messaging/amq/amq-broker/*/amq-broker-*-bin.* .

cd ../
mv amq-broker* $WORKING_DIR



