#pragma once

#include "Config/Config.h"

namespace Smpl
{
int getAnswer();

[[nodiscard]] inline auto getProjectVersion()
{
  return TEMPLATE_PROJECT::Config::projectVersion;
}
} // namespace Smpl
