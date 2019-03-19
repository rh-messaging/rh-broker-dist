#!/usr/bin/env bash

rm -rf target
mkdir target
cd target
wget https://mw-messaging-qe-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/AMQ%20Broker/job/AMQ%20Broker%20Nightly/lastSuccessfulBuild/artifact/results.txt

for i in $(cat results.txt); do
    job="`echo $i | cut -d'/' -f 5`"
    if wget --no-check-certificate "`echo $i`artifact/*zip*/download.zip" ; then
        unzip -j -n download.zip -d $job
        if [ -e $job/outputs.tar.gz ]; then
            tar -xvf $job/outputs.tar.gz --directory $job
        fi
    fi
    rm download.zip
done