FROM quay.io/pypa/manylinux2014_x86_64:latest

ENV PLAT manylinux2014_x86_64

RUN yum -y update \
&& yum -y install boost-python36-devel

WORKDIR /io

CMD ["/bin/bash"]
