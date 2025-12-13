pipeline {
    agent any

    environment {
        DOCKER_USER = 'abirmosrati2'
        IMAGE_NAME  = 'student-management'
        WSL_WORKDIR = '/mnt/c/Users/utilisateur/.jenkins/workspace/AbirProject2'
        SONAR_HOST  = 'http://localhost:9000'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/abir-mosrati2/DevOpsAbir.git'
            }
        }

        stage('Build Maven (Windows)') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                    bat """
                    mvn sonar:sonar ^
                      -Dsonar.projectKey=student-management ^
                      -Dsonar.projectName=student-management ^
                      -Dsonar.host.url=%SONAR_HOST% ^
                      -Dsonar.login=%SONAR_TOKEN%
                    """
                }
            }
        }

        stage('Docker (WSL) - Diagnostics') {
            steps {
                bat 'wsl -e bash -lc "docker version && docker info"'
            }
        }

        stage('Build Docker Image (WSL)') {
            steps {
                bat """
                wsl -e bash -lc "cd ${WSL_WORKDIR} && docker build -t ${DOCKER_USER}/${IMAGE_NAME}:latest -t ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ."
                """
            }
        }

        stage('Login to Docker Hub (WSL)') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-creds',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {
                    bat '''
                    wsl -e bash -lc "echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin"
                    '''
                }
            }
        }

        stage('Push Docker Image (WSL)') {
            steps {
                bat """
                wsl -e bash -lc "docker push ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER} && docker push ${DOCKER_USER}/${IMAGE_NAME}:latest"
                """
            }
        }
    }

    post {
        always {
            bat 'wsl -e bash -lc "docker logout || true"'
        }
    }
}
