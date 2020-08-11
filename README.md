# Example project

[![Pipeline status](https://gitlab.laas.fr/gepetto/example-adder/badges/master/pipeline.svg)](https://gitlab.laas.fr/gepetto/example-adder/commits/master)
[![Coverage report](https://gitlab.laas.fr/gepetto/example-adder/badges/master/coverage.svg?job=doc-coverage)](http://projects.laas.fr/gepetto/doc/gepetto/example-adder/master/coverage/)

This is an example project, to show how to use Gepetto's tools

## Build manylinux2014 wheels

The wheels can be built using:
```
git clone https://github.com/Ozon2/example-adder.git
cd example-adder
docker build . -t manylinux -f build-wheel/Dockerfile
docker run --rm -it -v `pwd`:/io manylinux ./build-wheel/build_wheels.sh
```

All the wheels can be found in `wheelhouse/`.
