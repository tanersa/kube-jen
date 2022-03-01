# K8S - CI/CD NodeJS App Deployment

<br />

**E2E Solution to Build CI/CD Pipeline by Leveraging K8S**

&nbsp; &nbsp; Continous integration **(CI)** starts on GitHub after developers cheks in their changes. From that point, **DevOps** engineers build logic to do 
Continous Deployment **(CD)** and Continous Development **(CD)**.

<br />

Let's plan our containerized application and create a **Dockerfile**.

First, we need to make sure how it works in Development environment. Once we do good everything in DEV, then come to PRODUCTION environment and 
everything is ready!. Therefore, the most important point is coming to production with bug free code.

<br />

It will be **node.js** web application, so we have to go to Docker hub first.

   -  Create a dockerfile.

          FROM node:carbon

          #Create app directory 
          WORKDIR /usr/src/app 

          #Install app dependencies
          COPY package*.json ./

          RUN npm install 


          COPY . . 

          EXPOSE 8080 
          CMD ["npm", "start"]
          
   -  Build your image now.

          docker build . -t c
          docker images
              (You can see all images)
              
For now, we are not focusing on CI/CD pipeline. We try to see if it works or not using Dockerfile. Then, we can see if we can **dockerize**
node.js application.

   -  Push your images to Docker Hub.

               docker login
                  (enter credentials)
               docker push sharksdcoker/nodeapp:v1
               
   -  Create a container as nodeapp

               docker run -d --name nodeapp -p 8080:8080 sharksdcoker/nodeapp:v1    
               
   -  Verify container is created

               docker ps
               
   -  Paste "localhost:8080" on your browser

               you'll see the application on browser.
               
It means our containers worked!

<br />

**Now, let's think bigger. Do we really need to create containers if we use K8S ?**

&nbsp; &nbsp; No, we don't. K8S can create containers by itself so, we leave heavy lifting to K8S.
  
**K8S** will create container in **Deployment POD** after building images.

   -  First, we create instance for **jenkins** server and ssh to your instance.
   -  Install java (as its pre-requisite for jenkins) on your jenkins machine. 
   -  Install jenkins on the machine.
   -  Verify whether you have jenkins image

               docker images
                   jenkins/jenkins:latest 
                   
   -  Run docker container

               docker run -d --name jenkins -p 8080:8080 jenkins/jenkins:latest     
               
   -  Go to browser and run "localhost:8080"

               Jenkins is up and running
               
**We just started Jenkins in docker container!**   

<br />

   -  Go inside the jenkins container and copy the initial pwd for jenkins in order to login Jenkins dashboard.

               /var/jenkins_home/secrets/initialAdminPasssword
               
   -  Go to Jenkins GUI and login to Jenkins then install suggested plugins.

<br />

**Next**: 

Build your **Jenkins File** to define your steps in CI/CD pipeline.

               pipeline {
                   agent any
                   stages {
                       stage ('Build docker image') {
                           steps {
                               sh "docker build . -t sharksdocker/nodeapp:${DOCKER_TAG}"
                           }
                       }
                    }  
                 }  

   -  Configure your Jenkins dashboard
   -  Go to Pipeline > Pipeline script from SCM > Git > Repository URL 
        Paste the GITHUB URL for project.
  
**Deployment is more reliable than PODs. We create Deployment and there is POD inside Deployment.**

<br />

**Running K8S with CI/CD**

&nbsp; &nbsp; First, we plan CI/CD pipeline, and based on our plan we are going to build our code. After developing our code, we need to build the code.
We build artifacts (archieve files), executable files  using maven. Then we test it, how our code works. If everything is successfull with testing, integration testing, load testing, stress testing, regression test then we **release** it.

&nbsp; &nbsp; After release happens like release-1, release-2, release-3 then we deploy it. We deploy to the container and operate this code then monitor
the applicatton


