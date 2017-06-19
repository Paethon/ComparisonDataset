using ComparisonDataset
@testset "Rect" begin
  @testset "Basic" begin
    a = Rect(10, 20, 30, 40)
    @test top(a) == 10
    @test left(a) == 20
    @test bottom(a) == 30
    @test right(a) == 40
    @test width(a) == 20
    @test height(a) == 20
  end

  @testset "Reordering" begin
    a = Rect(30, 40, 10, 20)
    @test top(a) == 10
    @test left(a) == 20
    @test bottom(a) == 30
    @test right(a) == 40
    @test width(a) == 20
    @test height(a) == 20
  end
end
# Test overlapping
o1 = Rect(0,0,10,10)
o2 = Rect(-1,-1,4,4)
o3 = Rect(5,-1,15,4)
o4 = Rect(-1,8,4,15)
o5 = Rect(6,8,15,15)

@test isoverlapping(o1,o2) == true
@test isoverlapping(o2,o1) == true
@test isoverlapping(o1,o3) == true
@test isoverlapping(o3,o1) == true
@test isoverlapping(o1,o4) == true
@test isoverlapping(o4,o1) == true
@test isoverlapping(o1,o5) == true
@test isoverlapping(o5,o1) == true
@test isoverlapping(o2,o3) == false
@test isoverlapping(o2,o4) == false
@test isoverlapping(o2,o5) == false
@test isoverlapping(o3,o4) == false
@test isoverlapping(o3,o5) == false
@test isoverlapping(o4,o5) == false
