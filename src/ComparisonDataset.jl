__precompile__()

module ComparisonDataset

using Images
import Base: size, rand, rand!, ==

include("rect.jl")
include("data_generation.jl")
include("patch.jl")
include("sample.jl")

export Size, Patch, Sample
export render
end # module
