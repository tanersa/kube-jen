pipeline {
    agent any 
    environment {
        DOCKER_TAG = getDockerTag()
        registry = "sharksdocker/nodeapp"
        registryCredential = "sharkshub"
    }
    stages {
        stage ('Build docker image') {
            steps {
                sh "docker build . -t sharksdocker/nodeapp:${DOCKER_TAG}"
            }
        }
        stage ('Push docker image') {
            steps {
                script {
                    docker.withRegistry('',registryCredential){
                    sh "docker push sharksdocker/nodeapp:${DOCKER_TAG}"
                }
            }
        }
        }
        stage ('Deploy to EKS') {
            steps {
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sshagent(['eks-machine']) {
                sh "scp -o StrictHostKeyChecking=no nodeapp-service.yaml node-app.yaml ec2-user@3.22.98.102:/home/ec2-user"
                script {
                    try {
                        sh "ssh ec2-user@3.22.98.102 kubectl apply -f ."
                    }catch(error) {
                        sh "ssh ec2-user@3.22.98.102 kubectl create -f ."
                    }
                    
                    }
                }
            }
        }

    }
}
def getDockerTag() {
    def tag = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}