pipeline {
    agent any

    environment {
        DOCKER_USER = 'AbirMosrati'
        IMAGE_NAME  = 'student-management'
        IMAGE_TAG   = "${env.BUILD_NUMBER}"
        IMAGE       = "${DOCKER_USER}/${IMAGE_NAME}"
    }

    options {
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/abir-mosrati2/DevOpsAbir.git'
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn -v'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker version'
                sh "docker build -t ${IMAGE}:${IMAGE_TAG} -t ${IMAGE}:latest ."
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-token', variable: 'DOCKER_HUB_TOKEN')]) {
                    sh 'echo "$DOCKER_HUB_TOKEN" | docker login -u "$DOCKER_USER" --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${IMAGE}:${IMAGE_TAG}"
                sh "docker push ${IMAGE}:latest"
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
    }
}
