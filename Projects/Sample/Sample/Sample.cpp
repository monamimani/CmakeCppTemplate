#include "Sample/Sample.h"

// #include <cmath>

namespace Smpl
{
int factorial(int input) noexcept
{
  int result = 1;

  while (input > 0)
  {
    result *= input;
    --input;
  }

  return result;

  // return std::tgamma(input + 1);
}

} // namespace Smpl
