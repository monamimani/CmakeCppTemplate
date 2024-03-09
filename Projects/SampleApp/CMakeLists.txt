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
)

set(moduleFiles
)

set(privateFiles
  main.cpp
)

set(testFiles
)

set(benchmarkFiles
)

add_executable(${targetName})
add_executable(TEMPLATE_PROJECT::${targetName} ALIAS ${targetName})

target_include_directories(${targetName}
  PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}"
)

target_sources(${targetName}
  PRIVATE ${privateFiles} ${platform_privateFiles}
  PUBLIC ${publicFiles}
  INTERFACE ${interfaceFiles}
)

set(privateLibs
  TEMPLATE_PROJECT::Config
  TEMPLATE_PROJECT::Sample
)

target_link_libraries(${targetName}
  PRIVATE
  ${privateLibs}

  TEMPLATE_PROJECT::TEMPLATE_PROJECT_options
  TEMPLATE_PROJECT::TEMPLATE_PROJECT_warnings
  TEMPLATE_PROJECT::TEMPLATE_PROJECT_sanitizers
)