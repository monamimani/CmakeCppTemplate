include_guard()

# Output binary to predictable location.
# First for the single configuration generators case (e.g. Makefiles, Ninja)
set(BINARY_OUT_DIR ${CMAKE_BINARY_DIR}/_bin)
set(LIB_OUT_DIR ${CMAKE_BINARY_DIR}/_lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BINARY_OUT_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${LIB_OUT_DIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${LIB_OUT_DIR})

# Second, for multi-config builds (e.g. Visual Studio, Ninja Multi-Config)
get_property(BUILDING_MULTI_CONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

if(BUILDING_MULTI_CONFIG)
  foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    set(BINARY_OUT_DIR ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/_bin)
    set(LIB_OUT_DIR ${CMAKE_BINARY_DIR}/${OUTPUTCONFIG}/_lib)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${BINARY_OUT_DIR})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${LIB_OUT_DIR})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${LIB_OUT_DIR})
  endforeach(OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES)
endif()