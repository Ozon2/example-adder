#!/bin/bash -ex

rm -rf _skbuild

python3 setup.py bdist_wheel

cp _skbuild/linux-x86_64-3.6/cmake-install/lib/lib* /lib64

auditwheel repair dist/gepetto_example_adder-3.0.2-cp36-cp36m-linux_x86_64.whl
