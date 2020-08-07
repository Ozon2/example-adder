rm -rf _skbuild
python3 setup.py bdist_wheel

# Auditwheel will put libboost_python and libexample-adder in /usr/local/lib/python3.6/site-packages/gepetto_example_adder.libs
LD_LIBRARY_PATH=_skbuild/linux-x86_64-3.6/cmake-install/lib:$LD_LIBRARY_PATH \
auditwheel -v repair dist/gepetto_example_adder-3.0.2-cp36-cp36m-linux_x86_64.whl

ls wheelhouse
