cmake_minimum_required(VERSION 3.5)
project(example_exec VERSION 0.0.1 LANGUAGES CXX)

add_executable(example_exec src/main)

find_package(JSONUtils 1.0 REQUIRED)
target_link_libraries(example_exec JSONUtils::JSONUtils)