**JENKINS PUTS ALL THE PIECES TOGETHER AND DO IT CONTINOUSLY. JENKINS IS A GLUE IN THE PROJECT**        

   -  Verify if your Cluster is in good condition

               K8S is an instance 
               kubectl get nodes
               
   -  To create a container from **image**;    

               docker run -d --name jenkins -p 8080:8080 jenkins/jenkins:latest
               
   -  To get admin pwd inside container 

               docker exec -it jenkins /bin/bash       

               localhost:8080 we put this on browser and start jenkins
               
               Then we unlock the jenkins.

Our cluster is on Instance
Jenkins is on local computer.

   -  Here we used package.json and server.json.

PACKAGE.JSON ---> This is a dependency for node.js application.

   -  Go to Jenkins Dashboard and create pipeline.

               Pipeline:
                  Add GitHub URL
                  
               Branch:
                  master
               Script Path:
                  jenkins file
                  
                  
   -  APPLY AND SAVE 
   -  BUILD NOW. 

   -  Install docker into container (Jenkins machine)

   - Go inside jenkins container

               docker exec -it jenkins /bin/bash 
               
**We need to run everything as a jenkins user, we can not run as a root.**   

<br />

So, lets install **docker inside docker container.**

We install containers in Dockerfile

We have steps for CI/CD pipeline in Jenkins file.

   -  Install docker in docker machine
   -  Install docker plugin in Jenkinns GUI.

Let's create **more modular** image tag by assigning commit id of code change to image tag.

This will help us to trouble shoot much easier in the future. Furthermore, we can segregate our resources.

In order to do that we need to create some custom functions inside Jenkinsfile, so we can leverage functional programming.

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
                       
                def getDockerTag() {
                      def tag = sh script: 'git rev-parse HEAD', returnStdout: true
                      return tag
                  }       

As you can see, we made Image tag more dynamic by STRING interpolaton

          h "docker build . -t sharksdocker/nodeapp:${DOCKER_TAG}"
                       
   -  Configure Jenkins GUI:'

               Mange Jenkins > Manage Credenttials > Jenkins Global Credentials
               Add Credentials > username with pwd (For Dockr hub)
               OK
  
<br />

**WEBHOOKS**

Whenever we push, we want to run Jenkins file automatically. For that we use **WebHooks** on GitHub.

Basically, when specified event happens, we'll send POST request to each URL provided because everything is Event Based.

Whenever we push, we want to have Automaticc Trigger!

Simply add PayLoad URL which is Jenkins URL to below directory on Github

               Webhooks > Add Webhook > Payload URL
               
               Payload URL: http://localhost:8080/github-webhook
               
               Content Type: Application/json
               
               Select event that you would like to trigger.
               
Our Webhook is ready! We pushed our image to dockerhub.

**We need to pull the image and create container**

However, we will use Kubernetes for that. 

Our K8S cluster is up and running. 

               kubectl get nodes
                   (There are two worker nodes)
                   
**Now, we are going to deploy our application to this K8S Cluster.**

In order to do that:

   -  First, we need to create our Deployment file.
   -  Second, we need to create our Service file. 

               nodeapp-deploy.yaml

               apiVersion: apps/v1
               kind: Deployment 
               metadata:
                 name: nodeapp 
                 labels:
                   app: nodeapp 
               spec:
                 replicas: 2
                 selector:
                   matchLabels: 
                     app: nodeapp 
                 template: 
                   metadata: 
                     labels:
                       app: nodeapp 
                   spec:
                     containers: 
                     - name: nodeapp 
                       image: sharksdocker/nodeapp:tagVersion
                       ports:
                       - containerPort: 8080

               ---
               
               kind: Service 
               apiVersion: v1
               metadata:
                 name: nodeapp 
               spec:
                 selector:
                   app: nodeapp 
                 ports:
                 - protocol: TCP 
                   port: 80
                   targetPort: 8080
                 type: LoadBalancer
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
               


































               




               
               
               
               







               








  
  
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          









