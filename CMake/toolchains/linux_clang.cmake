include_guard()

set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)

set(VCPKG_CMAKE_SYSTEM_NAME Linux)

# set(CMAKE_CXX_COMPILER "/usr/bin/clang++")
# set(CMAKE_C_COMPILER "/usr/bin/clang")

# string(APPEND CMAKE_C_FLAGS_INIT " -stdlib=libc++")
# string(APPEND CMAKE_CXX_FLAGS_INIT " -stdlib=libc++")

# string(APPEND CMAKE_MODULE_LINKER_FLAGS_INIT " -lc++")
# string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT " -lc++")
# string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " -lc++")
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/../toolchains/linux_clang.chainload.cmake")

include("$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")