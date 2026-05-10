#!/bin/bash
set -e

apt-get update -y
apt-get install -y docker.io awscli cron

systemctl enable docker
systemctl start docker
systemctl enable cron
systemctl start cron

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

cat > /usr/local/bin/mongo-backup.sh <<'EOF'
#!/bin/bash

BUCKET_NAME="${mongodb_backup_bucket}"
BACKUP_FILE="mongodb-backup-$(date +%Y%m%d-%H%M%S).archive"

docker exec mongodb mongodump \
  --uri="mongodb://${mongodb_username}:${mongodb_password}@127.0.0.1:27017/?authSource=admin" \
  --archive="/tmp/$BACKUP_FILE"

docker cp "mongodb:/tmp/$BACKUP_FILE" "/tmp/$BACKUP_FILE"

aws s3 cp "/tmp/$BACKUP_FILE" "s3://$BUCKET_NAME/backups/$BACKUP_FILE"

rm -f "/tmp/$BACKUP_FILE"
docker exec mongodb rm -f "/tmp/$BACKUP_FILE" || true

echo "Backup uploaded to S3 successfully: s3://$BUCKET_NAME/backups/$BACKUP_FILE"
EOF

chmod +x /usr/local/bin/mongo-backup.sh

echo "0 * * * * /usr/local/bin/mongo-backup.sh >> /var/log/mongo-backup.log 2>&1" | crontab -

/usr/local/bin/mongo-backup.sh >> /var/log/mongo-backup.log 2>&1