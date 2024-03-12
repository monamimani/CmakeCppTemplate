include_guard()

if(TEMPLATE_PROJECT_BUILD_BENCHMARKS)
  find_package(benchmark CONFIG REQUIRED)
endif()

if(BUILD_TESTING) # or if(TEMPLATE_PROJECT_BUILD_TESTS)
  block(SCOPE_FOR VARIABLES)
  unset(CMAKE_CXX_CPPCHECK)
  unset(CMAKE_CXX_CLANG_TIDY)
  FetchContent_Declare(
    fuzztest
    GIT_REPOSITORY https://github.com/google/fuzztest.git
    GIT_TAG main
  )
  FetchContent_MakeAvailable(fuzztest)
  endblock()

  set(_FIND_COMPONENTS "") # To Silence Gtest dev warning
  find_package(GTest CONFIG REQUIRED)
  include(GoogleTest)
  unset(_FIND_COMPONENTS)

  if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  endif()

  find_package(Catch2 3 CONFIG REQUIRED)
  include(Catch)
endif()
