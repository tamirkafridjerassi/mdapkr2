# MDAPKR2 - Serverless Crew Scheduler

A serverless crew scheduling system designed for managing mission assignments, crew data, and availability through a dynamic web interface. Built for scalability and simplicity using AWS and Terraform.

## Features

- Add and view **crew** with roles (Driver, EMT, PARA)
- Add and view **missions** with regional & type attributes
- Interactive **availability** grid with per-day toggles
- Infrastructure as code with **modular Terraform**
- Deployed entirely on **AWS (Lambda, DynamoDB, API Gateway, S3)**

---

## Architecture Overview

```
                                       +----------------+
                                       |   End Users    |
                                       +--------+-------+
                                                |
                                                v
                                +---------------+----------------+
                                |      S3 Static Website         |
                                |      (HTML + JS Frontend)      |
                                +---------------+----------------+
                                                |
                                                v
                                +---------------+----------------+
                                |     API Gateway (HTTP API)     |
                                |   Route: ANY /{proxy+}         |
                                +---------------+----------------+
                                                |
                                                v
                              +-----------------+-----------------+
                              |      Lambda Function (Python)     |
                              |    handler.py with business logic |
                              +-----------------+-----------------+
                                                |
           +---------------------------+---------+---------+----------------------------+
           |                           |                   |                            |
           v                           v                   v                            v
+------------------+      +----------------------+    +-------------------+    +--------------------------+
| DynamoDB - Crew  |      | DynamoDB - Missions  |    | DynamoDB - Avail. |    | CloudWatch Logs (Debug) |
+------------------+      +----------------------+    +-------------------+    +--------------------------+

```

---

## Project Structure

```
mdapkr2/
├── backend/              # Python Lambda code
│   ├── handler.py
│   ├── requirements.txt
│   └── build/            # Zip artifact for Lambda
├── frontend/             # Static HTML/JS frontend
│   └── index.html
├── infra/                # Terraform infrastructure
│   ├── main.tf
│   ├── variables.tf
│   ├── modules/          # Modular components
│   │   ├── lambda/
│   │   ├── s3/
│   │   ├── dynamodb/
│   │   ├── iam/
│   │   └── api_gateway/
├── scripts/
│   └── upload_to_s3.sh
└── README.md
```

---

## Deployment Instructions

### Prerequisites

- AWS CLI configured
- Terraform CLI installed
- Python 3.12 installed
- Git + zip tools available

### 1. Deploy Infrastructure

```bash
cd infra
terraform init
terraform apply -var="suffix=your-unique-suffix"
```

### 2. Build & Upload Lambda

```bash
cd backend
mkdir -p build
pip install -r requirements.txt -t build/
cp handler.py build/
cd build
zip -r lambda.zip .
aws lambda update-function-code --function-name mdapkr2_scheduler --zip-file fileb://lambda.zip
```

### 3. Upload Frontend

```bash
cd ../../scripts
./upload_to_s3.sh
```

---

## Usage

- Open the **S3 website URL** (printed from Terraform)
- Use UI to add crew, assign missions, toggle availability
- API traffic routed via **API Gateway** to the Lambda backend

---

## Maintainer

**Tamir Kafri Djerassi**  
[https://github.com/tamirkafridjerassi](https://github.com/tamirkafridjerassi)

---

## License

This project is open source under the MIT License.
