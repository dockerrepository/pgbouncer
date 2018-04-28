echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push $IMAGE_NAME:$IMAGE_VERSION;
if [[ "$LATEST_VERSION" == "yes" ]]; then
  docker tag $IMAGE_NAME:$IMAGE_VERSION $IMAGE_NAME:latest;
  docker push $IMAGE_NAME:latest;
fi
