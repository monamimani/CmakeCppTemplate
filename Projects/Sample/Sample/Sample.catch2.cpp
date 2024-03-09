#ifdef TEST_CATCH2
  #include "Sample/Sample.h"

  #include "catch2/catch_test_macros.hpp"

TEST_CASE("Factorials are computed", "[factorial]")
{
  REQUIRE((Smpl::factorial(0) == 1));
  REQUIRE((Smpl::factorial(1) == 1));
  REQUIRE((Smpl::factorial(2) == 2));
  REQUIRE((Smpl::factorial(3) == 6));
  REQUIRE((Smpl::factorial(10) == 3'628'800));
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
