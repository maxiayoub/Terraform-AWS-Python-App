#!/bin/bash

# Set AWS credentials
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=${{ vars.AWS_REGION }}
export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
export SSH_KEY_PATH=$SSH_KEY_PATH
export EC2_PUBLIC_IP="44.211.144.45"

# Copy application code to EC2 instance
scp -i $SSH_KEY_PATH -r $APP_PATH ec2-user@$EC2_PUBLIC_IP:/home/python-app

# SSH into EC2 instance and start application server
ssh -i $SSH_KEY_PATH ec2-user@$EC2_PUBLIC_IP "cd /home/python-app && python app.py"
