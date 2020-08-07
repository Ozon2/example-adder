pip3 install wheelhouse/gepetto_example_adder-3.0.2-cp36-cp36m-manylinux2014_x86_64.whl

# TODO: fix rpath
# Fix: export LD_LIBRARY_PATH=/usr/local/lib/python3.6/site-packages/gepetto_example_adder.libs:$LD_LIBRARY_PATH
# or patchelf --set-rpath '$ORIGIN/../gepetto_example_adder.libs' /usr/local/lib/python3.6/site-packages/example_adder/libexample_adder.so

python3 /io/tests/python/test_add.py