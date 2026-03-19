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
            sh '''
            git config --global user.name "jenkins"
            git config --global user.email "jenkins@example.com"

            git add .
            git commit -m "Update image version"
            git push
            '''
        }
    }
}


}

