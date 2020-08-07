FROM quay.io/pypa/manylinux2014_x86_64:latest

RUN yum -y update \
&& yum -y install boost-python36-devel.x86_64 \
                  python3-devel

RUN pip3 install --upgrade pip
RUN pip3 install scikit-build wheel setuptools cmake

WORKDIR /io
