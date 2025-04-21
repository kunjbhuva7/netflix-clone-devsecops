pipeline {
    agent any

    environment {
        REGISTRY = "docker.io/kunj22"
        IMAGE_NAME_FRONTEND = "netflix-clone-devsecops-frontend"
        IMAGE_NAME_BACKEND = "netflix-clone-devsecops-backend"
        FRONTEND_PATH = "./frontend"
        BACKEND_PATH = "./backend"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/kunjbhuva7/netflix-clone-devsecops.git', branch: 'master'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
		        echo "Username: $DOCKER_USERNAME"
               		echo "Password length: ${#DOCKER_PASSWORD}"
		    '''
                }
            }
        }

        stage('Build Docker Images') {
            parallel {
                stage('Frontend') {
                    steps {
                        script {
                            sh "docker build -t ${REGISTRY}/${IMAGE_NAME_FRONTEND} ${FRONTEND_PATH}"
                        }
                    }
                }
                stage('Backend') {
                    steps {
                        script {
                            sh "docker build -t ${REGISTRY}/${IMAGE_NAME_BACKEND} ${BACKEND_PATH}"
                        }
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            parallel {
                stage('Frontend') {
                    steps {
                        script {
                            sh "docker push ${REGISTRY}/${IMAGE_NAME_FRONTEND}"
                        }
                    }
                }
                stage('Backend') {
                    steps {
                        script {
                            sh "docker push ${REGISTRY}/${IMAGE_NAME_BACKEND}"
                        }
                    }
                }
            }
        }

        stage('Run Docker Compose') {
            steps {
                script {
                    sh "docker compose up -d"
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
                        sh 'mvn sonar:sonar -Dsonar.projectKey=netflix-clone -Dsonar.host.url=http://sonarqube:9000 -Dsonar.login=squ_0b203869845bb3e14cf43003b0f9ea17626c8f86 || true'
                    }
                }
            }
        }

        stage('Trivy Scan for Vulnerabilities') {
            steps {
                script {
                    sh '''
                        if ! command -v trivy &> /dev/null; then
                            curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
                        fi
                    '''
                    sh "trivy image ${REGISTRY}/${IMAGE_NAME_FRONTEND}"
                    sh "trivy image ${REGISTRY}/${IMAGE_NAME_BACKEND}"
                }
            }
        }
    }

    post {
        always {
            node('') {
                sh "docker image prune -f || true"
                sh "docker compose down || true"
            }
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
    }
}
