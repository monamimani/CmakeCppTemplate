#pragma once

#include "Config/Config.h"
#include "Sample/SampleExports.h"

namespace Smpl
{
int getAnswer();

[[nodiscard]] constexpr inline auto getProjectVersion() noexcept
{
  return TEMPLATE_PROJECT::Config::projectVersion;
}
} // namespace Smpl
