import os
# from distutils.core import setup
# from distutils.extension import Extension
from setuptools import setup, Extension

from Cython.Build import cythonize

sources = ["pyfp/pyfp.pyx"]

pf_cpp_path = "../src/packedForest/src"
include_dirs = [x[0] for x in os.walk(pf_cpp_path)]

ext_modules = cythonize(
    Extension(name="pyfp.pyfp",
              sources=sources,
              include_dirs=include_dirs)
)

setup(ext_modules=ext_modules)
# python setup.py build_ext
