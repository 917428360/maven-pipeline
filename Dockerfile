# Description: test image
FROM centos:latest
LABEL maintainer="tiger@yun.com"

RUN "cat /etc/redhat-release"
