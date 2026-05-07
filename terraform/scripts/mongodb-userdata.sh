#!/bin/bash
set -e

apt-get update -y
apt-get install -y docker.io awscli

systemctl enable docker
systemctl start docker

mkdir -p /opt/mongo-data

docker run -d \
  --name mongodb \
  --restart always \
  -p 27017:27017 \
  -v /opt/mongo-data:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME="${mongodb_username}" \
  -e MONGO_INITDB_ROOT_PASSWORD="${mongodb_password}" \
  mongo:4.4

sleep 30

docker exec mongodb mongo \
  -u "${mongodb_username}" \
  -p "${mongodb_password}" \
  --authenticationDatabase admin \
  --eval 'db.getSiblingDB("tasky").tasks.insertOne({title:"Wiz technical exercise initialized", completed:false, createdAt:new Date()})'