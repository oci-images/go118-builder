##########################################################################################################################################################################
#
# Build Docker image
# - docker build -f DockerFileGo -t gocompile:v1 .
#
# RUN Docker images
# - docker run --rm -it -e API_COMPILE="sust_api_name" -e GOPROXY="repos_nexus_GO" -e ARGS_APP="args_exec_api" -v "host_directory_":/go/src/apigolang gocompile:v1
#
# example args_exec_api -> -p-a-user-pass-h
#
# repos_nexus_GO -> http://15.192.41.203:8081/repository/goproxy/
##########################################################################################################################################################################
FROM registry.access.redhat.com/ubi8/ubi:8.6

RUN dnf update -y                                      \
  ; dnf install python3 openssl gcc gcc-c++ ca-certificates -y \
  ; dnf clean all

LABEL name="Builder Cloud Apps GO" \
      vendor="GoLang" \
      version="go1.18.5" \
      release="1.18" \
      run="docker run --rm -ti <image_name:tag> -v /workspace/source" \
      summary="GoLang Docker Image for ubi8" \
      description="For more information on this image please see "\
	  maintainer="Oficina de Arquitectura"

# Download and install GO
RUN curl -kLfsSo /tmp/go-linux.tar.gz https://golang.org/dl/go1.18.5.linux-amd64.tar.gz  \
  ; rm -rf /usr/local/go ; tar -C /usr/local -xzf /tmp/go-linux.tar.gz

# Config GO
ENV PATH="/usr/local/go/bin:$PATH" \
    GOPATH="/workspace"
RUN mkdir -p /usr/local/shell/

WORKDIR /workspace/source

COPY gobuilder.sh /usr/local/shell/

RUN chown 1001 /workspace/ \
	; chmod 777 /workspace/  \
	; chown 1001:root /usr/local/shell/gobuilder.sh \
	; chmod 777 /usr/local/shell/gobuilder.sh 

CMD ["sh","/usr/local/shell/gobuilder.sh","run"]