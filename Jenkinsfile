library(
    identifier: 'pipeline-lib@4.3.4',
    retriever: modernSCM([$class: 'GitSCMSource',
                          remote: 'https://github.com/SmartColumbusOS/pipeline-lib',
                          credentialsId: 'jenkins-github-user'])
)

def image

node('infrastructure') {
    ansiColor('xterm') {
        scos.doCheckoutStage()

        stage('Build') {
            image = docker.build("smart_city_test:${env.GIT_COMMIT_HASH}")
        }

        scos.doStageIf(scos.changeset.isRelease, "Publish") {
            withCredentials([string(credentialsId: 'hex-write', variable: 'HEX_API_KEY')]) {
                image.run('--rm -e HEX_API_KEY=$HEX_API_KEY', 'mix hex.publish --yes')
            }
        }
    }
}