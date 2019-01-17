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
            [ $class: 'StringParameterValue', name: 'product_branch', value: 'master.PNC' ],
            [ $class: 'StringParameterValue', name: 'rebase_branch', value: 'master' ]
        ],
        propagate: false
        )
    }

    stage('kick-off-test-suites') {
        sh "echo binary at ${amqZipUrl}"
    }
}