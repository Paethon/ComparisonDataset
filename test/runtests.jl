using ComparisonDataset
using Base.Test

using ComparisonDataset

@testset "Rect Tests" begin include("rect_tests.jl") end
@testset "Patch Handling Tests" begin include("patch_handling_tests.jl") end
@testset "Data Generation Tests" begin include("data_generation_tests.jl") end
