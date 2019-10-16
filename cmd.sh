#!/bin/bash

# Export path to AWS cli
export PATH=${HOME}/.local/bin:${PATH}

if [ -z ${PLUGIN_CLUSTER} ]; then
  echo '"cluster" is missing. Add target "cluster" to your pipline settings'
  exit 1
fi

if [ -z ${PLUGIN_SERVICE} ]; then
  echo '"service" is missing. Add target "service" to your pipline settings'
  exit 1
fi

if [ -z ${PLUGIN_IMAGE} ]; then
  echo '"image" is missing. Add "image" that wanted to be deployed to your pipline settings'
  exit 1
fi

if [ -z ${PLUGIN_CONTAINER} ]; then
  echo '"container" is missing. Add "container" that wanted to be deployed to your pipline settings'
  exit 1
fi

if [ -z ${PLUGIN_AWS_REGION} ]; then
  echo '"aws_region" is not specified, using default region: us-east-1'
  PLUGIN_AWS_REGION="us-east-1"
fi

if [ -z ${PLUGIN_TIMEOUT} ]; then
  echo '"timeout" is not specified, using default timeout: 300'
  PLUGIN_TIMEOUT="300"
fi

if [ ! -z ${PLUGIN_AWS_ASSUME_ROLE_ARN} ]; then
  echo "Assuming: ${PLUGIN_AWS_ASSUME_ROLE_ARN}"
  ROLE_SESSION_NAME=$(echo ${DRONE_REPO_OWNER}-${DRONE_REPO_NAME}-${DRONE_COMMIT} | cut -c1-64)
  CREDS=`aws sts assume-role --role-arn ${PLUGIN_AWS_ASSUME_ROLE_ARN} --role-session-name=${ROLE_SESSION_NAME}`

  export AWS_ACCESS_KEY_ID=`echo $CREDS | jq -r '.Credentials.AccessKeyId'`
  export AWS_SECRET_ACCESS_KEY=`echo $CREDS | jq -r '.Credentials.SecretAccessKey'`
  export AWS_SESSION_TOKEN=`echo $CREDS | jq -r '.Credentials.SessionToken'`

  if [ -z ${AWS_ACCESS_KEY_ID} ]; then
    echo "Assuming FAILED"
    exit 1
  fi
else
  if [ ! -z ${PLUGIN_AWS_ACCESS_KEY_ID} ]; then
    AWS_ACCESS_KEY_ID=$PLUGIN_AWS_ACCESS_KEY_ID
  fi

  if [ ! -z ${PLUGIN_AWS_SECRET_ACCESS_KEY} ]; then
    AWS_SECRET_ACCESS_KEY=$PLUGIN_AWS_SECRET_ACCESS_KEY
  fi
fi

aws sts get-caller-identity

ecs deploy ${PLUGIN_CLUSTER} ${PLUGIN_SERVICE} --image ${PLUGIN_CONTAINER} ${PLUGIN_IMAGE} --region ${PLUGIN_AWS_REGION} --timeout ${PLUGIN_TIMEOUT}
