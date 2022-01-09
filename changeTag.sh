#!/bin/bash
sed "s/tagVersion/$1/g" nodeapp-deploy.yaml > node-app.yaml