FROM griff/oracle-jdk7

MAINTAINER Eric Bolinger "boli@pobox.com"

USER	daemon

# Use the 'foreman' app to launch from a Procfile
RUN	apt-get -y install rubygems && gem install foreman

VOLUME	["/data", "/logs"]

EXPOSE	8080 8081 8082 8083 8443

WORKDIR	/opt/local/app

# Apply any important files.  Any file is fair game.
ADD	rootdir /

CMD	["bin/start.sh"]

