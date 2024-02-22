include_guard()

find_program(CPPCHECK cppcheck)
find_program(CLANGTIDY clang-tidy)

macro(
  TEMPLATE_PROJECT_enable_cppcheck
  WARNINGS_AS_ERRORS
  CPPCHECK_OPTIONS)
  if(NOT CPPCHECK)
    message(WARNING "cppcheck requested but executable not found")
    return()
  endif()

  if(CMAKE_GENERATOR MATCHES ".*Visual Studio.*")
    set(CPPCHECK_TEMPLATE "vs")
  else()
    set(CPPCHECK_TEMPLATE "gcc")
  endif()

  if("${CPPCHECK_OPTIONS}" STREQUAL "")
    # Enable all warnings that are actionable by the user of this toolset
    # style should enable the other 3, but we'll be explicit just in case
    set(CMAKE_CXX_CPPCHECK
      ${CPPCHECK}
      --template=${CPPCHECK_TEMPLATE}
      --enable=style,performance,warning,portability
      --inline-suppr

      # We cannot act on a bug/missing feature of cppcheck
      --suppress=cppcheckError
      --suppress=internalAstError

      # if a file does not have an internalAstError, we get an unmatchedSuppression error
      --suppress=unmatchedSuppression

      # noisy and incorrect sometimes
      --suppress=passedByValue

      # ignores code that cppcheck thinks is invalid C++
      --suppress=syntaxError
      --suppress=preprocessorErrorDirective
      --inconclusive)
  else()
    # if the user provides a CPPCHECK_OPTIONS with a template specified, it will override this template
    set(CMAKE_CXX_CPPCHECK ${CPPCHECK} --template=${CPPCHECK_TEMPLATE} ${CPPCHECK_OPTIONS})
  endif()

  if(NOT "${CMAKE_CXX_STANDARD}" STREQUAL "")
    if(CMAKE_CXX_STANDARD LESS 23)
      set(CMAKE_CXX_CPPCHECK ${CMAKE_CXX_CPPCHECK} --std=c++${CMAKE_CXX_STANDARD})
    else()
      # cppcheck doesn't support standard greater than c++20 yet.
      set(CMAKE_CXX_CPPCHECK ${CMAKE_CXX_CPPCHECK} --std=c++20)
    endif()
  endif()

  if(${WARNINGS_AS_ERRORS})
    list(APPEND CMAKE_CXX_CPPCHECK --error-exitcode=2)
  endif()
endmacro()

macro(
  add_target_interface_clang_tidy
  TARGET_NAME
  WARNINGS_AS_ERRORS
)
  if(NOT CLANGTIDY)
    message(${WARNING_MESSAGE} "clang-tidy requested but executable not found")
    return()
  endif()

  if(NOT CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    get_target_property(TARGET_PCH ${TARGET_NAME} INTERFACE_PRECOMPILE_HEADERS)

    if("${TARGET_PCH}" STREQUAL "TARGET_PCH-NOTFOUND")
      get_target_property(TARGET_PCH ${TARGET_NAME} PRECOMPILE_HEADERS)
    endif()

    if(NOT("${TARGET_PCH}" STREQUAL "TARGET_PCH-NOTFOUND"))
      message(SEND_ERROR "clang-tidy cannot be enabled with non-clang compiler and PCH, clang-tidy fails to handle gcc's PCH file")
    endif()
  endif()

  set(CLANG_TIDY_OPTIONS
    ${CLANGTIDY}
    -extra-arg=-Wno-unknown-warning-option
    -extra-arg=-Wno-ignored-optimization-argument
    -extra-arg=-Wno-unused-command-line-argument
    -p)

  # set standard
  if(NOT "${CMAKE_CXX_STANDARD}" STREQUAL "")
    if(CMAKE_CXX_COMPILER_ID MATCHES ".*MSVC")
      set(CLANG_TIDY_OPTIONS ${CLANG_TIDY_OPTIONS} -extra-arg=/std:c++${CMAKE_CXX_STANDARD})
    else()
      set(CLANG_TIDY_OPTIONS ${CLANG_TIDY_OPTIONS} -extra-arg=-std=c++${CMAKE_CXX_STANDARD})
    endif()
  endif()

  if(${WARNINGS_AS_ERRORS})
    list(APPEND CLANG_TIDY_OPTIONS -warnings-as-errors=*)
  endif()

  set(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY_OPTIONS})
endmacro()