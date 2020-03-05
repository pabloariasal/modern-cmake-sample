# Findboost_regex.cmake
#
# Finds the boost regex library on debian stable
#
# This will define the following variables
#
#    Boost_FOUND
#    Boost_VERSION
#    Boost_INCLUDE_DIRS
#
# and the following imported targets
#
#     Boost::regex
#
# Author: Claus Klein - clausklein.sha@gmail.com
#

if(TARGET Boost::regex)
    return()
endif()

find_package(boost_regex ${MIN_BOOST_VERSION} QUIET CONFIG)
if(TARGET Boost::regex)
    return()
endif()

find_package(Boost 1.67 COMPONENTS regex)
mark_as_advanced(Boost_FOUND Boost_INCLUDE_DIR Boost_VERSION)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Boost
    REQUIRED_VARS Boost_INCLUDE_DIR
    VERSION_VAR Boost_VERSION
)

if(Boost_FOUND)
    get_filename_component(Boost_INCLUDE_DIRS ${Boost_INCLUDE_DIR} DIRECTORY)
endif()

if(Boost_FOUND AND NOT TARGET Boost::regex)
    add_library(Boost::regex INTERFACE IMPORTED)
    set_target_properties(Boost::regex PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}"
    )
endif()

