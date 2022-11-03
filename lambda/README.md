container-lambda-function
---

AWS Lambda functions using container images.

## Run at local

0. Login to ECR

    ```bash
    REGION='ap-northeast-1'
    AWS_ACCOUNT_ID=$(
      aws sts get-caller-identity \
      --query 'Account' \
      --output text) \
    && aws ecr get-login-password \
      --region "${REGION}" \
      | docker login \
      --username AWS \
      --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
    ```

1. Build

    ```bash
    docker build -t container-lambda-function -f Dockerfile_local .
    ```
    
    For production. (use alpine base image)
    
    ```bash
    docker build -t container-lambda-function .
    ```

2. Run the image

    ```bash
    docker run \
    --rm \
    -p 9000:8080 \
    container-lambda-function:latest
    ```

3. Invoke function

    ```bash
    curl -X POST \
    -H 'Content-Type: application/json' \
    http://localhost:9000/2015-03-31/functions/function/invocations
    ```

## Push to ECR Repository

After creating ECR Repository, push built image to there.

1. Create tag

    ```bash
    docker tag \
    container-lambda-function:latest \
    "${AWS_ACCOUNT_ID}".dkr.ecr."${REGION}".amazonaws.com/container-lambda-repository:latest
    ```

2. Push

    ```bash
    docker push "${AWS_ACCOUNT_ID}".dkr.ecr."${REGION}".amazonaws.com/container-lambda-repository:latest
    ```
