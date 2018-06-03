#!/usr/bin/env bash
set -eu

# Defaults
server="localhost"
port="8080"
body="Well, this is just a test"
debug=false

script=$(basename $0)
usage="Send a payload using http put to given address
usage: $script [-d|-h|-p|-s]
    -a| --address           server name to curl to
    -b| --body              body of the payload to send
    -d| --debug             enable debuging output
    -h| --help              this help
    -p| --port              server port to curl to"

while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -h|--help)
      echo "$usage"
      exit 0
    ;;
    -a|--address)
      server="$2"
      shift
    ;;
    -b|--body)
      body="$2"
      shift
    ;;
    -d|--debug)
      debug=true
    ;;
    -p|--port)
      port="$2"
      shift
    ;;
    *)
      echo "Unknown options specified $1"
      echo "$usage"
      exit 1
    ;;
  esac
  shift # past argument or value
done

# Enable debug if debug argument was passed
if [ "$debug" == true ] ; then
  set -x
fi

curl --data "${body}" -X PUT http://${server}:${port}
