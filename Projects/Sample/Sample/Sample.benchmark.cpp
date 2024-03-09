#include "Sample/Sample.h"

#include "benchmark/benchmark.h"

namespace
{
void factorial(benchmark::State& state) // cppcheck-suppress [constParameter]
{
  for ([[maybe_unused]] auto _ : state)
  {
    const auto val = 10;
    auto result = Smpl::factorial(val);
    benchmark::DoNotOptimize(result);
  }
}
} // namespace

BENCHMARK(::factorial);
