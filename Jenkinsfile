def volumes = [ hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock') ]
volumes += secretVolume(secretName: 'alex-jenkins-dev-ibm-jen', mountPath: '/msb_reg_sec')
print "volumes: ${volumes}" 
podTemplate(name: 'icp-build', label: 'icp-build', inheritFrom: 'default', cloud: 'default',
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
            echo "inside node"
            sh '''
            cd src
            npm -g install grunt-cli karma bower
            npm install
            bower install --allow-root
            grunt build
            grunt compile
            cd ..
            '''
          }
        }
        stage ('docker') { 
          container('docker') {
            def imageTag = "mycluster.icp:8500/nm-pilot/flashboard-angularui:${gitCommit}"
            echo "imageTag ${imageTag}"
            sh """
            docker build -t flashboard-angularui .
            docker tag flashboard-angularui ${imageTag}
            ln -s /msb_reg_sec/.dockercfg /home/jenkins/.dockercfg
            mkdir /home/jenkins/.docker
            ln -s /msb_reg_sec/.dockerconfigjson /home/jenkins/.docker/config.json
            docker push $imageTag
            """
          }
        }
    }
    }
