#
# Run as root (or with docker permissions).
# Start the docker process, then update NGINX with the new port.
#
VOLUMES="-v /mnt/hi_sinatra-docker/data:/data -v /mnt/hi_sinatra-docker/logs:/logs"
PORTS="-p 8080 -p 8000"
USER="-u root"
IMAGE=eb/any-java
CONT_ID=$(docker run -d $VOLUMES $PORTS $USER $IMAGE)

# Fetch the docker info, JSON format.
#
# Write the new service to NGINX config file.
#
exit 0

/etc/nginx/conf.d/docker.conf
upstream docker_root {
    # Toggle between root-level docker containers.
    server localhost:49155      down;
    server localhost:49156;
}

server {
    location / {
        proxy_pass http://docker_root;
    }
}

