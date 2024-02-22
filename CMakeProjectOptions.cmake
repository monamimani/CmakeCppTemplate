include_guard()

if(NOT DEFINED PROJECT_NAME)
  message(FATAL_ERROR "${CMAKE_CURRENT_LIST_FILE} need to be included inside a project")
endif()

include(CMakeDependentOption)
include(CMake/StandardProjectSettings.cmake)
include(CMake/Sanitizers.cmake)

# Cmake options that are likely to be different for each projects.
# Common options that are unlikely to be changed are defined in CMake/StandardProjectSettings.cmake.
if(PROJECT_IS_TOP_LEVEL)
  cmake_dependent_option(TEMPLATE_PROJECT_ENABLE_CLANG_TIDY "Enable clang-tidy" ON "NOT TEMPLATE_PROJECT_BASIC_BUILD_MODE" OFF)
  cmake_dependent_option(TEMPLATE_PROJECT_ENABLE_CPPCHECK "Enable cpp-check analysis" ON "NOT TEMPLATE_PROJECT_BASIC_BUILD_MODE" OFF)

  cmake_dependent_option(TEMPLATE_PROJECT_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ${SUPPORTS_ASAN} "NOT TEMPLATE_PROJECT_BASIC_BUILD_MODE" OFF)
  cmake_dependent_option(TEMPLATE_PROJECT_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" ${SUPPORTS_UBSAN} "NOT TEMPLATE_PROJECT_BASIC_BUILD_MODE" OFF)
  cmake_dependent_option(TEMPLATE_PROJECT_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF "NOT TEMPLATE_PROJECT_BASIC_BUILD_MODE" OFF)
  cmake_dependent_option(TEMPLATE_PROJECT_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF "NOT TEMPLATE_PROJECT_BASIC_BUILD_MODE" OFF)
  cmake_dependent_option(TEMPLATE_PROJECT_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF "NOT TEMPLATE_PROJECT_BASIC_BUILD_MODE" OFF)

  cmake_dependent_option(TEMPLATE_PROJECT_ENABLE_IPO "Enable IPO/LTO" ON "NOT TEMPLATE_PROJECT_BASIC_BUILD_MODE" OFF)
  cmake_dependent_option(TEMPLATE_PROJECT_ENABLE_CACHE "Enable ccache" ON "NOT TEMPLATE_PROJECT_BASIC_BUILD_MODE" OFF)
  cmake_dependent_option(TEMPLATE_PROJECT_ENABLE_UNITY_BUILD "Enable unity builds" OFF "NOT TEMPLATE_PROJECT_BASIC_BUILD_MODE" OFF)
  cmake_dependent_option(TEMPLATE_PROJECT_ENABLE_COVERAGE "Enable coverage reporting" OFF "NOT TEMPLATE_PROJECT_BASIC_BUILD_MODE" OFF)
endif()

if(TEMPLATE_PROJECT_BASIC_BUILD_MODE)
  message(AUTHOR_WARNING "Basic build mode enabled. All fancy build feature like checks, IPO/LTO are disabled.")
endif()

if(TEMPLATE_PROJECT_ENABLE_IPO)
  include(CMake/InterproceduralOptimization.cmake)
else()
endif()

add_library(TEMPLATE_PROJECT_warnings INTERFACE)
add_library(TEMPLATE_PROJECT::TEMPLATE_PROJECT_warnings ALIAS TEMPLATE_PROJECT_warnings)

add_library(TEMPLATE_PROJECT_options INTERFACE)
add_library(TEMPLATE_PROJECT::TEMPLATE_PROJECT_options ALIAS TEMPLATE_PROJECT_options)

add_library(TEMPLATE_PROJECT_sanitizers INTERFACE)
add_library(TEMPLATE_PROJECT::TEMPLATE_PROJECT_sanitizers ALIAS TEMPLATE_PROJECT_sanitizers)

add_library(TEMPLATE_PROJECT_static_analyzers INTERFACE)
add_library(TEMPLATE_PROJECT::TEMPLATE_PROJECT_static_analyzers ALIAS TEMPLATE_PROJECT_static_analyzers)

include(CMake/CompilerWarnings.cmake)
add_target_interface_warnings(TEMPLATE_PROJECT_warnings OFF)

add_target_interface_sanitizers(
  TEMPLATE_PROJECT_warnings
  ${TEMPLATE_PROJECT_ENABLE_SANITIZER_ADDRESS}
  ${TEMPLATE_PROJECT_ENABLE_SANITIZER_LEAK}
  ${TEMPLATE_PROJECT_ENABLE_SANITIZER_UNDEFINED}
  ${TEMPLATE_PROJECT_ENABLE_SANITIZER_THREAD}
  ${TEMPLATE_PROJECT_ENABLE_SANITIZER_MEMORY}
)

set_target_properties(TEMPLATE_PROJECT_options PROPERTIES UNITY_BUILD ${TEMPLATE_PROJECT_ENABLE_UNITY_BUILD})

if(TEMPLATE_PROJECT_ENABLE_CACHE)
  include(CMake/Cache.cmake)
endif()

include(CMake/StaticAnalyzers.cmake)

if(TEMPLATE_PROJECT_ENABLE_CPPCHECK)
  TEMPLATE_PROJECT_enable_cppcheck(OFF, "")
endif()

if(TEMPLATE_PROJECT_ENABLE_CLANG_TIDY)
  add_target_interface_clang_tidy(TEMPLATE_PROJECT_static_analyzers, OFF)
endif()