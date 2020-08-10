#!/bin/bash -ex

pip3 install /io/wheelhouse/gepetto_example_adder-3.0.2-cp36-cp36m-manylinux2014_x86_64.whl

python3 /io/tests/python/test_add.py
