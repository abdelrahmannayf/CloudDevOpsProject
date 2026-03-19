pipeline {
agent any

//```
environment {
    IMAGE_NAME = "abdelrahmannayf/finalproject"
}

stages {

    stage('Clone Repo') {
        steps {
            git 'https://github.com/abdelrahmannayf/CloudDevOpsProject.git'
        }
    }

    stage('Build Image') {
        steps {
            sh 'docker build -t $IMAGE_NAME:latest .'
        }
    }

    stage('Scan Image (Trivy)') {
        steps {
            sh '''
            trivy image $IMAGE_NAME:latest || true
            '''
        }
    }

    stage('Push Image') {
        steps {
            sh '''
            docker push $IMAGE_NAME:latest
            '''
        }
    }

    stage('Delete Local Image') {
        steps {
            sh '''
            docker rmi $IMAGE_NAME:latest || true
            '''
        }
    }

    stage('Update Kubernetes Manifest') {
        steps {
            sh '''
            sed -i 's|image: .*|image: abdelrahmannayf/finalproject:latest|' kubernetes/deployment.yaml
            '''
        }
    }

    stage('Push Manifest Changes') {
    steps {
            // بنستخدم الـ ID اللي في الصورة عندك عشان يدي جينكنز صلاحية الرفع
            withCredentials([usernamePassword(credentialsId: 'github-cred', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                sh '''
                    # إعداد بيانات المستخدم
                    git config user.name "jenkins"
                    git config user.email "jenkins@example.com"

                    # تحديث الـ Remote URL عشان يشمل الـ Token/Password
                    # بنشيل الـ https:// ونحط بدالها الـ URL بالـ Credentials
                    git remote set-url origin https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/abdelrahmannayf/CloudDevOpsProject.git

                    git add .
                    # الـ || true عشان لو مفيش تغييرات الـ Pipeline ميفشلش
                    git commit -m "Update image version to ${BUILD_NUMBER}" || true
                    git push origin main
                '''
        }
    }
}


}

