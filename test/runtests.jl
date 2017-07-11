using ComparisonDataset
using Base.Test

using ComparisonDataset

@testset "Rect Tests" begin include("rect_tests.jl") end
@testset "Patch Tests" begin include("patch_tests.jl") end
@testset "Data Generation Tests" begin include("data_generation_tests.jl") end
@testset "Sample Tests" begin include("sample_tests.jl") end
