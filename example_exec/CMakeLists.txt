cmake_minimum_required(VERSION 3.13...3.16 FATAL_ERROR)
project(example_exec VERSION 0.0.1 LANGUAGES CXX)

add_executable(example_exec src/main.cpp)
target_compile_features(example_exec PRIVATE cxx_auto_type)

find_package(JSONUtils 1.0 REQUIRED)
target_link_libraries(example_exec JSONUtils::JSONUtils)

enable_testing()

add_test(NAME example_exec COMMAND example_exec)
