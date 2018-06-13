podTemplate(label: 'icp-build', 
    containers: [
        containerTemplate(name: 'docker', image: 'ibmcom/docker:17.10', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'nginx', image: 'nginx', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'kubectl', image: 'ibmcom/k8s-kubectl:v1.8.3', ttyEnabled: true, command: 'cat')
    ],

) 
{
    node ('icp-build') {
        def gitCommit
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
          container('docker') {
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
}
