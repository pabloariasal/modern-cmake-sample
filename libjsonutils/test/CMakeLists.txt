# see /opt/local/share/cmake-3.16/Modules/FindGTest.cmake
option(INSTALL_GTEST "Enable installation of googletest" OFF)
if(NOT INSTALL_GTEST)
  find_package(GTest 1.10.0 QUIET)
endif()

add_executable(json_utils_test src/main.cpp)
target_compile_features(json_utils_test PRIVATE cxx_auto_type)

if(NOT TARGET GTest::Main)
  # Download and unpack googletest at configure time
  # but only if needed! CK
  option(BUILD_GMOCK "Builds the googlemock subproject" OFF)
  configure_file(${CMAKE_SOURCE_DIR}/cmake/GoogleTest-CMakeLists.txt.in
    ${CMAKE_BINARY_DIR}/googletest-download/CMakeLists.txt)
  execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/googletest-download)
  if(result)
    message(FATAL_ERROR "CMake step for googletest failed: ${result}")
  endif()

  execute_process(COMMAND ${CMAKE_COMMAND} --build .
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/googletest-download)
  if(result)
    message(FATAL_ERROR "Build step for googletest failed: ${result}")
  endif()

  # Add googletest directly to our build. This defines
  # the gtest and gtest_main targets.
  add_subdirectory(${CMAKE_BINARY_DIR}/googletest-src
    ${CMAKE_BINARY_DIR}/googletest-build
    EXCLUDE_FROM_ALL)

  # Now simply link against gtest or gtest_main as needed.
  target_link_libraries(json_utils_test gtest_main JSONUtils::jsonutils)
else()
  target_link_libraries(json_utils_test GTest::Main JSONUtils::jsonutils)
endif()

add_test(NAME json_utils_test
    COMMAND json_utils_test)
