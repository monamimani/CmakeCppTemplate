include_guard()

if(NOT PROJECT_IS_TOP_LEVEL)
    return()
endif()

include(CMakeDependentOption)
include(CMake/StandardProjectSettings.cmake)

# Cmake options that are likely to be different for each projects.
# Common options that are unlikely to be changed are defined in CMake/StandardProjectSettings.cmake.

if(NOT PROJECT_IS_TOP_LEVEL OR myproject_PACKAGING_MAINTAINER_MODE)
option(myproject_ENABLE_IPO "Enable IPO/LTO" OFF)
option(myproject_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" OFF)
option(myproject_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" OFF)
option(myproject_ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)
option(myproject_ENABLE_CPPCHECK "Enable cpp-check analysis" OFF)
option(myproject_ENABLE_CACHE "Enable ccache" OFF)
else()
option(myproject_ENABLE_IPO "Enable IPO/LTO" ON)
option(myproject_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ${SUPPORTS_ASAN})
option(myproject_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" ${SUPPORTS_UBSAN})
option(myproject_ENABLE_CLANG_TIDY "Enable clang-tidy" ON)
option(myproject_ENABLE_CPPCHECK "Enable cpp-check analysis" ON)
option(myproject_ENABLE_CACHE "Enable ccache" ON)
endif()

option(myproject_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
option(myproject_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
option(myproject_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
option(myproject_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
option(myproject_ENABLE_PCH "Enable precompiled headers" OFF)





