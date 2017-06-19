"Return an array of size n x n filled with random true/false values"
genpatch(n::Integer) = [rand(Bool) for y in 1:n, x in 1:n]

"Insert given smaller array into bigger array"
function paste!{T}(a::AbstractArray{T,2}, b::AbstractArray{T,2},
                   col::Integer, row::Integer)
  a[col:col+size(b,1)-1,row:row+size(b,2)-1] = b
  return a
end

"Scales array using nearest neighbor by an integer factor"
function grow(a::AbstractMatrix, scale::Int)
  @assert scale > 0 "You can not grow an array by an amount < 1: $scale"
  res = Matrix{eltype(a)}(size(a,1)*scale, size(a,2)*scale)
  for r in 0:size(a,2) - 1
    for c in 0:size(a,1) - 1
      col = c*scale + 1
      row = r*scale + 1
      res[col:col + scale - 1,row:row + scale - 1] = a[c + 1,r + 1]
    end
  end
  return res
end

export genpatch, paste!, grow
