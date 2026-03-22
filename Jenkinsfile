@Library('shared-library') _

pipeline {
    agent any
    environment {
        IMAGE_NAME = "abdelrahmannayf/finalproject"
    }
    stages {
        stage('Build Image') {
            steps {
                buildImage(IMAGE_NAME)
            }
        }
        stage('Scan Image (Trivy)') {
            steps {
                sh 'trivy image $IMAGE_NAME:latest || true'
            }
        }
        stage('Push Image') {
            steps {
                pushImage(IMAGE_NAME)
            }
        }
        stage('Update Kubernetes Manifest') {
            steps {
                sh 'sed -i "s|image: .*|image: $IMAGE_NAME:latest|" kubernetes/deployment.yaml'
            }
        }
        stage('Push Manifest Changes') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-cred', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    sh '''
                        git checkout main
                        git config user.name "jenkins"
                        git config user.email "jenkins@example.com"
                        git remote set-url origin https://$GIT_USERNAME:$GIT_PASSWORD@github.com/abdelrahmannayf/CloudDevOpsProject.git
                        git add kubernetes/deployment.yaml
                        git diff --cached --quiet && echo "Nothing to commit" || git commit -m "Update image to build #$BUILD_NUMBER"
                        git push origin main
                    '''
                }
            }
        }
    }
}
