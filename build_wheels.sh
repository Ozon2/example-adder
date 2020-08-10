#!/bin/bash -eux

function repair_wheel {
    wheel="$1"
    if ! auditwheel show "$wheel"; then
        echo "Skipping non-platform wheel $wheel"
    else
        auditwheel repair "$wheel" --plat "$PLAT" -w /io/wheelhouse/
    fi
}

# Install cmake
PY38_BIN=/opt/python/cp38-cp38/bin
$PY38_BIN/pip install cmake ninja wheel
ln -s $PY38_BIN/cmake /usr/bin/
ln -s $PY38_BIN/ninja /usr/bin/
ln -s $PY38_BIN/wheel /usr/bin/

# Build wheels for each python version
for PYBIN in /opt/python/*/bin; do
    "$PYBIN"/pip install --upgrade pip
    "$PYBIN"/pip install scikit-build
    "$PYBIN"/python setup.py bdist_wheel
    cp _skbuild/linux-x86_64-3.*/cmake-build/libexample-adder.so* /lib64
    rm -rf _skbuild/
done

# Bundle external shared libraries into the wheels
for whl in dist/*.whl; do
    repair_wheel "$whl"
done
rm /lib64/libexample-adder.so*

# Repair rpath and remove dependency to libpython
for whl in wheelhouse/*.whl; do
  wheel unpack "$whl"
  # shellcheck disable=SC2016
  patchelf --set-rpath '$ORIGIN/../gepetto_example_adder.libs' gepetto_example_adder-3.0.2/gepetto_example_adder-3.0.2.data/data/lib/python3.*/site-packages/example_adder/libexample_adder.so
  patchelf --remove-needed libpython3.6m.so.1.0 gepetto_example_adder-3.0.2/gepetto_example_adder.libs/libboost_python3*
  wheel pack gepetto_example_adder-3.0.2 -d wheelhouse
  rm -rf gepetto_example_adder-3.0.2/
done

# Install packages and test
for PYBIN in /opt/python/*/bin; do
    "${PYBIN}"/pip install gepetto_example_adder --no-index --find-links=/io/wheelhouse/
    (cd "$HOME"; "${PYBIN}"/python /io/tests/python/test_add.py)
done

rm -rf gepetto_example_adder.egg-info/ dist/

ls wheelhouse/
