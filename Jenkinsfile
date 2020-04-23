import groovy.json.JsonSlurperClassic

def amqZipUrl
def amq_broker_dir
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
    stage('prepare prod branch') {
        def amqPreparePncBranch = build(
        job: 'amq-prepare-pnc-branch',
        parameters: [
            [ $class: 'StringParameterValue', name: 'product_branch', value: 'master-pnc' ],
            [ $class: 'StringParameterValue', name: 'merge_branch', value: 'master' ]
        ],
        propagate: false
        )
        if (amqPreparePncBranch.result != 'SUCCESS') {
          def emailBody = """
            Preparing AMQ prod branch failed.

            See job for details: ${amqPreparePncBranch.absoluteUrl}
          """.stripIndent().trim()
          node {
            emailext body: emailBody, subject: "AMQ Broker nightly prod build ${new Date().format('yyyy-MM-dd')}", to: 'amq-broker-agile@redhat.com'
            throw new Exception("Production job failed. Cannot continue.")
          }
        }
    }
    stage('build amq nightly') {
        def amq = build(
        job: 'amq-pnc-build',
        parameters: [
            [ $class: 'StringParameterValue', name: 'BUILDCONFIG', value: 'nightly' ],
            [ $class: 'StringParameterValue', name: 'TEMPBUILD', value: 'true' ]
        ],
        propagate: false
        )
        if (amq.result != 'SUCCESS') {
          def emailBody = """
            Building of AMQ failed.

            See job for details: ${amq.absoluteUrl}
          """.stripIndent().trim()
          node {
            emailext body: emailBody, subject: "AMQ Broker nightly prod build ${new Date().format('yyyy-MM-dd')}", to: 'amq-broker-agile@redhat.com'
            throw new Exception("Production job failed. Cannot continue.")
          }
        }
        sh "echo running"
        def amqVariables = amq.getBuildVariables();
        build_url = "${amqVariables.BUILD_URL}"
        sh "echo $build_url"
        build_id = "${amqVariables.BUILD_ID}"
        amq_broker_dir = sh(returnStdout: true, script: "curl ${amq.absoluteUrl}/artifact/amq-broker-dir.txt").tokenize('\n')[-1]
        sh "echo amq_broker_dir $amq_broker_dir"
        sh "rm -f repository-artifact-list.txt"
        sh "wget ${amq.absoluteUrl}/artifact/${amq_broker_dir}/extras/repository-artifact-list.txt"
        amq_broker_redhat_version = sh(script: "grep org.jboss.rh-messaging.amq:amq-broker: repository-artifact-list.txt|cut -d':' -f3", returnStdout: true)
        sh "echo amq_broker_redhat_version $amq_broker_redhat_version"
        amq_broker_version = amq_broker_redhat_version.substring(0, amq_broker_redhat_version.indexOf('-'))
        sh "echo amq_broker_version $amq_broker_version"
    }
    stage ("Update Stagger") {
        checkout scm
        sh "sh ./scripts/pushamq.sh $build_id $build_url $amq_broker_version $amq_broker_redhat_version"
    }
    stage ("Send Email") {
        build(
        job: 'sendSuccessEmail',
        parameters: [
            [ $class: 'StringParameterValue', name: 'AMQ_VERSION', value: 'nightly' ],
            [ $class: 'StringParameterValue', name: 'BUILD_URL', value: build_url ],
            [ $class: 'StringParameterValue', name: 'amq_broker_version', value: amq_broker_version ],
            [ $class: 'StringParameterValue', name: 'amq_broker_redhat_version', value: amq_broker_redhat_version ]
        ],
        propagate: false
        )

    }
}
