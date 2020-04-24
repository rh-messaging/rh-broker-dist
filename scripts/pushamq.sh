#!/usr/bin/env bash

#
# example usage
#
# pushamq.sh 106 http://messaging-ci-01.mw.lab.eng.bos.redhat.com:8080/view/Productisation/job/amq-pnc-build/106/ 7.3.0.CR1 7.3.0.CR1-redhat-00004
#
#
#
#

BUILD_ID="$1"
BUILD_URL=$2
BROKER_VERSION=$3
BROKER_REDHAT_VERSION=$4

echo $1
echo BUILD_ID = \"${BUILD_ID}\"
echo BUILD_URL = \"${BUILD_URL}\"
echo BROKER_VERSION = \"${BROKER_VERSION}\"
echo BROKER_REDHAT_VERSION = \"${BROKER_REDHAT_VERSION}\"

ZIP_URL=${BUILD_URL}/artifact/amq-broker-${BROKER_VERSION}/amq-broker-${BROKER_REDHAT_VERSION}-bin.zip

echo ZIP_URL = \"${ZIP_URL}\"

TAR_URL=${BUILD_URL}/artifact/amq-broker-${BROKER_VERSION}/amq-broker-${BROKER_REDHAT_VERSION}-bin.tar.gz

echo TAR_URL = \"${TAR_URL}\"

MAVEN_URL=${BUILD_URL}/artifact/amq-broker-${BROKER_VERSION}/amq-broker-${BROKER_VERSION}-maven-repository

echo MAVEN_URL = \"${MAVEN_URL}\"

curl -X PUT  --insecure https://stagger-rhm.cloud.paas.psi.redhat.com/api/repos/rh-broker-dist/branches/master/tags/untested -d @- <<EOF
{
    "build_id": "${BUILD_ID}",
    "build_url": "${BUILD_URL}",
    "artifacts": {
        "broker-zip": {
            "type": "file",
            "url": "${ZIP_URL}"
        },
        "broker-tar": {
            "type": "file",
            "url": "${TAR_URL}"
        },
        "amq-broker": {
            "type": "maven",
            "repository_url": "${MAVEN_URL}",
            "group_id": "org.jboss.rh-messaging.amq",
            "artifact_id": "amq-broker-parent",
            "version": "${BROKER_REDHAT_VERSION}"
        }
    }
}
EOF
