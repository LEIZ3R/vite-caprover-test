# pull official base image
FROM node:18-alpine AS builder

# set working directory
WORKDIR /app

# install app dependencies
#copies package.json and package-lock.json to Docker environment
COPY package.json ./
COPY package-lock.json ./

# Installs all node packages
RUN npm install 

# Copies everything over to Docker environment
COPY . .
RUN npm run build

#Stage 2
#######################################
#pull the official nginx:1.20.1 base image

FROM nginx:alpine

#copies React to the container directory
# Set working directory to nginx resources directory
WORKDIR /usr/share/nginx/html

# Remove default nginx static resources
RUN rm -rf ./*

# Copies static resources from builder stage
COPY --from=builder /app/dist .

EXPOSE 80

# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]