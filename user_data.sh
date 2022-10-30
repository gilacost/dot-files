#!/bin/bash -ex

# Adds node secure repo
sudo curl -sL https://rpm.nodesource.com/setup_15.x | sudo bash -

# Install node
sudo yum install -y nodejs

# Create a dedicated directory for the application
sudo mkdir -p /var/app

# Get the app from S3
wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/ILT-TF-100-TECESS-5/app/app.zip

# Unzip it into the specific folder
sudo unzip app.zip -d /var/app

# Set current directory to /var/app
cd /var/app

# Install dependencies
sudo npm install

# Env vars override
sudo rm /var/app/api/common/constants.js
(sudo cat <<- _EOF_
exports.NODE_ENV = 'production';
exports.PORT = 80;
exports.AWS_PROFILE = '${aws_iam_instance_profile.ec2_profile.name}';
exports.PHOTOS_BUCKET = '${aws_s3_bucket.employee_webapp.bucket}';
exports.AWS_REGION = '${local.region}'
exports.DEFAULT_AWS_REGION = '${local.region}';
exports.SHOW_WARNINGS = 1;
exports.SHOW_ADMIN_TOOLS = 1;
exports.TABLE_NAME = 'Employees';
_EOF_
) > /var/app/api/common/constants.js

# Start your app
sudo npm start