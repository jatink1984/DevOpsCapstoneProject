
pipeline {
    agent any
    stages {
        // stage('Lint HTML'){
        //     steps {
        //         sh 'tidy -q -e blue-green/blue/*.html'
        //         sh 'tidy -q -e blue-green/green/*.html'
        //     }
        // }
        stage ("lint dockerfile") {
            agent {
                docker {
                    image 'hadolint/hadolint:latest-debian'
                }
            }
            steps {
                sh 'hadolint blue-green/blue/Dockerfile'
                sh 'hadolint blue-green/green/Dockerfile'
            }
        }
        stage('Build and Publish Docker Image'){
                steps {
                    sh 'docker build -t sniizzer/blue-version -f blue-green/blue/Dockerfile blue-green/blue'
                    sh 'docker build -t sniizzer/green-version -f blue-green/green/Dockerfile blue-green/green'
                    withDockerRegistry(url: "", credentialsId: 'dockerhub') {
                        sh 'docker push sniizzer/blue-version'
                        sh 'docker push sniizzer/green-version'
                    }
                    sh 'docker rmi -f sniizzer/blue-version'
                    sh 'docker rmi -f sniizzer/green-version'
                }
            }
        stage('Deploy to kubernetes'){
                steps {
                        sshagent(['ec2-machine']){
                            sh "scp -o StrictHostKeyChecking=no ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com"
                            script{
                                sh "ssh ec2-user@ec2-3-133-144-139.us-east-2.compute.amazonaws.com kubectl apply -f green-deployment.yml"
                            }
                    }    
                }
            }
    }
}