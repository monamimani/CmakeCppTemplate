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
)

set(benchmarkFiles
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
)

target_link_libraries(${targetName}
  PRIVATE
  ${privateLibs}

  TEMPLATE_PROJECT::TEMPLATE_PROJECT_sanitizers
  TEMPLATE_PROJECT::TEMPLATE_PROJECT_warnings
  TEMPLATE_PROJECT::TEMPLATE_PROJECT_static_analyzers
  # TEMPLATE_PROJECT::TEMPLATE_PROJECT_sanitizers
  # TEMPLATE_PROJECT::TEMPLATE_PROJECT_warnings
  # TEMPLATE_PROJECT::TEMPLATE_PROJECT_static_analyzers
)