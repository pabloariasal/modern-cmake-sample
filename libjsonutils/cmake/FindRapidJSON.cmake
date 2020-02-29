#FindRapidJSON.cmake
#
# Finds the rapidjson library
#
# from http://rapidjson.org/
#
# This will define the following variables
#
#    RAPIDJSON_FOUND
#    RAPIDJSON_VERSION
#    RAPIDJSON_INCLUDE_DIRS
#
# and the following imported targets
#
#     RapidJSON::RapidJSON
#
# Author: Pablo Arias - pabloariasal@gmail.com
#
# clausklein$ cmakelint *.cmake
# FindRapidJSON.cmake:0: Find modules should use uppercase names;
#   consider using FindRAPIDJSON.cmake [convention/filename]
# Total Errors: 1

find_package(PkgConfig REQUIRED)
pkg_check_modules(PC_RapidJSON QUIET RapidJSON)

find_path(RAPIDJSON_INCLUDE_DIR
    NAMES rapidjson.h
    PATHS ${PC_RapidJSON_INCLUDE_DIRS}
    PATH_SUFFIXES rapidjson
)

set(RAPIDJSON_VERSION ${PC_RapidJSON_VERSION})

# NOTE: (cmakelint) All vars should be uppercase! CK
mark_as_advanced(RAPIDJSON_FOUND RAPIDJSON_INCLUDE_DIR RAPIDJSON_VERSION)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(RAPIDJSON
    REQUIRED_VARS RAPIDJSON_INCLUDE_DIR
    VERSION_VAR RAPIDJSON_VERSION
)

if(RAPIDJSON_FOUND)
    #Set include dirs to parent, to enable includes like #include <rapidjson/document.h>
    get_filename_component(RAPIDJSON_INCLUDE_DIRS ${RAPIDJSON_INCLUDE_DIR} DIRECTORY)
endif()

if(RAPIDJSON_FOUND AND NOT TARGET RapidJSON::RapidJSON)
    add_library(RapidJSON::RapidJSON INTERFACE IMPORTED)
    set_target_properties(RapidJSON::RapidJSON PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${RAPIDJSON_INCLUDE_DIRS}"
    )
endif()

