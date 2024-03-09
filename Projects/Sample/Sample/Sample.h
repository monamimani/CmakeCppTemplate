#pragma once

#include "Config/Config.h"
#include "Sample/SampleExports.h"

namespace Smpl
{

[[nodiscard]] constexpr inline auto getProjectVersion() noexcept
{
  return TEMPLATE_PROJECT::Config::projectVersion;
}

[[nodiscard]] SAMPLE_EXPORT int factorial(int) noexcept;

[[nodiscard]] constexpr int factorial_constexpr(int input) noexcept
{
  if (input == 0)
  {
    return 1;
  }

  return input * factorial_constexpr(input - 1);
}

} // namespace Smpl
