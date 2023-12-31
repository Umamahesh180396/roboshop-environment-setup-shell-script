#!/usr/bin/env bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "cart" "user" "shipping" "payments" "web" "dispatch")
INSTANCE_TYPE=""
IMAGE_ID="ami-03265a0778a880afb"
SECURITY_GROUP_ID="sg-0e658def150f1a79a"
DOMAIN_NAME=robomart.cloud

# mysql and mongodb instance type shound be t3.medium, for rest t3.micro
for i in "${NAMES[@]}"
do
    if [[ $i == "mysql" || $i == "mongodb" ]]
    then
        INSTANCE_TYPE="t3.medium" 
    else
        INSTANCE_TYPE="t3.micro"
    fi
    
    echo "Creating $i Instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "Created $i Instance: $IP_ADDRESS"
    
    aws route53 change-resource-record-sets --hosted-zone-id Z05444922ON0WMH1WD9T0 --change-batch '
    {
                "Changes": [{
                "Action": "CREATE",
                            "ResourceRecordSet": {
                                "Name": "'$i.$DOMAIN_NAME'",
                                "Type": "A",
                                "TTL": 300,
                                "ResourceRecords": [{"Value": "'$IP_ADDRESS'"}]
                            }}]
    }
    '
done