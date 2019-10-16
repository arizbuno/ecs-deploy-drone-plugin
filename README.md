# ecs-deploy-drone-plugin
A thin wrapper of [fabfuel/ecs-deploy](https://github.com/fabfuel/ecs-deploy) to be simple Drone Plugin with STS AssumeRole support.

## Usage

### Using sts:AssumeRole

This stage will update `our_container` inside the task in `our_service` on `our_cluster` to use `our_image` using `our_role_arn` role.

```
- name: Deploy
  image: arizbuno/ecs-deploy-drone-plugin
  settings:
    aws_region: ap-southeast-1
    aws_assume_role_arn: our_role_arn
    cluster: our_cluster
    service: our_service
    container: our_container
    image: our_image
```

### Using sts:AssumeRole

This stage will update `our_container` inside the task in `our_service` on `our_cluster` to use `our_image` using the credential given. It is adviced to use secret.

```
- name: Deploy
  image: arizbuno/ecs-deploy-drone-plugin
  settings:
    aws_region: ap-southeast-1
    aws_access_key_id: our_aws_access_key_id
    aws_secret_access_key: our_aws_secret_key
    cluster: our_cluster
    service: our_service
    container: our_container
    image: our_image
```

### Using Instance IAM Role

This stage will update `our_container` inside the task in `our_service` on `our_cluster` to use `our_image` using instance IAM role.

```
- name: Deploy
  image: arizbuno/ecs-deploy-drone-plugin
  settings:
    aws_region: ap-southeast-1
    cluster: our_cluster
    service: our_service
    container: our_container
    image: our_image
```

## Optional Parameter

`timeout` - [Integer] Timeout in second for ECS deploy to wait until the service is up.