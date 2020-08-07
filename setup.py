from skbuild import setup

setup(
    name='gepetto-example-adder',
    version='3.0.2',
    description="An example project, to show how to use Gepetto's tools",
    url='https://github.com/Gepetto/example-adder',
    packages=['example_adder'],
    package_dir={'example_adder': 'python/example_adder'},
    package_data={'example_adder': ["libexample_adder.so*"]},
    classifiers=[
        'Programming Language :: Python :: 3',
    ],
)
