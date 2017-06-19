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
@test_throws BoundsError paste!(o,z,1, 1)

# Test grow
a = [1 2 3
     4 5 6
     7 8 9]
@test grow(a,2) ==
  [1 1 2 2 3 3
   1 1 2 2 3 3
   4 4 5 5 6 6
   4 4 5 5 6 6
   7 7 8 8 9 9
   7 7 8 8 9 9]

b = [1 2
     3 4]
@test grow(b,3) ==
  [1 1 1 2 2 2
   1 1 1 2 2 2
   1 1 1 2 2 2
   3 3 3 4 4 4
   3 3 3 4 4 4
   3 3 3 4 4 4]

@test grow(a, 1) == a
@test grow(b, 1) == b
@test_throws AssertionError grow(a, 0)
