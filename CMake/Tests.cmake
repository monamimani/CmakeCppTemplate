include_guard()

if(TEMPLATE_PROJECT_BUILD_BENCHMARKS)
  find_package(benchmark CONFIG REQUIRED)
endif()

if(BUILD_TESTING) # or if(TEMPLATE_PROJECT_BUILD_TESTS)
  # find_package(GTest CONFIG REQUIRED)
  # include(GoogleTest)

  # if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  # set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  # endif()
  find_package(Catch2 3 CONFIG REQUIRED)
  include(Catch)
endif()
