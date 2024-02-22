#include <cstdlib>
#include <print>

#include "Sample/Sample.h"

// NOLINTNEXTLINE(bugprone-exception-escape)
int main()
{
  const auto value = Smpl::getAnswer();
  std::println("Hello World, {}", value);
  return EXIT_SUCCESS;
}
