#ifdef TEST_CATCH2
  #include "Sample/Sample.h"

// #include <iterator>

  #include "catch2/benchmark/catch_benchmark.hpp"
  #include "catch2/catch_test_macros.hpp"
// #include "fmt/format.h"

extern "C"
{
  // NOLINTBEGIN(readability-identifier-naming,bugprone-reserved-identifier,cert-dcl37-c,cert-dcl51-cpp)
  // const char* __ubsan_default_options()
  // {
  // llvm-project/compiler-rt/lib/ubsan/ubsan_flags.inc
  //   return "print_stacktrace=1:halt_on_error=0";
  // }

  // void __ubsan_on_report()
  // {
  //   char* issueKind{};
  //   char* message{};
  //   char* filename{};
  //   unsigned int line{};
  //   unsigned int col{};
  //   char* memoryAddr{};
  //   extern void __ubsan_get_current_report_data(char** issueKind, char** message, char** filename, unsigned int* line, unsigned int* col, char** memoryAddr);

  //   __ubsan_get_current_report_data(&issueKind, &message, &filename, &line, &col, &memoryAddr);

  //   auto out = fmt::memory_buffer();
  //   fmt::format_to(std::back_inserter(out), "{}:{}:{}: runtime error: {}: {}\n", filename, line, col, issueKind, message);
  //   fmt::format_to(std::back_inserter(out), "SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior {}:{}:{}", filename, line, col);

  //   FAIL(out.data());
  // }

  // const char* __asan_default_options()
  // {
  // llvm-project/compiler-rt/lib/asan/asan_activation_flags.inc
  //   return
  //   "verbosity=0:print_stacktrace=1:halt_on_error=1:detect_leaks=__LEAK_CHECK_1_0__:max_malloc_fill_size=4096000:quarantine_size_mb=16:verify_asan_link_order=0:detect_stack_use_after_return=__STACK_USE_AFTER_RETURN__";
  // }

  // void __asan_on_error()
  // {
  //   FAIL("Encountered an address sanitizer error");
  // }

  // const char* __tsan_default_options()
  // {
  // llvm-project/compiler-rt/lib/tsan/rtl/tsan_flags.inc
  //   return "halt_on_error=1:abort_on_error=1:report_signal_unsafe=0"
  //       ":allocator_may_return_null=1";
  // }

  // void __tsan_on_report()
  // {
  //   FAIL("Encountered a thread sanitizer error");
  // }

  // NOLINTEND(readability-identifier-naming,bugprone-reserved-identifier,cert-dcl37-c,cert-dcl51-cpp)
} // extern "C"

TEST_CASE("Factorials are computed", "[factorial]")
{
  // NOLINTBEGIN(bugprone-chained-comparison)
  REQUIRE(Smpl::factorial(0) == 1);
  REQUIRE(Smpl::factorial(1) == 1);
  REQUIRE(Smpl::factorial(2) == 2);
  REQUIRE(Smpl::factorial(3) == 6);
  REQUIRE(Smpl::factorial(10) == 3'628'800);
  // NOLINTEND(bugprone-chained-comparison)

  const auto valA = 10;
  BENCHMARK("factorial 10")
  {
    return Smpl::factorial(valA);
  };

  const auto valB = 12;
  BENCHMARK("factorial 12")
  {
    return Smpl::factorial(valB);
  };
}

TEST_CASE("Factorials are computed with constexpr", "[factorial]")
{
  STATIC_REQUIRE(Smpl::factorial_constexpr(0) == 1);
  STATIC_REQUIRE(Smpl::factorial_constexpr(1) == 1);
  STATIC_REQUIRE(Smpl::factorial_constexpr(2) == 2);
  STATIC_REQUIRE(Smpl::factorial_constexpr(3) == 6);
  STATIC_REQUIRE(Smpl::factorial_constexpr(10) == 3'628'800);
}

#endif
