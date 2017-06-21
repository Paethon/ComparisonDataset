sz = CD.Size(64,32)
@test CD.width(sz) == 32
@test CD.height(sz) == 64

# Test patch generation
@test size(CD.genpatch(0)) == (0,0)
patch = CD.genpatch(50)
@test size(patch) == (50, 50)
@test 0 ∈ patch
@test 1 ∈ patch

patch = CD.genpatch([1,2], 10)
@test 1 ∈ patch
@test 2 ∈ patch
@test 0 ∉ patch

patch = zeros(Int8, 10, 10)
CD.genpatch!(patch)
@test 0 ∈ patch
@test 1 ∈ patch
patch = zeros(Int8, 10, 10)
CD.genpatch!(patch, Int8[1,2])
@test 1 ∈ patch
@test 2 ∈ patch
@test 0 ∉ patch


# Test gensample
sz = CD.Size(64,64)
patchsize = CD.Size(8,8)
sample = CD.gensample(Int8, sz, patchsize, 5, 3)
@test size(sample) == (64,64)
@test 0 ∈ sample
@test 1 ∈ sample
@test 1 ∉ CD.gensample(sz, patchsize, 0, 0)

@test eltype(CD.gensample(sz, patchsize, 5, 3)) == Int8
@test_throws AssertionError CD.gensample(sz, patchsize, 5, 6)
@test_throws AssertionError CD.gensample(Int8, sz, patchsize, 5, 6)
