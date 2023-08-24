#!/usr/bin/env bash

NAMES=("MongoDB-Catalogue-User" "Redis-Cart-User" "MySQL-Shipping" "RabbitMQ-Payments" "Catalogue-NodeJS" "Cart-NodeJS" "User-NodeJS" "Shipping-Java" "Payments-Python" "Nginx-Web")
INSTANCE_TYPE=""
IMAGE_ID="ami-03265a0778a880afb"
SECURITY_GROUP_ID="sg-0e658def150f1a79a"

# MySQL-Shipping and MongoDB-Catalogue-User instance type shound be t3.medium, for rest t3.micro
for i in "${NAMES[@]}"
do
    if [[ $i == "MySQL-Shipping" || $i == "MongoDB-Catalogue-User" ]]
    then
        INSTANCE_TYPE="t3.medium" 
    else
        INSTANCE_TYPE="t3.micro"
    fi
    
    echo "Creating $i Instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "Created $i Instance: $IP_ADDRESS"
done