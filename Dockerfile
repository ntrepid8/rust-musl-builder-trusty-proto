FROM ekidd/rust-musl-builder:latest
RUN sudo apt-get update
COPY ./ci.sh /tmp/ci.sh
RUN sudo /tmp/ci.sh install_proto3_linux
