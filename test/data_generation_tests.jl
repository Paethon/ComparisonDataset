sz = CD.Size(64,32)
@test CD.width(sz) == 32
@test CD.height(sz) == 64

sz = CD.Size(64,64)
patchsize = CD.Size(8,8)
sample = CD.gensample(Int8, sz, patchsize, 5, 3)
@test size(sample) == (64,64)
@test 0 ∈ sample
@test 1 ∈ sample

@test eltype(CD.gensample(sz, patchsize, 5, 3)) == Int8
