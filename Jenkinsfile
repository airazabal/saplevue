def volumes = [ hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock') ]
volumes += secretVolume(secretName: 'alex-jenkins-dev-ibm-jen', mountPath: '/msb_reg_sec')
print "volumes: ${volumes}" 
podTemplate(name: 'alex-node', label: 'alex-node'
    containers: [
        containerTemplate(name: 'nodejs', image: 'node', ttyEnabled: true, command: 'cat')
    ],
    volumes: volumes
) 
{
    node ('alex-node') {
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
    }
    }
