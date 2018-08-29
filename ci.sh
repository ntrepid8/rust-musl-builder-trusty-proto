#!/usr/bin/env bash
SCRIPT_PATH="$(cd "$(dirname "$0")" ; pwd -P)"

# usage doc
read -r -d '' USAGE_DOC << EOM
usage: ci.sh COMMAND
Commands:
  install_proto3_linux    Install protocol buffers v3

Options:
  -h|--help             Show this message

EOM

# variables
PROTOBUF_URL="https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip"

# arguments
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    ARG_HELP=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# positional arguments
ARG_COMMAND="${POSITIONAL[0]}"

# Helper functions
function print_usage_doc {
  printf "%s\n\n" "${USAGE_DOC}"
}

function date_iso8601 {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

function printf_log {
  printf "[%s] %s\n" "$(date_iso8601)" "${1}"
}

function install_proto3_linux {
  # helper to install protobuf-compiler version 3+ when a package is not available
  # only use this inside a container, not on your host workstation
  set -e
  apt-get install -y curl unzip
  curl -L "${PROTOBUF_URL}" > /tmp/protoc-3.6.1-linux-x86_64.zip
  if [ -d /tmp/proto3 ]; then rm -Rf /tmp/proto3; fi
  unzip /tmp/protoc-3.6.1-linux-x86_64.zip -d /tmp/proto3
  mv /tmp/proto3/bin/* /usr/local/bin/
  mv /tmp/proto3/include/* /usr/local/include/
  rm /tmp/protoc-3.6.1-linux-x86_64.zip
  if [ -d /tmp/proto3 ]; then rm -Rf /tmp/proto3; fi
}

# main
if [[ ( "${ARG_COMMAND}" == "install_proto3_linux" ) ]]; then
  install_proto3_linux
else
  print_usage_doc
fi

# done
exit 0
