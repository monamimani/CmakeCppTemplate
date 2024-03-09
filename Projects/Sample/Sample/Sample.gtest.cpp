#ifdef TEST_GTEST
  #include "Sample/Sample.h"

  #include "gtest/gtest.h"

extern "C"
{
  // NOLINTBEGIN(readability-identifier-naming,bugprone-reserved-identifier,cert-dcl37-c,cert-dcl51-cpp)
  void __ubsan_on_report()
  {
    FAIL() << "Encountered an undefined behavior sanitizer error";
  }

  void __asan_on_error()
  {
    FAIL() << "Encountered an address sanitizer error";
  }

  void __tsan_on_report()
  {
    FAIL() << "Encountered a thread sanitizer error";
  }

  // NOLINTEND(readability-identifier-naming,bugprone-reserved-identifier,cert-dcl37-c,cert-dcl51-cpp)
} // extern "C"

TEST(FactorialsAreComputed, Factorial)
{
  ASSERT_EQ(Smpl::factorial(0), 1);
  ASSERT_EQ(Smpl::factorial(1), 1);
  ASSERT_EQ(Smpl::factorial(2), 2);
  ASSERT_EQ(Smpl::factorial(3), 6);
  ASSERT_EQ(Smpl::factorial(10), 3'628'800);
}

#endif
