#include "example-adder/gepadd.hpp"
#include "example-adder/pin.hpp"

#include <boost/python.hpp>

BOOST_PYTHON_MODULE(libexample_adder) {
  boost::python::def("add", gepetto::example::add);
  boost::python::def("sub", gepetto::example::sub);
  boost::python::def("adds", gepetto::example::adds);
  boost::python::def("subs", gepetto::example::subs);
}
