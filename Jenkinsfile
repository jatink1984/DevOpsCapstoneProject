
pipeline {
    agent any
    stages {
        stage('Lint HTML & Dockerfile'){
            steps {
                sh 'tidy -q -e blue-green/blue/*.html'
                sh 'tidy -q -e blue-green/green/*.html'
                sh 'hadolint blue-green/blue/Dockerfile'
                sh 'hadolint blue-green/green/Dockerfile'
            }
        }
        stage('Build and Publish Docker Image'){
                    steps {
                        sh 'docker build -t sniizzer/blue-version -f blue-green/blue/Dockerfile blue-green/blue'
                        sh 'docker build -t sniizzer/green-version -f blue-green/green/Dockerfile blue-green/green'
                        sh 'docker push sniizzer/blue-version'
                        sh 'docker push sniizzer/green-version'
                        sh 'docker rmi -f sniizzer/blue-version'
                        sh 'docker rmi -f sniizzer/green-version'
                    }
                }
    }
}