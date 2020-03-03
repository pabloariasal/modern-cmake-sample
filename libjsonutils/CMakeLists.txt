cmake_minimum_required(VERSION 3.13...3.16 FATAL_ERROR)
project(libjsonutils VERSION 1.0.0 LANGUAGES CXX)

# Make sure that custom modules like cmake/FindRapidJSON.cmake are found
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_SOURCE_DIR}/cmake)
message(STATUS "CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}")

##############################################
# Declare dependencies
# workaround use boost v1.67
set(MIN_BOOST_VERSION 1.67) # TODO should be 1.71
find_package(boost_regex ${MIN_BOOST_VERSION} REQUIRED MODULE)
#TODO find_package(boost_headers ${MIN_BOOST_VERSION} REQUIRED CONFIG)

set(MIN_RapidJSON_VERSION 1.1)
find_package(RapidJSON ${MIN_RapidJSON_VERSION} REQUIRED MODULE)

##############################################
# Create target and set properties

add_library(jsonutils
    src/json_utils.cpp
    src/file_utils.h
)

# Add an alias so that library can be used inside the build tree, e.g. when testing
add_library(JSONUtils::jsonutils ALIAS jsonutils)

# Set target properties
target_include_directories(jsonutils
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_compile_features(jsonutils PRIVATE cxx_auto_type)
target_compile_options(jsonutils PRIVATE
    $<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
    -Wall -Wextra -Wpedantic>
)

target_link_libraries(jsonutils
    PUBLIC
        #TODO Boost::headers
        RapidJSON::RapidJSON
        Boost::regex
    #TODO PRIVATE Boost::regex
)

##############################################
# Installation instructions

include(GNUInstallDirs)
set(INSTALL_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/JSONUtils)

install(TARGETS jsonutils
    EXPORT jsonutils-targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

# This is required so that the exported target has the name JSONUtils and not jsonutils
set_target_properties(jsonutils PROPERTIES EXPORT_NAME JSONUtils)

install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Export the targets to a script
install(EXPORT jsonutils-targets
    FILE
        JSONUtilsTargets.cmake
    NAMESPACE
        JSONUtils::
    DESTINATION
        ${INSTALL_CONFIGDIR}
)

# Create a ConfigVersion.cmake file
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/JSONUtilsConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(${CMAKE_CURRENT_LIST_DIR}/cmake/JSONUtilsConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/JSONUtilsConfig.cmake
    INSTALL_DESTINATION ${INSTALL_CONFIGDIR}
)

# Install the config, configversion and custom find modules
install(FILES
    ${CMAKE_CURRENT_LIST_DIR}/cmake/FindRapidJSON.cmake
    ${CMAKE_CURRENT_LIST_DIR}/cmake/Findboost_regex.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/JSONUtilsConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/JSONUtilsConfigVersion.cmake
    DESTINATION ${INSTALL_CONFIGDIR}
)

##############################################
## Exporting from the build tree
configure_file(${CMAKE_CURRENT_LIST_DIR}/cmake/FindRapidJSON.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/FindRapidJSON.cmake
    COPYONLY
)

export(EXPORT jsonutils-targets
    FILE ${CMAKE_CURRENT_BINARY_DIR}/JSONUtilsTargets.cmake
    NAMESPACE JSONUtils::
)

# Register package in user's package registry
export(PACKAGE JSONUtils)

##############################################
## Add tests
enable_testing()

add_subdirectory(test)

##############################################
## test the installed target and export config too
#
# NOTE: we have first to install into the staging directory! CK
add_test(
  NAME use-target_install
  COMMAND ${CMAKE_COMMAND}
    --build ${CMAKE_CURRENT_BINARY_DIR}
    --target install
    --config $<CONFIGURATION>
)
set_tests_properties(use-target_install
  PROPERTIES
    FIXTURES_SETUP use-install
)

add_test(
    NAME use-target_configure
    COMMAND ${CMAKE_COMMAND}
        -H${CMAKE_CURRENT_LIST_DIR}/use-target
        -B${CMAKE_CURRENT_BINARY_DIR}/build_use-target
        -G${CMAKE_GENERATOR}
#XXX    -DCMAKE_MODULE_PATH=${CMAKE_STAGING_PREFIX}/${INSTALL_CONFIGDIR}
        -DJSONUtils_DIR=${CMAKE_STAGING_PREFIX}/${INSTALL_CONFIGDIR}
        -Dboost_regex_DIR=${boost_regex_DIR}
#FIXME how to quote right? CK -DCMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH}"
        -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_BUILD_TYPE=$<CONFIGURATION>
#TODO: TBD WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/build_use-target
)
set_tests_properties(use-target_configure
    PROPERTIES
        FIXTURES_REQUIRED use-install
        FIXTURES_SETUP use-target
)

add_test(
    NAME use-target_build
    COMMAND ${CMAKE_COMMAND}
        --build ${CMAKE_CURRENT_BINARY_DIR}/build_use-target
        --config $<CONFIGURATION>
)
set_tests_properties(use-target_build
    PROPERTIES
        FIXTURES_REQUIRED use-target
)

add_test(
    NAME use-target_test
    COMMAND ${CMAKE_COMMAND}
        --build ${CMAKE_CURRENT_BINARY_DIR}/build_use-target
        --target test
        --config $<CONFIGURATION>
)
set_tests_properties(use-target_test
    PROPERTIES
        FIXTURES_REQUIRED use-target
)

add_test(
    NAME use-target_cleanup
    COMMAND ${CMAKE_COMMAND}
        -E remove_directory ${CMAKE_CURRENT_BINARY_DIR}/build_use-target
)
set_tests_properties(use-target_cleanup
    PROPERTIES
        FIXTURES_CLEANUP use-target
)
