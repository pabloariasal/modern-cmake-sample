# Modern CMake Sample

Sample project that shows proper modern CMake usage on a dummy library and an executable that uses it.
Accompanying code to my blog post [It's Time To Do CMake Right](https://pabloariasal.github.io/2018/02/19/its-time-to-do-cmake-right/)

## Build and Install

As a reference, here is how you can build the library and executable on Ubuntu
16.04:

```
sudo apt-get install rapidjson-dev libboost-dev libboost-regex-dev
cd libjsonutils
mkdir build && cd build
export CMAKE_PREFIX_PATH=$HOME/jsonutils
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=$CMAKE_PREFIX_PATH ..
make
# Install to $HOME/jsonutils
sudo make install
# Build the executable that links against our library.
cd ../example_exec
mkdir build && cd build
cmake -G "Unix Makefiles" ..
make
```

