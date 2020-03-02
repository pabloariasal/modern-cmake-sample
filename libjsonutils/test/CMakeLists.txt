option(INSTALL_GTEST "Enable installation of googletest" ON)
set(GTEST_MIN_VERSION 1.10.0)
if(NOT INSTALL_GTEST)
    # see /opt/local/share/cmake-3.16/Modules/FindGTest.cmake
    find_package(GTest ${GTEST_MIN_VERSION} QUIET)
endif()

add_executable(json_utils_test src/main.cpp)
target_compile_features(json_utils_test PRIVATE cxx_auto_type)

if(NOT TARGET GTest::Main)
    include(FetchContent)
    if(CMAKE_VERSION VERSION_LESS "3.14")
        function(fetchcontent_makeavailable name)
            fetchcontent_getproperties(${name})
            if(NOT ${name}_POPULATED)
                fetchcontent_populate(${name})
                add_subdirectory(${${name}_SOURCE_DIR} ${${name}_BINARY_DIR})
                include_directories(${${name}_SOURCE_DIR}/include)
            endif()
        endfunction()
    endif()

    # --------------------------------------------------------------------
    # Download and unpack googletest at configure time
    # but only if needed or requested! CK
    option(BUILD_GMOCK "Builds the googlemock subproject" OFF)
    message(WARNING "Try to get googlemock with FetchContent ...")
    fetchcontent_declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG master #OR ${GTEST_MIN_VERSION}
    )
    fetchcontent_makeavailable(googletest)

    # Now simply link against gtest or gtest_main as needed. i.e.:
    target_link_libraries(json_utils_test gtest_main JSONUtils::jsonutils)
    # --------------------------------------------------------------------
else()
    target_link_libraries(json_utils_test GTest::Main JSONUtils::jsonutils)
endif()

add_test(NAME json_utils_test
    COMMAND json_utils_test)
