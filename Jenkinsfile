 pipeline {
    agent any 
    stages 
    {
        stage ('Extract') {
          checkout scm
          gitCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
          echo "checked out git commit ${gitCommit}"
          sh '''

          rm -rf bin
          rm -rf build
          '''
        }
        stage ('docker') { 
            def imageTag = "mycluster.icp:8500/vue/vue:${gitCommit}"
            echo "imageTag ${imageTag}"
            sh """
            docker build -t vuejs/dockerize-vuejs-app .
            docker tag dockerize-vuejs-app ${imageTag}
            docker push $imageTag
            """
        }
    }
}
