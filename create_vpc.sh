#!/bin/bash

# Variables

REGION="us-east-1"
TAG_VPC_NAME="MyVPC"
TAG_IGW_NAME="MyIGW"
TAG_RT_NAME="Private-RT"
TAG_PUBLIC_SUBNET_1A_NAME="Public-1A"
TAG_PUBLIC_SUBNET_1B_NAME="Public-1B"
TAG_PRIVATE_SUBNET_1A_NAME="Private-1A"
TAG_PRIVATE_SUBNET_1B_NAME="Private-1B"
VPC_CIDR="10.0.0.0/16"
PUBLIC_SUBNET_1A_CIDR="10.0.1.0/24"
PUBLIC_SUBNET_1B_CIDR="10.0.2.0/24"
PRIVATE_SUBNET_1A_CIDR="10.0.3.0/24"
PRIVATE_SUBNET_1B_CIDR="10.0.4.0/24"

# Create VPC
echo "Creating VPC..."
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --region $REGION --query 'Vpc.VpcId' --output text)
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$TAG_VPC_NAME --region $REGION
echo "VPC ID '$VPC_ID' created."

# Create public subnet 1A
echo "Creating public subnet 1A..."
PUBLIC_SUBNET_1A_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PUBLIC_SUBNET_1A_CIDR --availability-zone $REGION"a" --region $REGION --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $PUBLIC_SUBNET_1A_ID --tags Key=Name,Value=$TAG_PUBLIC_SUBNET_1A_NAME --region $REGION
echo "Public subnet 1A ID '$PUBLIC_SUBNET_1A_ID' created."
# edit piblic subnet 1A to auto-assign public IP
aws ec2 modify-subnet-attribute --subnet-id $PUBLIC_SUBNET_1A_ID --map-public-ip-on-launch

# Create public subnet 1B
echo "Creating public subnet 1B..."
PUBLIC_SUBNET_1B_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PUBLIC_SUBNET_1B_CIDR --availability-zone $REGION"b" --region $REGION --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $PUBLIC_SUBNET_1B_ID --tags Key=Name,Value=$TAG_PUBLIC_SUBNET_1B_NAME --region $REGION
echo "Public subnet 1B ID '$PUBLIC_SUBNET_1B_ID' created."
# edit piblic subnet 1B to auto-assign public IP
aws ec2 modify-subnet-attribute --subnet-id $PUBLIC_SUBNET_1B_ID --map-public-ip-on-launch

# Create private subnet 1A
echo "Creating private subnet 1A..."
PRIVATE_SUBNET_1A_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PRIVATE_SUBNET_1A_CIDR --availability-zone $REGION"a" --region $REGION --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $PRIVATE_SUBNET_1A_ID --tags Key=Name,Value=$TAG_PRIVATE_SUBNET_1A_NAME --region $REGION
echo "Private subnet 1A ID '$PRIVATE_SUBNET_1A_ID' created."

# Create private subnet 1B
echo "Creating private subnet 1B..."
PRIVATE_SUBNET_1B_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PRIVATE_SUBNET_1B_CIDR --availability-zone $REGION"b" --region $REGION --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $PRIVATE_SUBNET_1B_ID --tags Key=Name,Value=$TAG_PRIVATE_SUBNET_1B_NAME --region $REGION
echo "Private subnet 1B ID '$PRIVATE_SUBNET_1B_ID' created."

# Create Route Table
echo "Creating route table..."
RT_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --region $REGION --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-tags --resources $RT_ID --tags Key=Name,Value=$TAG_RT_NAME --region $REGION
# ASSociate route table with private subnet
aws ec2 associate-route-table --route-table-id $RT_ID --subnet-id $PRIVATE_SUBNET_1A_ID --region $REGION
aws ec2 associate-route-table --route-table-id $RT_ID --subnet-id $PRIVATE_SUBNET_1B_ID --region $REGION
echo "Route table ID '$RT_ID' created."

# Create Internet Gateway
echo "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway --region $REGION --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 create-tags --resources $IGW_ID --tags Key=Name,Value=$TAG_IGW_NAME --region $REGION
aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION
echo "Internet Gateway ID '$IGW_ID' created."

# Create Route
echo "Creating route..."
# Get Main Route Table ID
echo "Getting Main Route Table ID..."
MAIN_ROUTE_TABLE_ID=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" "Name=association.main,Values=true" --query 'RouteTables[0].RouteTableId' --output text)
echo "Main Route Table ID: $MAIN_ROUTE_TABLE_ID"

# Add route to the main route table (0.0.0.0/0 to the Internet Gateway)
echo "Creating route in Main Route Table to Internet Gateway..."
aws ec2 create-route --route-table-id $MAIN_ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
echo "Route to Internet Gateway created in Main Route Table"
sleep 2
# echo "finished..."