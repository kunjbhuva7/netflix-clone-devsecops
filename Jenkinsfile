pipeline {
    agent any

    environment {
        REGISTRY = "docker.io"
        IMAGE_NAME_FRONTEND = "netflix-clone-frontend"
        IMAGE_NAME_BACKEND = "netflix-clone-backend"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/your-repo/netflix-clone.git'
            }
        }

        stage('Build Docker Images') {
            parallel {
                stage('Frontend') {
                    steps {
                        script {
                            sh 'docker build -t $REGISTRY/$IMAGE_NAME_FRONTEND ./frontend'
                        }
                    }
                }
                stage('Backend') {
                    steps {
                        script {
                            sh 'docker build -t $REGISTRY/$IMAGE_NAME_BACKEND ./backend'
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
                            sh 'docker push $REGISTRY/$IMAGE_NAME_FRONTEND'
                        }
                    }
                }
                stage('Backend') {
                    steps {
                        script {
                            sh 'docker push $REGISTRY/$IMAGE_NAME_BACKEND'
                        }
                    }
                }
            }
        }

        stage('Deploy to Docker Compose') {
            steps {
                script {
                    sh 'docker-compose up -d'
                }
            }
        }
    }
}

