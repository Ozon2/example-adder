#!/bin/bash -ex

python3 setup.py bdist_wheel

cp _skbuild/linux-x86_64-3.6/cmake-install/lib/lib* /lib64
auditwheel repair dist/gepetto_example_adder-3.0.2-cp36-cp36m-linux_x86_64.whl

# Repair rpath and remove dependency to libpython
wheel unpack wheelhouse/gepetto_example_adder-3.0.2-cp36-cp36m-manylinux2014_x86_64.whl
patchelf --set-rpath '$ORIGIN/../gepetto_example_adder.libs' gepetto_example_adder-3.0.2/gepetto_example_adder-3.0.2.data/data/lib/python3.6/site-packages/example_adder/libexample_adder.so
patchelf --remove-needed libpython3.6m.so.1.0 gepetto_example_adder-3.0.2/gepetto_example_adder.libs/libboost_python3-mt-1ace0776.so.1.53.0
patchelf --remove-needed libpython3.6m.so.1.0 gepetto_example_adder-3.0.2/gepetto_example_adder-3.0.2.data/data/lib/python3.6/site-packages/example_adder/libexample_adder.so
wheel pack gepetto_example_adder-3.0.2 -d wheelhouse

#TODO: libexample-adder.so and libexample-adder.so.3.0.2 should not be present twice in the wheel

rm -rf gepetto_example_adder-3.0.2/ _skbuild/ gepetto_example_adder.egg-info/ dist/
