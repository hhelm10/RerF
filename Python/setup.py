from distutils.core import setup
from distutils.extension import Extension

from Cython.Build import cythonize

ext_modules = cythonize("pyfp/pyfp.pyx", include_path=["fpForest"])

setup(ext_modules=ext_modules)


# from Cython.Distutils import build_ext

# ext_modules = cythonize(
#     Extension(
#         "pyfp.pyx",
#         sources=["pyfp.pyx",
#                  "fpForest.pxd"],
#         language="c++"))
