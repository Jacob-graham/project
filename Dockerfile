#--------- BEGIN DEVELOPER MODIFY FOR YOUR BUILD PROCESS ---------#
#Do not change the "AS build_image" part on the FROM
FROM gcr.io/zoominfo-container-registry/zoom-node:12.20.0-alpine3.10 AS build_image
#Do not remove the BUILD_ACTION ARG, you can change its default value. You must use it in your build command in the RUN section for Jenkins to deploy your artifact.
ARG ACTION=install
ARG ARTIFACTORY_USERNAME
ARG ARTIFACTORY_PASSWORD
ENV ARTIFACTORY_USR=$ARTIFACTORY_USERNAME
ENV ARTIFACTORY_PSW=$ARTIFACTORY_PASSWORD

RUN apk update \
    && apk --no-cache add curl

WORKDIR /app

# Install all of the dependencies
COPY ./src /app/src/
COPY ./*.json /app/

# build
RUN rm -rf /app/node_modules \
    && curl -u "$ARTIFACTORY_USERNAME":"$ARTIFACTORY_PASSWORD"  https://zoominfo.jfrog.io/zoominfo/api/npm/auth >> ~/.npmrc

RUN npm ci

EXPOSE 5000

CMD [ "npm", "run", "start:prod" ]