#!/bin/bash
SECONDS=0
if [ ! -z "$GO_APPNAME" ]
then	
	export API_COMPILE="$GO_APPNAME"
else
	export API_COMPILE="go-app"
fi
if [ ! -z "$GO_PROXY" ]
then	
	export GOPROXY="$GO_PROXY"
fi
echo "Start Golang Compile"
echo "--------------------------------------------------------------------------------------------------------------------------------------------"
go version
echo "GO configuration environment"  ; go env
echo "--------------------------------------------------------------------------------------------------------------------------------------------"
echo "API to create: " $API_COMPILE
echo "Directory GO: "
pwd
echo "----------------------------------------------------------------------"
echo "BUILD GO code, create directory BIN with executable..."
go mod init $API_COMPILE ; go mod tidy ; go build -o ./bin/$API_COMPILE . |& tee /workspace/source/log.txt
cd bin ; pwd ; ls -ll
echo "----------------------------------------------------------------------"
ELAPSED="Elapsed time compile : $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo $ELAPSED
echo "----------------------------------------------------------------------"
