def volumes = [ hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock') ]
volumes += secretVolume(secretName: 'microclimate-icp-secret', mountPath: '/msb_reg_sec')
podTemplate(label: 'icp-build', 
    containers: [
        containerTemplate(name: 'docker', image: 'ibmcom/docker:17.10', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'nodejs', image: 'node', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'kubectl', image: 'ibmcom/k8s-kubectl:v1.8.3', ttyEnabled: true, command: 'cat')
    ],
    volumes: volumes
) 
{
    node ('icp-build') {
        def gitCommit
        stage ('Extract') {
          checkout scm
          gitCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
          echo "checked out git commit ${gitCommit}"
        }
       stage ('build') {
          container('nodejs') {
            sh '''
            npm install
            '''
          }
        }
        stage ('docker') { 
          container('docker') {
            def imageTag = "mycluster.icp:8500/vuejs/dockerize-vuejs-app:${gitCommit}"
            echo "imageTag ${imageTag}"
            sh """
            docker build -t vuejs/dockerize-vuejs-app .
            docker tag vuejs/dockerize-vuejs-app ${imageTag}
            docker push $imageTag
            """
          }
        }
        stage ('Run') {
          echo "starting the run stage"
          sh """
          docker run -it -p 8080:8080 --rm --name dockerize-vuejs-app vuejs/dockerize-vuejs-app
          """
        }
    }
}
