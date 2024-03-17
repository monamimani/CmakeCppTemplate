cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

set(VCPKG_INSTALLED_DIR ${CMAKE_BINARY_DIR}/../../vcpkg_installed)

if(NOT DEFINED CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 23)
endif()

set(CMAKE_CXX_EXTENSIONS OFF)

# set(CMAKE_VERBOSE_MAKEFILE ON)
include(CMakePrintHelpers)
include(CMake/PreventInSourceBuilds.cmake)
include(CMake/ValidateVcpkgToolchain.cmake)
include(CMake/GetCPM.cmake)

cmake_print_variables(CMAKE_VERSION)

# cmake_print_variables(CMAKE_MODULE_PATH)

# get_filename_component(WorkspaceName ${CMAKE_SOURCE_DIR} NAME)
# string(REPLACE " " "_" WorkspaceName ${WorkspaceName})
project(TEMPLATE_PROJECT
  VERSION 0.0.1
  DESCRIPTION ""
  HOMEPAGE_URL "%%TEMPLATE_URL%%"
  LANGUAGES CXX C)

find_package(fmt CONFIG REQUIRED)

include(CMakeProjectOptions.cmake)
TEMPLATE_PROJECT_declare_options()
TEMPLATE_PROJECT_global_options()
TEMPLATE_PROJECT_target_options()

# If this project is consumed by another, don't setup tests.
if(PROJECT_IS_TOP_LEVEL)
  include(CMake/Tests.cmake)
endif()

# add_subdirectory(Projects)
file(GLOB PROJECT_CONTENTS LIST_DIRECTORIES true CONFIGURE_DEPENDS "Projects/*")

foreach(ITEM ${PROJECT_CONTENTS})
  if(IS_DIRECTORY ${ITEM})
    file(RELATIVE_PATH FOLDER "${CMAKE_CURRENT_SOURCE_DIR}/Projects/" ${ITEM})
    add_subdirectory(Projects/${FOLDER})
  endif()
endforeach()

# If MSVC is being used, and ASAN is enabled, we need to set the debugger environment
# so that it behaves well with MSVC's debugger, and we can run the target from visual studio
# if(MSVC)
# get_all_installable_targets(all_targets)
# message("all_targets=${all_targets}")
# set_target_properties(${all_targets} PROPERTIES VS_DEBUGGER_ENVIRONMENT "PATH=$(VC_ExecutablePath_x64);%PATH%")
# endif()

# set the startup project for the "play" button in MSVC
set_property(DIRECTORY PROPERTY VS_STARTUP_PROJECT Sample)

if(CMAKE_SKIP_INSTALL_RULES)
  return()
endif()

include(CPack)