
#include <cstddef>
#include <cstdint>
#include <iostream>
#include <iterator>

// #include <utility>

[[nodiscard]] auto sumValues(const uint8_t* data, std::size_t size)
{
  constexpr auto scale = 1'000;

  int value = 0;
  for (std::size_t offset = 0; offset < size; ++offset)
  {
    value += static_cast<int>(*std::next(data, static_cast<long>(offset))) * scale;
  }
  return value;
}

// Fuzzer that attempts to invoke undefined behavior for signed integer overflow
// cppcheck-suppress unusedFunction symbolName=LLVMFuzzerTestOneInput
// NOLINTNEXTLINE(readability-identifier-naming)
extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, std::size_t size)
{
  // std::cout << std::format("Value sum: {}, len{}\n", sumValues(data, size), size);
  std::cout << "Value sum: " << sumValues(data, size) << " len " << size << "\n";
  return 0;
}
