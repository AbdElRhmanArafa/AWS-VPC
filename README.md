# AWS VPC Setup Script 
---

# AWS VPC Setup Script

This script creates a Virtual Private Cloud (VPC) along with public and private subnets, route tables, and an Internet Gateway on AWS using the AWS CLI.

## Prerequisites

Before running the script, ensure you have the following:

- **AWS CLI** installed and configured with proper credentials.
- **Bash** (for Unix-like systems).
- **IAM permissions** to create VPCs, subnets, route tables, and internet gateways.
  
## Steps

### 1. Install and Configure AWS CLI
If you don't have AWS CLI installed, follow the [official guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) to install it. Once installed, configure it using:

```bash
aws configure
```

Provide the following details:
- AWS Access Key ID
- AWS Secret Access Key
- Default region name (e.g., `us-east-1`)
- Default output format (e.g., `json`)

### 2. Execute the Script

To create the VPC and its associated resources, follow these steps:

1. **Clone or download** the script.
2. **Make the script executable** if it isn't already:

   ```bash
   chmod +x create-vpc.sh
   ```

3. **Run the script**:

   ```bash
   ./create-vpc.sh
   ```

The script will do the following:
- Create a VPC with a CIDR block of `10.0.0.0/16`.
- Create two public subnets (one in each availability zone) and two private subnets.
- Modify the public subnets to auto-assign public IP addresses.
- Create an Route Table and Explicit subnet associations it with the private subnets.
- Create an Internet Gateway and attach it to the VPC.
- Set up route tables for public subnets to route traffic `0.0.0.0/0` to the Internet Gateway.
### 3. Variables Used

The script defines several variables that can be modified to suit your environment:

- `REGION`: The AWS region to create the resources in (default is `us-east-1`).
- `TAG_VPC_NAME`: Name for the VPC.
- `TAG_IGW_NAME`: Name for the Internet Gateway.
- `TAG_RT_NAME`: Name for the Route Table.
- `TAG_PUBLIC_SUBNET_1A_NAME`, `TAG_PUBLIC_SUBNET_1B_NAME`: Names for public subnets.
- `TAG_PRIVATE_SUBNET_1A_NAME`, `TAG_PRIVATE_SUBNET_1B_NAME`: Names for private subnets.
- `VPC_CIDR`, `PUBLIC_SUBNET_1A_CIDR`, `PUBLIC_SUBNET_1B_CIDR`, `PRIVATE_SUBNET_1A_CIDR`, `PRIVATE_SUBNET_1B_CIDR`: CIDR blocks for the VPC and subnets.

### 4. Output

The script will output the IDs of the created resources such as:
- VPC ID
- Subnet IDs (public and private)
- Route Table ID
- Internet Gateway ID
![Output](https://raw.githubusercontent.com/AbdElRhmanArafa/AWS-VPC/img/Resource%20map.png)

