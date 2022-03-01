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
We build artifacts (archieve files), executable files  using maven.







               








  
  
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          









