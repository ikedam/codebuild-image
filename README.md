# Custom Code Build image to use public.ecr.aws transparently

## Usage

TODO: How to push to private ecr and how to use that from codebuild.

## Local evaluation

To see what this does in your local environment:

1. Configure your environemnt variables properly to authenticate for AWS:

    ```sh
    export AWS_ACCESS_KEY_ID=...
    export AWS_SECRET_ACCESS_KEY=...
    ```

2. Get authentication token with `aws ecr-public get-authorization-token` and set that to `ECR_PUBLIC_AUTHORIZATION_TOKEN`:

    ```sh
    export ECR_PUBLIC_AUTHORIZATION_TOKEN=$(docker-compose run --rm aws ecr-public get-authorization-token --region us-east-1 --output=text --query authorizationData.authorizationToken)
    ```

    * Specify always `us-east-1`.
    * See https://docs.aws.amazon.com/AmazonECR/latest/public/public-registries.html#public-registry-auth for more details.

3. Run the image

    ```sh
    docker-compose run --rm codebuild /bin/bash
    ```

4. See you can't connect to dockerhub.

    ```sh
    wget -O - https://registry-1.docker.io/v2/
    ```

5. You can download images via public.ecr.aws transparently.

    ```sh
    docker pull hello-world
    ```
