pipeline {
    agent any

    environment {
        IMAGE_NAME = "abdelrahmannayf/finalproject"
    }

    stages {
        // شلنا مرحلة الـ Clone Repo لأن جينكنز بيعملها تلقائياً في البداية
        
        stage('Build Image') {
            steps {
                // اتأكد إنك واقف في المسار الصح اللي فيه الـ Dockerfile
                sh 'docker build -t $IMAGE_NAME:latest ./source'
            }
        }

        stage('Scan Image (Trivy)') {
            steps {
                sh 'trivy image $IMAGE_NAME:latest || true'
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                    sh "docker push $IMAGE_NAME:latest"
                }
            }
        }

        stage('Update Kubernetes Manifest') {
            steps {
                sh "sed -i 's|image: .*|image: $IMAGE_NAME:latest|' kubernetes/deployment.yaml"
            }
        }

        stage('Push Manifest Changes') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-cred', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    sh '''
                        git config user.name "jenkins"
                        git config user.email "jenkins@example.com"
                        
                        # لاحظ مفيش أقواس مربعة هنا
                        git remote set-url origin https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/abdelrahmannayf/CloudDevOpsProject.git

                        git add kubernetes/deployment.yaml
                        git commit -m "Update image version to ${BUILD_NUMBER}" || true
                        git push origin main
                    '''
                }
            }
        }
    }
}
