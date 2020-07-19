# module ComparisonDataset

using Images, Random, Revise
import Base: size, rand, ==
import Random: rand!

includet("rect.jl")
includet("data_generation.jl")
includet("patch.jl")
includet("sample.jl")

# export Size, Patch, Sample
# export render
# end # module
