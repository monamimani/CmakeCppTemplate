#include <cstdlib>
#include <print>

#include "Sample/Sample.h"

// NOLINTNEXTLINE(bugprone-exception-escape)
int main()
{
  std::println("Project version: , {}", Smpl::getProjectVersion());
  return EXIT_SUCCESS;
}
