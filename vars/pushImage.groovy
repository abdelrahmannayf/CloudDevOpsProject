def call(String imageName) {
    withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
        sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
        sh "docker push ${imageName}:latest"
    }
}
