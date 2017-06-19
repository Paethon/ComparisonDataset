# Test patch generation
@test size(genpatch(0)) == (0,0)
patch = genpatch(50)
@test size(patch) == (50, 50)
@test true ∈ patch
@test false ∈ patch

# Test patch pasting
z = zeros(Int, 10, 10)
o = ones(Int, 2, 2)
paste!(z, o, 4, 4)
@test z ==
[0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  1  1  0  0  0  0  0
 0  0  0  1  1  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0]
@test o == ones(2,2)
@test_throws BoundsError paste!(z,o, -1, -1)
@test_throws BoundsError paste!(z,o, 10, 10)
