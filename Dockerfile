FROM griff/oracle-jdk7

MAINTAINER Eric Bolinger "boli@pobox.com"

# Use the 'foreman' Ruby app to launch from a Procfile, see start.sh
# For DEV: apt-get -y install curl wget man

RUN	apt-get -y install rubygems && gem install foreman

VOLUME	["/data", "/logs"]

EXPOSE	8080 8081 8082 8083 8443

WORKDIR	/opt/local/app

# Apply any important files.  Any file is fair game.
ADD	rootdir /

USER	daemon

CMD	["bin/start.sh"]

