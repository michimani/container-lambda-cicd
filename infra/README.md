infra
===

- ECR Repository
- Lambda Function
  - Role for the function
  - Policy for the role
- SQS Queue


## Preparing

1. create `main.tf`

    ```bash
    cp main.tf.sample main.tf
    ```
    
    And fill in the blanks with your data.

2. run `terraform init`    

    ```bash
    terraform init
    ```
    
## Apply

1. Only apply ECR Repository

    First, apply only resource of ECR Repository.

    ```bash
    terraform apply --target=aws_ecr_repository.sqs_lambda_example_function
    ```

    Then, push the first image to this repository following [lambda/README.md](../lambda/README.md).

1. Apply other resources

    ```bash
    terraform apply
    ```
