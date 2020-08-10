# Example project

[![Pipeline status](https://gitlab.laas.fr/gepetto/example-adder/badges/master/pipeline.svg)](https://gitlab.laas.fr/gepetto/example-adder/commits/master)
[![Coverage report](https://gitlab.laas.fr/gepetto/example-adder/badges/master/coverage.svg?job=doc-coverage)](http://projects.laas.fr/gepetto/doc/gepetto/example-adder/master/coverage/)

This is an example project, to show how to use Gepetto's tools

## Build manylinux2014 wheels

```
git clone https://github.com/Ozon2/example-adder.git
```

The official manylinux2014 docker intentionally [removes `libpython.X.Y.so`](https://github.com/pypa/manylinux/blob/manylinux2014/pep-513.rst#libpythonxyso1),
but we need it to use boost (maybe we actually don't need it but I just didn't find how not to use it) so we
need to build a custom manylinux2014 image.

```
git clone -b manylinux2014 https://github.com/pypa/manylinux.git
cd manylinux
git apply ../libpython.patch
PLATFORM=$(uname -m) TRAVIS_COMMIT=latest ./build.sh
```

Now the wheels can be built using:
```
cd ../example-adder
docker build . -t manylinux
docker run --rm -it -v `pwd`:/io manylinux ./build_wheels.sh
```

All the wheels can be found in `wheelhouse/`.
