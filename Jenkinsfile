pipeline {
    agent any

    environment {
        DEPLOY_USER = 'aash'
        DEPLOY_HOST = '172.24.115.43'
        DEPLOY_PATH = '/opt/server-monitor'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'git@github.com:Aash1236/server-monitor.git'
            }
        }

        stage('ShellCheck Linting') {
            steps {
                script {
                    def result = sh(script: 'shellcheck -x monitor.sh utils.sh docker_monitor.sh', returnStatus: true)
                    if (result != 0) {
                        echo "ShellCheck found issues (exit code ${result}). Review above output."
                        // Optional: error("ShellCheck failed.")
                    }
                }
            }
        }

        stage('Dry Run Monitoring Script') {
            steps {
                sh './monitor.sh --dry-run'
            }
        }

        stage('Deploy to Remote Server') {
            steps {
                sshagent(['ssh-key-ash']) {
                    sh """
                    rsync -avz . ${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH}
                    ssh ${DEPLOY_USER}@${DEPLOY_HOST} 'bash -s' <<'ENDSSH'
                        cd ${DEPLOY_PATH}
                        chmod +x monitor.sh
                        ./monitor.sh --dry-run
                    ENDSSH
                    """
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment successful!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}

