CD = ComparisonDataset

# Test patch pasting
z = zeros(Int, 10, 10)
o = ones(Int, 2, 2)
CD.paste!(z, o, 4, 4)
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
@test_throws BoundsError CD.paste!(z,o, -1, -1)
@test_throws BoundsError CD.paste!(z,o, 10, 10)
@test_throws BoundsError CD.paste!(o,z,1, 1)

# Test grow
a = [1 2 3
     4 5 6
     7 8 9]
@test CD.grow(a,2) ==
  [1 1 2 2 3 3
   1 1 2 2 3 3
   4 4 5 5 6 6
   4 4 5 5 6 6
   7 7 8 8 9 9
   7 7 8 8 9 9]

b = [1 2
     3 4]
@test CD.grow(b,3) ==
  [1 1 1 2 2 2
   1 1 1 2 2 2
   1 1 1 2 2 2
   3 3 3 4 4 4
   3 3 3 4 4 4
   3 3 3 4 4 4]

@test CD.grow(a, 1) == a
@test CD.grow(b, 1) == b
@test_throws AssertionError CD.grow(a, 0)

@testset "Patch" begin
  # Test patch generation
  p = CD.Patch(CD.Size(30,50),[0,1], 12, 13)
  @test CD.top(p) == 12
  @test CD.left(p) == 13
  @test CD.width(p) == 50
  @test CD.height(p) == 30
  @test CD.set(p) == Set([0,1])
  con = copy(CD.content(p))
  @test size(con) == (30,50)

  # Test random filling of patch
  rand!(p)
  @test CD.content(p) != con
  @test 1 ∈ CD.content(p)
  @test 0 ∈ CD.content(p)
  @test count(x->x==0, CD.content(p)) + count(x->x==1,CD.content(p)) == 30*50

  # Test random generation of patch
  rndp = rand(Patch, CD.Size(20,10), Set([0,1]), 2, 4)
  @test 0 ∈ CD.content(rndp)
  @test 1 ∈ CD.content(rndp)
  @test size(CD.content(rndp)) == (20, 10)
  rndp = rand(Patch, CD.Size(20,10), [0,1], 2, 4)
  @test 0 ∈ CD.content(rndp)
  @test 1 ∈ CD.content(rndp)
  @test size(CD.content(rndp)) == (20, 10)


  # Test flipping of elements of content
  con = copy(CD.content(p))
  CD.flip!(p,2)
  @test sum(con .!= CD.content(p)) == 2

  newpatch = CD.flip(p, 5)
  @test sum(CD.content(newpatch) .!= CD.content(p)) == 5
  @test CD.content(newpatch) !== CD.content(p)

  # Test equality
  mat = zeros(Int, 8,8)
  @test p != newpatch
  p1 = CD.Patch(mat,Set([0,1]), 12, 13)
  p2 = CD.Patch(mat,Set([0,1]), 12, 13)
  @test p1 == p2
  p2 = CD.Patch(mat,Set([0,1]), 12, 14)
  @test p1 != p2
  p2 = CD.Patch(mat,Set([0,1]), 11, 13)
  @test p1 != p2
  p2 = CD.Patch(mat,Set([1,1]), 12, 13)
  @test p1 != p2
  p2 = CD.Patch(mat,Set([0,0]), 12, 13)
  @test p1 != p2
  p2 = CD.Patch(zeros(Int, 8, 9),Set([0,1]), 12, 13)
  @test p1 != p2
  p2 = CD.Patch(zeros(Int, 9, 8),Set([0,1]), 12, 13)
  @test p1 != p2
  p2 = CD.Patch(ones(Int, 8, 8),Set([0,1]), 12, 13)
  @test p1 != p2
end
