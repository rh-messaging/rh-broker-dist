import groovy.json.JsonSlurperClassic

def amqZipUrl
def amq_broker_version
def amq_broker_redhat_version
def build_url
def build_id

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
            [ $class: 'StringParameterValue', name: 'product_branch', value: 'pre-7.3.x' ],
            [ $class: 'StringParameterValue', name: 'rebase_branch', value: 'master' ]
        ],
        propagate: false
        )
    }
    stage('build amq 7.3') {
        def amq = build(
        job: 'amq-pnc-build',
        parameters: [
            [ $class: 'StringParameterValue', name: 'release-version', value: '7.3.0' ],
            [ $class: 'StringParameterValue', name: 'milestone', value: 'CR1' ],
            [ $class: 'StringParameterValue', name: 'pig-build-config-version', value: '7.3' ]
        ],
        propagate: false
        )
        if (amq.result != 'SUCCESS') {
          def emailBody = """
            Building of AMQ failed.

            See job for details: ${eap.absoluteUrl}
          """.stripIndent().trim()
          node {
            emailext body: emailBody, subject: "AMQ Broker nightly prod build ${new Date().format('yyyy-MM-dd')}", to: 'broker-agile@redhat.com'
            throw new Exception("Production job failed. Cannot continue.")
          }
        }
        sh "echo running"
        def amqVariables = amq.getBuildVariables();
        build_url = "${amqVariables.BUILD_URL}"
        sh "echo $build_url"
        build_id = "${amqVariables.BUILD_ID}"
        sh "rm -f REPOSITORY_COORDINATES.properties"
        sh "wget ${amq.absoluteUrl}/artifact/amq-broker-7.3.0.CR1/extras/REPOSITORY_COORDINATES.properties"
        amq_broker_redhat_version = sh(script: "grep amq-broker_SCM_REVISION REPOSITORY_COORDINATES.properties|cut -d'=' -f2", returnStdout: true)
        sh "echo amq_broker_redhat_version $amq_broker_redhat_version"
        amq_broker_version = amq_broker_redhat_version.substring(0, amq_broker_redhat_version.indexOf('-'))
        sh "echo amq_broker_version amq_broker_version"
    }
    stage ("Update Stagger") {
        sh "./scripts/pushamq.sh $build_id $build_url $amq_broker_version $amq_broker_redhat_version"
    }
    stage ("Send Email") {
        build(
        job: 'sendSuccessEmail',
        parameters: [
            [ $class: 'StringParameterValue', name: 'AMQ_VERSION', value: '7.3' ],
            [ $class: 'StringParameterValue', name: 'BUILD_URL', value: build_url ],
            [ $class: 'StringParameterValue', name: 'amq_broker_version', value: amq_broker_version ],
            [ $class: 'StringParameterValue', name: 'amq_broker_redhat_version', value: amq_broker_redhat_version ]
        ],
        propagate: false
        )

    }
}
