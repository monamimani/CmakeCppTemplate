include_guard()

include(CheckCXXCompilerFlag)

function(configure_code_hardening UBSAN_MIN_RUNTIME)
  message(STATUS "Enabling Code Hardening")

  set(CODE_HARDENING_COMPILE_OPTIONS "")
  set(CODE_HARDENING_LINK_OPTIONS "")
  set(CODE_HARDENING_CXX_DEFINITIONS "")

  if(MSVC)
    set(CODE_HARDENING_COMPILE_OPTIONS "${CODE_HARDENING_COMPILE_OPTIONS} /sdl /DYNAMICBASE /guard:cf")
    message(STATUS "MSVC flags: /sdl /DYNAMICBASE /guard:cf /NXCOMPAT /CETCOMPAT")
    set(CODE_HARDENING_LINK_OPTIONS "${CODE_HARDENING_LINK_OPTIONS} /NXCOMPAT /CETCOMPAT")

  elseif(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang|GNU")
    set(CODE_HARDENING_CXX_DEFINITIONS "${CODE_HARDENING_CXX_DEFINITIONS} -D_GLIBCXX_ASSERTIONS")
    message(STATUS "GLIBC++ Assertions (vector[], string[], ...) enabled")

    set(CODE_HARDENING_COMPILE_OPTIONS "${CODE_HARDENING_COMPILE_OPTIONS} -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3")
    message(STATUS "g++/clang _FORTIFY_SOURCE=3 enabled")

    # check_cxx_compiler_flag(-fpie PIE)
    # if(PIE)
    # set(CODE_HARDENING_COMPILE_OPTIONS ${CODE_HARDENING_COMPILE_OPTIONS} -fpie)
    # set(CODE_HARDENING_LINK_OPTIONS ${CODE_HARDENING_LINK_OPTIONS} -pie)
    #
    # message(STATUS "g++/clang PIE mode enabled")
    # else()
    # message(STATUS "g++/clang PIE mode NOT enabled (NOT supported)")
    # endif()
    check_cxx_compiler_flag(-fstack-protector-strong STACK_PROTECTOR)

    if(STACK_PROTECTOR)
      set(CODE_HARDENING_COMPILE_OPTIONS "${CODE_HARDENING_COMPILE_OPTIONS} -fstack-protector-strong")
      message(STATUS "g++/clang -fstack-protector-strong enabled")
    else()
      message(STATUS "g++/clang -fstack-protector-strong NOT enabled (NOT supported)")
    endif()

    check_cxx_compiler_flag(-fcf-protection CF_PROTECTION)

    if(CF_PROTECTION)
      set(CODE_HARDENING_COMPILE_OPTIONS "${CODE_HARDENING_COMPILE_OPTIONS} -fcf-protection")
      message(STATUS "g++/clang -fcf-protection enabled")
    else()
      message(STATUS "g++/clang -fcf-protection NOT enabled (NOT supported)")
    endif()

    check_cxx_compiler_flag(-fstack-clash-protection CLASH_PROTECTION)

    if(CLASH_PROTECTION)
      if(LINUX OR CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        set(CODE_HARDENING_COMPILE_OPTIONS "${CODE_HARDENING_COMPILE_OPTIONS} -fstack-clash-protection")
        message(STATUS "g++/clang -fstack-clash-protection enabled")
      else()
        message(STATUS "g++/clang -fstack-clash-protection NOT enabled (clang on non-Linux)")
      endif()
    else()
      message(STATUS "g++/clang -fstack-clash-protection NOT enabled (NOT supported)")
    endif()
  endif()

  if(UBSAN_MIN_RUNTIME)
    check_cxx_compiler_flag("-fsanitize=undefined -fno-sanitize-recover=undefined -fsanitize-minimal-runtime"
      MINIMAL_RUNTIME)

    if(MINIMAL_RUNTIME)
      set(CODE_HARDENING_COMPILE_OPTIONS "${CODE_HARDENING_COMPILE_OPTIONS} -fsanitize=undefined -fsanitize-minimal-runtime")
      set(CODE_HARDENING_LINK_OPTIONS "${CODE_HARDENING_LINK_OPTIONS} -fsanitize=undefined -fsanitize-minimal-runtime")

      if(NOT ${global})
        set(CODE_HARDENING_COMPILE_OPTIONS "${CODE_HARDENING_COMPILE_OPTIONS} -fno-sanitize-recover=undefined")
        set(CODE_HARDENING_LINK_OPTIONS "${CODE_HARDENING_LINK_OPTIONS} -fno-sanitize-recover=undefined")
      else()
        message(STATUS "not enabling -fno-sanitize-recover=undefined for global consumption")
      endif()

      message(STATUS "ubsan minimal runtime enabled")
    else()
      message(STATUS "ubsan minimal runtime NOT enabled (NOT supported)")
    endif()
  else()
    message(STATUS "ubsan minimal runtime NOT enabled (NOT requested)")
  endif()

  message(STATUS "Hardening Compiler Flags: ${CODE_HARDENING_COMPILE_OPTIONS}")
  message(STATUS "Hardening Linker Flags: ${CODE_HARDENING_LINK_OPTIONS}")
  message(STATUS "Hardening Compiler Defines: ${CODE_HARDENING_CXX_DEFINITIONS}")

  set_property(GLOBAL PROPERTY CODE_HARDENING_COMPILE_OPTIONS_PROPERTY "${CODE_HARDENING_COMPILE_OPTIONS}")
  set_property(GLOBAL PROPERTY CODE_HARDENING_LINK_OPTIONS_PROPERTY "${CODE_HARDENING_LINK_OPTIONS}")
  set_property(GLOBAL PROPERTY CODE_HARDENING_CXX_DEFINITIONS_PROPERTY "${CODE_HARDENING_CXX_DEFINITIONS}")
endfunction()

function(add_global_code_hardening)
  message(STATUS "Setting hardening options globally for all dependencies")

  get_property(CODE_HARDENING_COMPILE_OPTIONS GLOBAL PROPERTY CODE_HARDENING_COMPILE_OPTIONS_PROPERTY)
  get_property(CODE_HARDENING_LINK_OPTIONS GLOBAL PROPERTY CODE_HARDENING_LINK_OPTIONS_PROPERTY)
  get_property(CODE_HARDENING_CXX_DEFINITIONS GLOBAL PROPERTY CODE_HARDENING_CXX_DEFINITIONS_PROPERTY)

  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CODE_HARDENING_COMPILE_OPTIONS}")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${CODE_HARDENING_LINK_OPTIONS}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CODE_HARDENING_CXX_DEFINITIONS}")
endfunction()

function(add_target_interface_code_hardening TARGET_NAME)
  get_property(CODE_HARDENING_COMPILE_OPTIONS GLOBAL PROPERTY CODE_HARDENING_COMPILE_OPTIONS_PROPERTY)
  get_property(CODE_HARDENING_LINK_OPTIONS GLOBAL PROPERTY CODE_HARDENING_LINK_OPTIONS_PROPERTY)
  get_property(CODE_HARDENING_CXX_DEFINITIONS GLOBAL PROPERTY CODE_HARDENING_CXX_DEFINITIONS_PROPERTY)

  target_compile_options(${TARGET_NAME} INTERFACE ${CODE_HARDENING_COMPILE_OPTIONS})
  target_link_options(${TARGET_NAME} INTERFACE ${CODE_HARDENING_LINK_OPTIONS})
  target_compile_definitions(${TARGET_NAME} INTERFACE ${CODE_HARDENING_CXX_DEFINITIONS})
endfunction()