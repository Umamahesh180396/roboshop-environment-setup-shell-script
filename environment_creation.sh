#!/usr/bin/env bash

NAMES=("MongoDB-Catalogue-User" "Redis-Cart-User" "MySQL-Shipping" "RabbitMQ-Payments" "Catalogue-NodeJS" "Cart-NodeJS" "User-NodeJS" "Shipping-Java" "Payments-Python" "Nginx-Web")

for i in "${NAMES[@]}"
do
    echo "Name: $i"
done