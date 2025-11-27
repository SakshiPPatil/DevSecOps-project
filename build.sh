#!/bin/bash

# ------------------------------
# Configuration
# ------------------------------
IMAGE_NAME="demo-app"
DOCKERHUB_USER="sakshippatil"
TAG=$(date +%Y%m%d%H%M%S)
JAR_FILE="demo-0.0.1-SNAPSHOT.jar"
CONTAINER_PORT=8080
HOST_PORT=8083

# ------------------------------
# Step 1: Build Docker image
# ------------------------------
echo "==> Building Docker image..."
docker build -t ${IMAGE_NAME}:${TAG} .

# ------------------------------
# Step 2: Scan image with Trivy
# ------------------------------
echo "==> Scanning Docker image with Trivy..."
trivy image ${IMAGE_NAME}:${TAG}

# ------------------------------
# Step 3: Tag for Docker Hub
# ------------------------------
echo "==> Tagging image for Docker Hub..."
docker tag ${IMAGE_NAME}:${TAG} ${DOCKERHUB_USER}/${IMAGE_NAME}:${TAG}
docker tag ${IMAGE_NAME}:${TAG} ${DOCKERHUB_USER}/${IMAGE_NAME}:latest

# ------------------------------
# Step 4: Push to Docker Hub
# ------------------------------
echo "==> Pushing image to Docker Hub..."
docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:${TAG}
docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:latest

# Step 5: Deploy container
# ------------------------------
echo "==> Deploying Docker container..."
# Stop existing container if running
docker rm -f ${IMAGE_NAME} 2>/dev/null || true

# Run new container
docker run -d --name ${IMAGE_NAME} -p ${HOST_PORT}:${CONTAINER_PORT} ${DOCKERHUB_USER}/${IMAGE_NAME}:latest

echo "==> Deployment completed! Access the app at http://localhost:${HOST_PORT}"
