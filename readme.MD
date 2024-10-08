take raw link of install-docker.sh from git. 
curl <raw link> | sudo bash

for i in mysql backend frontend; do cd $i; docker build -t $i:v1.0 .; cd .. ; done

Database is created first. we should load default data. 

docker run -d -p 3306:3306 --name mysql --network expense mysql:1.0
docker run -d -p 8080:8080 --name backend --network expense backend:1.0

you can check logs using
docker logs mysql
docker logs -f backend (to follow)

TO test if backend connected to mysql or not 

docker exec -it backend bash
check mysql (if not there)
check os --> cat /etc/*release
apt update
apt install -y default-mysql-client
mysql -h mysql -u root -pExpenseApp@1

troubleshooting:
curl http://localhost:8080/transaction

![alt text](flow.JPG)


docker run -d -p 8080:8080 --name backend --network expense backend:1.0

we are saying, if user send any request on server port 8080, it will go through expense network and forward to backend container.

so if we do curl http://localhost:8080/transaction, we get success in container as well as in server.
also we can hit from browser <ip-address>:8080/transaction.
As above is not safe, we did docker run -d --name backend --network expense backend:1.0
Now we can access only in container. so its upto us how we want to expose and not expose.

frontend:
docker build -t frontend:1.0 .
docker run -d -p 80:80 --name frontend --network expense frontend:1.0
nginx home directory: /etc/nginx/

Docker compose:

Docker compose is a tool where you can define all your services that can be up and down at a time.
you can create dependencies between the services, can declare the networks and volumes.

after writing docker-compose.yaml, do docker compose up -d to run containers.
docker compose down ---> to down all containers

for sample docker compose Refer https://www.baeldung.com/ops/docker-compose
we are building and running containers manually like 
docker run -d -p 8080:8080 --name backend --network expense backend:1.0

so we need to remember everything and how it depends on other and create it.
1. i have to run docker containers manually.
2. components are dependent on each other

In docker compose, we can set explicit dependencies like terraform.

Volumes:
containers are ephemeral by default, once you remove the container it will remove the data also.
Docker will store data in WORKDIR: /var/lib/docker (we get when we do docker inspect).

1. unnamed volumes:
 create a directory in linux and mount to container using -v host-path:container-path.
 docker run -d -p 80:80 -v /home/ec2-user/nginx-data:/usr/share/nginx/html nginx
2. named volumes:
 when we create volume using docker commands, docker will take care of that volume life cycle.
 ex: docker volume create nginx
     docker volume ls
     docker run -d -p 80:80 -v nginx:/usr/share/nginx/html nginx
     docker exec -it <container id> bash
     cd /usr/share/nginx/html
     rm -rf index.html
     echo "this is named volume" > index.html
     docker volume rm <volume-name>

docker exec -it backend bash
curl -o /dev/null -s -w 'Total: %{time_total}s\n' http://localhost:8080/transaction
curl -o /dev/null -s -w 'Establish Connection: %{time_connect}s\nTTFB: %{time_starttransfer}s\nTotal: %{time_total}s\n' http://localhost:8080/transaction

Layering in docker:
--------------------
Docker follows intermediate containers and layering approach for better storage.
Docker first creates container out of first instruction, runs the second instruction, 
create image out of it and then delete the intermediate container.

docker system prune -a
docker builder prune
docker image prune

export DOCKER_BUILDKIT=0
env | grep DOCKER_BUILDKIT

when we do build after running above commands, use can see docker running in layers when you do below. 
cd backend
docker build -t backend:v1.0 .
docker login 
docker tag backend:v1.0 leelakamineni/backend:v1.0
docker push leelakamineni/backend:v1.0
-- you can also push frontend:v1.0 and mysql:v1.0.

# Docker Best Practices

## 1. Use Official and Verified Images
- **Official Images:** Start with official images from Docker Hub when possible, as they are maintained and updated regularly.
- **Minimal Base Images:** Use minimal base images (like `alpine`) to reduce the attack surface and image size.

## 2. Keep Images Small
- **Multi-Stage Builds:** Use multi-stage builds to minimize the final image size by only including necessary components.
- **Remove Unnecessary Files:** Clean up package lists, cache files, and other unnecessary files to keep the image clean.

## 3. Tag Images Properly
- **Version Tagging:** Tag images with version numbers (e.g., `myapp:1.0`) instead of just using `latest` to avoid ambiguity and ensure consistency across deployments.

## 4. Manage Secrets Securely
- **Environment Variables:** Avoid hardcoding secrets in your Dockerfile or image. Use environment variables or Docker secrets for sensitive information.
- **Docker Secrets:** Utilize Docker Swarm or Kubernetes secrets management for secure storage and usage of sensitive data.

## 5. Use Dockerignore
- **.dockerignore File:** Include a `.dockerignore` file to prevent unnecessary files and directories from being added to the build context, speeding up the build process and keeping the image clean.

## 6. Run as Non-Root User
- **Non-Root User:** Create and run containers with a non-root user to improve security. You can add a user in the Dockerfile using `RUN useradd -m myuser` and switch to that user with `USER myuser`.

## 7. Optimize Layer Caching
- **Layer Order:** Order your Dockerfile instructions to maximize layer caching. Frequently changing commands should be at the end of the Dockerfile.
- **Combine Commands:** Combine commands where possible to reduce the number of layers, but balance it with readability.

## 8. Leverage Health Checks
- **Healthcheck:** Define `HEALTHCHECK` instructions in your Dockerfile to allow Docker to monitor the health of your application and take action if it becomes unhealthy.

## 9. Use Volumes for Persistent Data
- **Volumes:** Use Docker volumes to persist data outside of the container’s filesystem, ensuring data is not lost when the container is removed or updated.
- **Bind Mounts:** Use bind mounts for development to sync code changes in real-time.

## 10. Limit Container Resources
- **Resource Constraints:** Set resource limits (`--memory`, `--cpu-shares`, etc.) to prevent a single container from consuming excessive resources on the host.

## 11. Network Configuration
- **Custom Networks:** Use custom networks to isolate containers and manage communication more securely and efficiently.
- **Service Discovery:** Use Docker's built-in DNS service for container name resolution within custom networks.

## 12. Log Management
- **Log Drivers:** Configure appropriate log drivers (`json-file`, `syslog`, `fluentd`, etc.) to manage container logs effectively.
- **Centralized Logging:** Use centralized logging solutions to aggregate and analyze logs from multiple containers and hosts.

## 13. Security Best Practices
- **Minimal Privileges:** Grant the minimum necessary privileges to your containers.
- **Regular Updates:** Regularly update base images and dependencies to mitigate vulnerabilities.

## 14. Automated Builds and CI/CD Integration
- **CI/CD Pipelines:** Integrate Docker builds into your CI/CD pipelines to automate testing, building, and deployment of images.
- **Automated Tests:** Write and run automated tests to validate your Docker images before deploying them.

## 15. Documentation and Comments
- **Document Dockerfiles:** Comment and document your Dockerfiles to explain the purpose of each instruction, making it easier for others to understand and maintain.

By following these best practices, you can ensure that your Docker containers are secure, efficient, and maintainable.






