FROM python:3.7-alpine

RUN apk add --update --no-cache \
    bash \
    jq && \
    pip3 install --upgrade --user awscli && \
    export PATH=${HOME}/.local/bin:${PATH} && \
    aws --version

RUN pip3 install ecs-deploy

COPY cmd.sh /bin/

ENTRYPOINT [ "/bin/bash", "-l", "-c"]

CMD [ "/bin/cmd.sh" ]