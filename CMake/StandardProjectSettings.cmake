include_guard()

option(TEMPLATE_PROJECT_BASIC_BUILD_MODE "Disable most of the nice to have build features." OFF)

# https://cmake.org/cmake/help/latest/module/GenerateExportHeader.html
# used for the function generate_export_header( someLib) that will generate a header file somelib_export.h for exporting symbol from a dynamic library. 
set(CMAKE_CXX_VISIBILITY_PRESET hidden)