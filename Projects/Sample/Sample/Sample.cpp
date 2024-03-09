#include "Sample/Sample.h"

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
}

} // namespace Smpl
