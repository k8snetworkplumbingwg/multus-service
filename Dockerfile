# This Dockerfile is used to build the image available on DockerHub
FROM golang:1.17 as build

# Add everything
ADD . /usr/src/multus-service

RUN cd /usr/src/multus-service && \
    go build ./cmd/multus-proxy/ && \
    go build ./cmd/multus-service-controller/

FROM fedora:35
LABEL org.opencontainers.image.source https://github.com/k8snetworkplumbingwg/multus-service
RUN dnf install -y iptables-utils iptables-legacy iptables-nft
RUN alternatives --set iptables /usr/sbin/iptables-legacy
COPY --from=build /usr/src/multus-service/multus-proxy /usr/bin
COPY --from=build /usr/src/multus-service/multus-service-controller /usr/bin
WORKDIR /usr/bin
