# Modern CMake Sample

Sample project that shows proper modern CMake usage on a dummy library and an executable that uses it.
Accompanying code to my blog post [It's Time To Do CMake Right](https://pabloariasal.github.io/2018/02/19/its-time-to-do-cmake-right/)

# Build Instructions

## Dependencies

* `cmake` >= 3.13
* `Boost` >= 1.65
* `rapidjson` >= 1.1

## Building the Library

```sh
cd libjsonutils
cmake -Bbuild
cmake --build build
```

You can run the tests:

```sh
cmake --build build -- test
```

## Installing the library

You can install the lib in two ways. First, in a classical way: put it somewhere in your system so that executable can find it, or two, build it but register it in the CMake's *User Package Registry*, avoiding installation.

### Normal Installation

```sh
sudo cmake --build build -- install
```

This will install the example library under `/usr/local/` on UNIX systems.

Alternatively, you can specify a custom installation directory by setting `-DCMAKE_INSTALL_PREFIX` in the cmake configure step:

```sh
cmake -Bbuild -DCMAKE_INSTALL_PREFIX=<custom_install_dir>
sudo cmake --build build -- install
```

To uninstall the library, you can run:

```
cd build
xargs rm < install_manifest.txt
```
see [F.A.Q](https://gitlab.kitware.com/cmake/community/-/wikis/FAQ#can-i-do-make-uninstall-with-cmake)

### Using CMake's *User Package Registry*

Instead of actually installing the library, you can just build it and register the build in CMake's *User Package Registry*

```
cd libjsonutils
cmake -Bbuild -DCMAKE_EXPORT_PACKAGE_REGISTRY
```

This will register the library's build in CMake's *User Package Registry* (on UNIX systems it defaults to `~/.cmake`).

This is convenient, as packages depending on the library (e.g. via `find_package`) will be able to find it through the registry, even when the library hasn't been installed.

## Building the example executable

If the library is in the CMake's *User Package Registry* or installed in a system known location, like `/usr/local/`, you just build the executable with:

```
cd example_exec
cmake -Bbuild
cmake --build build
```

If you installed the library in a custom location you must point `CMake` to the installation directory:

```
cd example_exec
cmake -Bbuild -DJSONUtils_DIR=<custom_install_dir>/lib/cmake/JSONUtils
cmake --build build
```

## Run the executable

You are done!

```
cd example_exec
./build/example_exec
```
