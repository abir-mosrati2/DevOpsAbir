pipeline {
    agent any

    environment {
        DOCKER_USER = 'AbirMosrati'
        WSL_WORKDIR = '/mnt/c/Users/utilisateur/.jenkins/workspace/AbirProject2'
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
                bat 'mvn -v'
                bat 'mvn clean package -DskipTests'
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
                wsl -e bash -lc "cd ${WSL_WORKDIR} && docker build -t ${DOCKER_USER}/student-management:latest ."
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
                bat "wsl -e bash -lc \"docker push ${DOCKER_USER}/student-management:latest\""
            }
        }
    }
}
