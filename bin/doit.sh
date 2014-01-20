#
# Run as root (or with docker permissions).
# Start the docker process, then update NGINX with the new port.
#
BIN_DIR=$(dirname $0)
VOLUMES="-v /mnt/hi_sinatra-docker/data:/data -v /mnt/hi_sinatra-docker/logs:/logs"
PORTS="-p 8080 -p 8000"
USER="-u root"
IMAGE=eb/any-java
CMD="/usr/bin/docker run -d $VOLUMES $PORTS $USER $IMAGE"
echo "Running command: $CMD"
CONT_ID=$($CMD)

TMP_FILE=/tmp/file$$
/usr/bin/docker inspect $CONT_ID > $TMP_FILE

# Fetch the exposed port from JSON file.
MY_PORT=$($BIN_DIR/JSON.sh -b < $TMP_FILE | grep "HostConfig.*8080.*HostPort" | cut -f2 | sed -e 's/"//g')

# Write the new service port to NGINX config file.

NGINX_CONFIG=/etc/nginx/conf.d/docker.conf
TMP_CONFIG=/tmp/nginx.conf$$

echo "upstream docker_root {" > $TMP_CONFIG
grep localhost $NGINX_CONFIG | grep -v $MY_PORT >> $TMP_CONFIG
echo "    server localhost:${MY_PORT};" >> $TMP_CONFIG
cat << EOF >> $TMP_CONFIG
}

server {
    location / {
        proxy_pass http://docker_root;
    }
}
EOF

# Kick the nginx process to reload config
/bin/cp -f $TMP_CONFIG $NGINX_CONFIG
# /usr/sbin/nginx -s reload

rm -f $TMP_FILE $TMP_CONFIG
