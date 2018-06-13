podTemplate(label: 'icp-build', 
    containers: [
        containerTemplate(name: 'docker', image: 'docker', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'nodejs', image: 'node', ttyEnabled: true, command: 'cat')
    ]) 
{
    node ('icp-build') {
        def gitCommit
        stage ('Extract') {
          checkout scm
          gitCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
          echo "checked out git commit ${gitCommit}"
          sh '''
          cd src
          rm -rf bin
          rm -rf build
          '''
        }
        stage ('build') {
          container('nodejs') {
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
