CD = ComparisonDataset

@testset "Rect" begin
  @testset "Basic" begin
    a = CD.Rect(10, 20, 30, 40)
    @test CD.top(a) == 10
    @test CD.left(a) == 20
    @test CD.bottom(a) == 30
    @test CD.right(a) == 40
    @test CD.width(a) == 20
    @test CD.height(a) == 20
  end

  @testset "Reordering" begin
    a = CD.Rect(30, 40, 10, 20)
    @test CD.top(a) == 10
    @test CD.left(a) == 20
    @test CD.bottom(a) == 30
    @test CD.right(a) == 40
    @test CD.width(a) == 20
    @test CD.height(a) == 20
  end
end
# Test overlapping
o1 = CD.Rect(0,0,10,10)
o2 = CD.Rect(-1,-1,4,4)
o3 = CD.Rect(5,-1,15,4)
o4 = CD.Rect(-1,8,4,15)
o5 = CD.Rect(6,8,15,15)

@test CD.isoverlapping(o1,o2) == true
@test CD.isoverlapping(o2,o1) == true
@test CD.isoverlapping(o1,o3) == true
@test CD.isoverlapping(o3,o1) == true
@test CD.isoverlapping(o1,o4) == true
@test CD.isoverlapping(o4,o1) == true
@test CD.isoverlapping(o1,o5) == true
@test CD.isoverlapping(o5,o1) == true
@test CD.isoverlapping(o2,o3) == false
@test CD.isoverlapping(o2,o4) == false
@test CD.isoverlapping(o2,o5) == false
@test CD.isoverlapping(o3,o4) == false
@test CD.isoverlapping(o3,o5) == false
@test CD.isoverlapping(o4,o5) == false

# Test random Rect generation
r = CD.randrect(20, 20, 10, 15)
@test CD.width(r) == 10
@test CD.height(r) == 15

rects = (CD.randrect(20, 20, 10, 15) for i in 1:100)
borders = (CD.left(r) > 0 &&
           CD.right(r) <= 20 &&
           CD.top(r) > 0 &&
           CD.bottom(r) <= 20 for r in rects)
@test false ∉ borders

# Test random non-overlapping Rect generation
rects = CD.nonoverlappingrandrect(100,100,10,10,10)
@test length(rects) == 10
borders = (CD.left(r) > 0 &&
           CD.right(r) <= 100 &&
           CD.top(r) > 0 &&
           CD.bottom(r) <= 100 for r in rects)
@test false ∉ borders
# Ensure none of the rects are overlapping
overlapping = false
for (a,b) in ((a,b) for a in rects, b in rects)
  if a ≠ b && CD.isoverlapping(a,b)
    overlapping = true
    break
  end
end
@test overlapping == false
# Test for exhaustion during search
@test_throws CD.ExhaustionError CD.nonoverlappingrandrect(20,20,10,10,100)
