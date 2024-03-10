# file(GLOB_RECURSE sources CONFIGURE_DEPENDS "*.cpp" "*.cxx" "*.ixx")
# file(GLOB_RECURSE headers CONFIGURE_DEPENDS "*.h" "*.hpp")

include(GenerateExportHeader)

get_filename_component(targetName ${CMAKE_CURRENT_LIST_DIR} NAME)

if(CMAKE_SYSTEM_NAME STREQUAL Windows)
  set(platform_publicFiles
  )

  set(platform_privateFiles
  )

elseif(CMAKE_SYSTEM_NAME STREQUAL Linux)
  set(platform_publicFiles
  )

  set(platform_privateFiles
  )
endif()

set(interfaceFiles
)

set(publicFiles
  ${targetName}/Sample.h
)

set(moduleFiles
)

set(privateFiles
  ${targetName}/Sample.cpp
)

set(testFiles
  ${targetName}/Sample.gtest.cpp
  ${targetName}/Sample.catch2.cpp
)

set(benchmarkFiles
  ${targetName}/Sample.benchmark.cpp
)

set(fuzzerFiles
  ${targetName}/Sample.fuzzer.cpp
)

add_library(${targetName})
add_library(TEMPLATE_PROJECT::${targetName} ALIAS ${targetName})

target_include_directories(${targetName}
  PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}"
  "${CMAKE_CURRENT_BINARY_DIR}"
)

generate_export_header(${targetName} EXPORT_FILE_NAME ${targetName}/${targetName}Exports.h)

if(NOT BUILD_SHARED_LIBS)
  string(TOUPPER ${targetName} targetNameUpper)
  target_compile_definitions(${targetName} PUBLIC ${targetNameUpper}_STATIC_DEFINE)
endif()

target_sources(${targetName}
  PRIVATE ${privateFiles} ${platform_privateFiles}
  PUBLIC ${publicFiles}
  INTERFACE ${interfaceFiles}
)

set(privateLibs
  TEMPLATE_PROJECT::Config
  fmt::fmt
)

target_link_libraries(${targetName}
  PRIVATE
  ${privateLibs}

  TEMPLATE_PROJECT::TEMPLATE_PROJECT_options
  TEMPLATE_PROJECT::TEMPLATE_PROJECT_warnings
  TEMPLATE_PROJECT::TEMPLATE_PROJECT_sanitizers
)

# Add test targets if BUILD_TESTING
if(NOT BUILD_TESTING)
  return()
endif()

# Provide a simple smoke test to make sure that the CLI works and can display a --help message
# add_test(NAME cli.has_help COMMAND SampleApp --help)

# Provide a test to verify that the version being reported from the application
# matches the version given to CMake. This will be important once you package
# your program. Real world shows that this is the kind of simple mistake that is easy
# to make, but also easy to test for.
# add_test(NAME cli.version_matches COMMAND SampleApp --version)
# set_tests_properties(cli.version_matches PROPERTIES PASS_REGULAR_EXPRESSION "${PROJECT_VERSION}")
get_target_property("${targetName}Include" ${targetName} INCLUDE_DIRECTORIES)
get_target_property("${targetName}Sources" ${targetName} SOURCES)
get_target_property("${targetName}Libraires" ${targetName} LINK_LIBRARIES)

# I am in the process of evaluating Catch2 vs Gtest so I will add them both here for the moment.
# When I decide if I want to switch to Catch2 I'll modify this as appropriate.
# Catch2 tests
set(targetNameTests ${targetName}TestsCatch2)

add_executable(${targetNameTests})
set_target_properties(${targetNameTests} PROPERTIES FOLDER Tests)
catch_discover_tests(${targetNameTests})

target_include_directories(${targetNameTests}
  PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}"
  ${${targetName}Include}
)

target_sources(${targetNameTests}
  PRIVATE
  ${${targetName}Sources}
  ${testFiles}
)

target_link_libraries(${targetNameTests}
  PRIVATE
  ${${targetName}Libraires}
  fmt::fmt
  Catch2::Catch2WithMain
)

target_compile_definitions(${targetNameTests} PUBLIC TEST_CATCH2)

# GTests tests
set(targetNameTests ${targetName}TestsGTest)

add_executable(${targetNameTests})
set_target_properties(${targetNameTests} PROPERTIES FOLDER Tests)
gtest_discover_tests(${targetNameTests})

target_include_directories(${targetNameTests}
  PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}"
  ${${targetName}Include}
)

target_sources(${targetNameTests}
  PRIVATE
  ${${targetName}Sources}
  ${testFiles}
)

target_link_libraries(${targetNameTests}
  PRIVATE
  ${${targetName}Libraires}
  fmt::fmt
  GTest::gtest_main
)

target_compile_definitions(${targetNameTests} PUBLIC TEST_GTEST)

# I am evaluating if I use Catch2, and Catch2 also have a benchmark facility.
# Google Benchmark
set(targetNameBenchmark ${targetName}GBenchmark)

add_executable(${targetNameBenchmark})
set_target_properties(${targetNameBenchmark} PROPERTIES FOLDER Benchmark)

target_include_directories(${targetNameBenchmark}
  PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}"
  ${${targetName}Include}
)

target_sources(${targetNameBenchmark}
  PRIVATE
  ${${targetName}Sources}
  ${benchmarkFiles}
)

target_link_libraries(${targetNameBenchmark}
  PRIVATE
  ${${targetName}Libraires}
  fmt::fmt
  benchmark::benchmark_main
)

# Fuzzer
# https://llvm.org/docs/LibFuzzer.html
set(targetNameFuzzer ${targetName}Fuzzer)

add_executable(${targetNameFuzzer})
set_target_properties(${targetNameFuzzer} PROPERTIES FOLDER Fuzzer)

target_include_directories(${targetNameFuzzer}
  PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}"
  ${${targetName}Include}
)

target_sources(${targetNameFuzzer}
  PRIVATE
  ${${targetName}Sources}
  ${fuzzerFiles}
)

target_link_libraries(${targetNameFuzzer}
  PRIVATE
  ${${targetName}Libraires}
  fmt::fmt
  -coverage
  -fsanitize=fuzzer
  -stdlib=libstdc++
)

target_compile_options(${targetNameFuzzer} PRIVATE -fsanitize=fuzzer -stdlib=libstdc++)

# Allow short runs during automated testing to see if something new breaks
set(FUZZ_RUNTIME
  10
  CACHE STRING "Number of seconds to run fuzz tests during ctest run") # Default of 10 seconds

add_test(NAME fuzz_tester_run COMMAND ${targetNameFuzzer} -max_total_time=${FUZZ_RUNTIME})