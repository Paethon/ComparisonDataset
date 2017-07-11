@testset "Simple generation and general methods" begin
  s = CD.Sample(CD.Size(23,24), 23, [0, 1])
  @test length(CD.patches(s)) == 0
  @test size(s) == (23,24)
  @test size(s,1) == 23
  @test size(s,2) == 24
end

@testset "Random Patch fill" begin
  s = CD.Sample(CD.Size(64), 2, [0, 1])
  s = rand(s; patchsize=CD.Size(8), nbpatches=5, nbsame=3, diff=2)
  @test length(CD.patches(s)) == 5
  for i in CD.patches(s)
    @test 0 ∈ CD.content(i)
    @test 1 ∈ CD.content(i)
    @test 2 ∉ CD.content(i)
  end

  rd = CD.render(s)
  @test 0 ∈ rd
  @test 1 ∈ rd
  @test 2 ∈ rd
  @test size(rd) == (64, 64)
end
