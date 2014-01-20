#
# Run as root (or with docker permissions).
# Start the docker process, then update NGINX with the new port.
#
BASE_NAME=$(basename $0)
DIR_NAME=$(dirname $0)
VOLUMES="-v /mnt/hi_sinatra-docker/data:/data -v /mnt/hi_sinatra-docker/logs:/logs"
PORTS="-p 8080 -p 8000"
USER="-u root"
IMAGE=eb/any-java
TMP_FILE=/tmp/file$$

# Launch the container.
CMD="/usr/bin/docker run -d $VOLUMES $PORTS $USER $IMAGE"
echo "Running command: $CMD"
CONT_ID=$($CMD)

# Fetch the IP address of that container.
MY_IPADDR=$(/usr/bin/docker inspect $CONT_ID | $DIR_NAME/JSON.sh -b | grep "IPAddress" | cut -f2 | sed -e 's/"//g')

# Replace any old 8080 iptable entries with a new rule pointing to that container.
iptables -S -t nat | grep "dport 8080" | sed -e "s/.A DOCKER/iptables -t nat -D DOCKER/" > $TMP_FILE
iptables -t nat -A DOCKER ! -i docker0 -p tcp -m tcp --dport 8080 -j DNAT --to-destination ${MY_IPADDR}:8080
. $TMP_FILE

rm -f $TMP_FILE
