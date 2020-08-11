#!/bin/bash -eux

function repair_wheel {
    wheel="$1"
    if ! auditwheel show "$wheel"; then
        echo "Skipping non-platform wheel $wheel"
    else
        auditwheel repair "$wheel" --plat "$PLAT" -w /io/wheelhouse/
    fi
}

# Don't build wheels for python 3.9
rm -rf /opt/python/cp39-cp39

# Install cmake
PY38_BIN=/opt/python/cp38-cp38/bin
$PY38_BIN/pip install cmake ninja wheel
ln -s $PY38_BIN/cmake /usr/bin/ || true
ln -s $PY38_BIN/ninja /usr/bin/ || true
ln -s $PY38_BIN/wheel /usr/bin/ || true

# Build wheels for python 2.7
yum -y install python-pip
pip2 install --upgrade pip
pip2 install scikit-build --user
python2 setup.py bdist_wheel

# Build wheels for python 3
for PYBIN in /opt/python/*/bin; do
    rm -rf _skbuild/
    "$PYBIN"/pip install --upgrade pip
    "$PYBIN"/pip install scikit-build
    "$PYBIN"/python setup.py bdist_wheel
done

# Bundle external shared libraries into the wheels
cp ./_skbuild/linux-x86_64-3.8/cmake-build/libexample-adder.so* /lib64
for whl in dist/*.whl; do
    repair_wheel "$whl"
done

# Repair rpath and remove dependency to libpython
for whl in wheelhouse/*.whl; do
  wheel unpack "$whl"
  # shellcheck disable=SC2016
  patchelf --set-rpath '$ORIGIN/../gepetto_example_adder.libs' gepetto_example_adder-3.0.2/gepetto_example_adder-3.0.2.data/data/lib/python*/site-packages/example_adder/libexample_adder.so
  wheel pack gepetto_example_adder-3.0.2 -d wheelhouse
  rm -rf gepetto_example_adder-3.0.2/
done

# Install packages and test
pip2 install gepetto_example_adder --no-index --find-links=/io/wheelhouse/
mv /usr/lib64/python2.7/site-packages/gepetto_example_adder.libs /usr/lib/python2.7/site-packages/gepetto_example_adder.libs
(cd "$HOME"; python2 /io/tests/python/test_add.py)
for PYBIN in /opt/python/*/bin; do
    "${PYBIN}"/pip install gepetto_example_adder --no-index --find-links=/io/wheelhouse/
    (cd "$HOME"; "${PYBIN}"/python /io/tests/python/test_add.py)
done

rm -rf _skbuild gepetto_example_adder.egg-info/ dist/

ls wheelhouse/
