import groovy.json.JsonSlurperClassic

def amqZipUrl
def amq_broker_version

node ("messaging-ci-01.vm2") {
    stage('prepare amq master prod branch') {
        build(
        job: 'update_master_branch',
        propagate: false
        )
    }
    stage('prepare amq 7.3 prod branch') {
        build(
        job: 'amq-prepare-pnc-branch',
        parameters: [
            [ $class: 'StringParameterValue', name: 'product_branch', value: 'master.pnc' ],
            [ $class: 'StringParameterValue', name: 'rebase_branch', value: 'master' ]
        ],
        propagate: false
        )
    }
    stage('build amq 7.2') {
        def amq = build(
        job: 'amq-pnc-build',
        parameters: [
            [ $class: 'StringParameterValue', name: 'release-version', value: '7.2.0' ],
            [ $class: 'StringParameterValue', name: 'milestone', value: 'CR1' ],
            [ $class: 'StringParameterValue', name: 'artemis-hawtio-branch', value: '1.0.4.CR1' ],
            [ $class: 'StringParameterValue', name: 'activemq-artemis-branch', value: 'master.pnc' ],
            [ $class: 'StringParameterValue', name: 'amq-jon-plugin-branch', value: 'amq-1.0.0.GA' ],
            [ $class: 'StringParameterValue', name: 'amq-broker-branch', value: '7.3.x.pnc' ],
            [ $class: 'StringParameterValue', name: 'pig-build-config-version', value: '7.2' ]
        ],
        propagate: false
        )
        sh "wget ${amq.absoluteUrl}/artifact/amq-broker-7.3.0.CR1/extras/REPOSITORY_COORDINATES.properties"
        sh "amq_broker_version=`grep amq-broker_SCM_REVISION REPOSITORY_COORDINATES.properties|cut -d'=' -f2`"
        amqZipUrl = "${amq.absoluteUrl}/artifact/amq-broker-7.3.0.CR1/amq-broker-${amq_broker_version}-bin.zip"
    }
    stage('kick-off-test-suites') {
        sh "echo binary at ${amqZipUrl}"
    }
}