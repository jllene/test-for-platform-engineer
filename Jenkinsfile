#!groovy
properties([
        overrideIndexTriggers(true),
        disableConcurrentBuilds(),
        parameters([
                choice(choices: "false\ntrue", description: 'auto deployment to aws', name: 'autoDeploy'),
                choice(choices: "dev\ntest\nperf\nstage\nprod", description: 'environment to deploy', name: 'envDeploy'),
                booleanParam(defaultValue: true, description: 'enalbe to build new version package', name: 'enabledBuild'),
                string(defaultValue: 'lastest', description: 'specify package, this effect only enabledBuild==false', name: 'packageName')
        ])
])

@Library('ors.ci.common_ci') _


node('aws-centos') {

    def common_shell = new ors.utils.CommonShell(steps, env)
    def buildNumber = env.BUILD_NUMBER
    def FULL_IMAGE = "test:${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
    def d = [BuildNumber: buildNumber]
    checkout scm
    def props = readProperties defaults: d, file: 'jenkins.properties'

    stage('Check out') {
        deleteDir()
        checkout scm
        dir('test-for-platform-engineer') {
            git url: 'https://github.com/test-for-platform-engineer.git', branch: 'main', credentialsId: 'xxx_user'
        }
    }

    currentBuild.description = "test_tag=${image_tag}"

    docker.withRegistry("https://artifactory.xxx.net", 'test_user') {
        stage("build test image") {
            common_shell.shell("""
                docker build --ulimit nofile=65534:65534 --pull -t ${props['artifactoryUrl']}/${FULL_IMAGE} -f dockerfiles/Dockerfile --build-arg BuildNumber=${buildNumber} .
            """)
        }

        stage("push test image to artifactory") {
            echo "pushing to ${props['artifactoryUrl']}/${FULL_IMAGE}"
            common_shell.shell("""
                docker push ${props['artifactoryUrl']}/${FULL_IMAGE}
            """)
        }

        stage('Prepare terraform env and commands') {
                echo "setup aws region and terraform commands"
                tf_export = """
                   set +x
                   export AWS_DEFAULT_REGION="${awsRegion}"
                """

                tfInit = "terraform init"
                tfGet = "terraform get\n"
                tfPlan = "terraform plan -var="image_uri=${FULL_IMAGE}"
                tfApply = "terraform apply -target=module.ecs -var="image_uri=${FULL_IMAGE}"
                if( envDeploy == "dev" || envDeploy == "test" || envDeploy == "perf"){
                    tfApply = "terraform apply -target=module.ecs -auto-approve  -var="image_uri=${FULL_IMAGE}"
                }
            }
    }

    

}