#include <cstdlib>
#include <iostream>
// #include <print>

#include "Sample/Sample.h"

// NOLINTNEXTLINE(bugprone-exception-escape)
int main()
{
  std::cout << Smpl::getProjectVersion() << "\n";
  // std::println("Project version: , {}", Smpl::getProjectVersion());
  return EXIT_SUCCESS;
}
