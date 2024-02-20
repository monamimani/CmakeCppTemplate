cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

set(VCPKG_INSTALLED_DIR  ${CMAKE_BINARY_DIR}/../vcpkg_installed)

if (NOT DEFINED CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 23)
endif()

set(CMAKE_CXX_EXTENSIONS OFF)

#set(CMAKE_VERBOSE_MAKEFILE ON)

include(CMakePrintHelpers)

cmake_print_variables(CMAKE_VERSION)
# cmake_print_variables(CMAKE_MODULE_PATH)

project(
  %%template_project%%
  VERSION 0.0.1
  DESCRIPTION ""
  HOMEPAGE_URL "%%template_url%%"
  LANGUAGES CXX C)

include(CMake/PreventInSourceBuilds.cmake)
include(CMakeProjectOptions.cmake)

set(GIT_SHA
    "Unknown"
    CACHE STRING "SHA this build was generated from")
string(
  SUBSTRING "${GIT_SHA}"
            0
            8
            GIT_SHORT_SHA)

# add_library(myproject::myproject_options ALIAS myproject_options)
# add_library(myproject::myproject_warnings ALIAS myproject_warnings)

add_subdirectory(Projects)


if(PROJECT_IS_TOP_LEVEL)
  include(CTest)
endif()