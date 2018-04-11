# STAGE 0 - Build the Angular application in a builder image
#-----------------------------------------------------

# set our base image to the official Node Alpine image from the Docker hub and name it 'node'
FROM node:9.11.1-alpine as builder

# set the working directory of our Docker image
WORKDIR /app

# copy NPM package definitions into our working directory
COPY package.json /app/

# download all packages into image
RUN npm install

# copy the entire web project (minius .dockerignore) into image
COPY ./ /app/

ARG env=prod

RUN npm run build -- --prod --environment $env

FROM nginx:1.13-alpine

COPY --from=builder /app/dist/ /usr/share/nginx/html

COPY ./nginx-custom.conf /etc/nginx/conf.d/default.conf