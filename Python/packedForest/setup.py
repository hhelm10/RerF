from distutils.core import setup

from Cython.Build import cythonize

setup(ext_modules=cythonize("fp.pyx"))


# from distutils.extension import Extension
# from Cython.Distutils import build_ext

# setup(ext_modules=[Extension("fp",
#                              sources=["fp.pyx",
#                                       "fpForest.pxd"],
#                              language="c++")],
#       cmdclass={'build_ext': build_ext}
#       )
