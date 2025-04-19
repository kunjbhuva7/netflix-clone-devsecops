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
                // Clone the repository from GitHub
                git 'https://github.com/kunjbhuva7/netflix-clone-devsecops.git'
            }
        }

        stage('Build Docker Images') {
            parallel {
                stage('Frontend') {
                    steps {
                        script {
                            // Build frontend Docker image
                            sh "docker build -t $REGISTRY/$IMAGE_NAME_FRONTEND $FRONTEND_PATH"
                        }
                    }
                }
                stage('Backend') {
                    steps {
                        script {
                            // Build backend Docker image
                            sh "docker build -t $REGISTRY/$IMAGE_NAME_BACKEND $BACKEND_PATH"
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
                            // Push frontend Docker image to Docker Hub
                            sh "docker push $REGISTRY/$IMAGE_NAME_FRONTEND"
                        }
                    }
                }
                stage('Backend') {
                    steps {
                        script {
                            // Push backend Docker image to Docker Hub
                            sh "docker push $REGISTRY/$IMAGE_NAME_BACKEND"
                        }
                    }
                }
            }
        }

        stage('Run Docker Compose') {
            steps {
                script {
                    // Start the containers with Docker Compose
                    sh 'docker-compose up -d'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Run SonarQube analysis (optional, configure it for your project)
                    sh 'mvn sonar:sonar -Dsonar.projectKey=netflix-clone -Dsonar.host.url=http:http://localhost:9000/ -Dsonar.login=squ_0b203869845bb3e14cf43003b0f9ea17626c8f86'
                }
            }
        }

        stage('Trivy Scan for Vulnerabilities') {
            steps {
                script {
                    // Run Trivy to scan for vulnerabilities in the Docker images
                    sh 'trivy image $REGISTRY/$IMAGE_NAME_FRONTEND'
                    sh 'trivy image $REGISTRY/$IMAGE_NAME_BACKEND'
                }
            }
        }
    }
}

