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

          docker build . -t sharksdcoker/nodeapp:v1
          docker images
              (You can see all images)
              
For now, we are not focusing on CI/CD pipeline. We try to see if it works or not using Dockerfile. Then, we can see if we can **dockerize**
node.js application.




          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          









