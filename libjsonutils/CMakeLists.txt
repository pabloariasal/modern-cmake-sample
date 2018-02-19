cmake_minimum_required(VERSION 3.5)
project(libjsonutils VERSION 1.0.0 LANGUAGES CXX)

#Make sure that custom modules like FindRapidJSON are found
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_SOURCE_DIR}/cmake)

##############################################
# Declare dependencies
find_package(Boost 1.55 REQUIRED COMPONENTS regex)
find_package(RapidJSON 1.0 REQUIRED MODULE)

##############################################
# Create target and set properties

add_library(jsonutils
    src/json_utils.cpp
)

#Add an alias so that library can be used inside the build tree, e.g. when testing
add_library(JSONUtils::jsonutils ALIAS jsonutils)

#Set target properties
target_include_directories(jsonutils
    PUBLIC 
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_compile_features(jsonutils PRIVATE cxx_auto_type)
target_compile_options(jsonutils PRIVATE -Wall)

target_link_libraries(jsonutils
    PUBLIC
        Boost::boost RapidJSON::RapidJSON
    PRIVATE
        Boost::regex 
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

#This is required so that the exported target has the name JSONUtils and not jsonutils
set_target_properties(jsonutils PROPERTIES EXPORT_NAME JSONUtils)

install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

#Export the targets to a script
install(EXPORT jsonutils-targets
  FILE
    JSONUtilsTargets.cmake
  NAMESPACE
    JSONUtils::
  DESTINATION
    ${INSTALL_CONFIGDIR}
)

#Create a ConfigVersion.cmake file
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

#Install the config, configversion and custom find modules
install(FILES
    ${CMAKE_CURRENT_LIST_DIR}/cmake/FindRapidJSON.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/JSONUtilsConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/JSONUtilsConfigVersion.cmake
    DESTINATION ${INSTALL_CONFIGDIR}
)

##############################################
## Exporting from the build tree
configure_file(${CMAKE_CURRENT_LIST_DIR}/cmake/FindRapidJSON.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/FindRapidJSON.cmake
    COPYONLY)

export(EXPORT jsonutils-targets FILE ${CMAKE_CURRENT_BINARY_DIR}/JSONUtilsTargets.cmake NAMESPACE JSONUtils::)

#Register package in user's package registry
export(PACKAGE JSONUtils)

add_subdirectory(test)
