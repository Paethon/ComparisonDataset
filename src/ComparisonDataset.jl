__precompile__()

module ComparisonDataset

using Images
import Base.rand

include("rect.jl")
include("patch_handling.jl")
include("data_generation.jl")

export Size, gensample

end # module
