"""
Encodes a single patch in an image
"""
struct Patch{T, I<:Integer}
  content::Matrix{T}
  set::Set{T} # Set of possible values in content
  top::I # Position of patch in bigger image
  left::I # Position of patch in bigger image
end

function Patch(s::Size, set::Set{T}, top::I, left::I) where {T, I<:Integer}
  mat = Matrix{T}(undef, height(s), width(s))
  return Patch(mat, set, top, left)
end

function Patch(s::Size, set::Vector{T}, top::I, left::I) where {T, I<:Integer}
  mat = Matrix{T}(undef, height(s), width(s))
  return Patch(mat, Set(set), top, left)
end

content(p::Patch) = p.content
set(p::Patch) = p.set
top(p::Patch) = p.top
left(p::Patch) = p.left
width(p::Patch) = size(p.content, 2)
height(p::Patch) = size(p.content, 1)

"""
rand(::Type{Patch}, s::Size, set::Vector, top, left)

Generate a patch containing random elements from set
"""
function Base.rand(::Type{Patch}, s::Size, set::Vector, top::I, left::I) where I<:Integer
  mat = rand(set, height(s), width(s))
  return Patch(mat, Set(set), top, left)
end

"""
rand(::Type{Patch}, s::Size, set::Set, top, left)

Generate a patch containing random elements from set
"""
function Base.rand(::Type{Patch}, s::Size, set::Set, top::I, left::I) where I<:Integer
  return rand(Patch, s, collect(set), top, left)
end

"""
rand!(p::Patch)

Populate a patch with random values
"""
function Random.rand!(p::Patch)
  rand!(content(p), collect(set(p)))
end

"""
flip!(p::Patch, n::Integer)

Randomly flip n entries of a patch
"""
function flip!(p::Patch, n::Integer)
  @assert width(p)*height(p) >= n "Cant flip $n values for a patch of size
      $(width(p)) x $(height(p))"
  flipped = []
  y = rand(1:height(p))
  x = rand(1:width(p))
  for i in 1:n
    # Find position to flip
    while (x,y) ∈ flipped
      y = rand(1:height(p))
      x = rand(1:width(p))
    end
    push!(flipped, (x,y))
    # Flip entry to a different one from the set of possible values
    rndoptions = setdiff(set(p), content(p)[y,x])
    length(rndoptions) < 1 && error("Nothing to choose from")
    content(p)[y,x] = rand(rndoptions)
  end
  return p
end

"""
flip(p::Patch, n::Integer)

Return a new patch where n entries are flipped
"""
function flip(p::Patch, n::Integer)
  res = deepcopy(p)
  return flip!(res, n)
end

"Compare two patches"
function ==(a::Patch, b::Patch)
  typeof(a) == typeof(b) || return false
  set(a) == set(b) || return false
  top(a) == top(b) || return false
  left(a) == left(b) || return false
  return content(a) == content(b)
end

"""
paste!(a::Matrix, b::Matrix, row, col)

Insert given smaller array into bigger array
"""
function paste!(a::AbstractArray{T,2}, b::AbstractArray{T,2},
                   row::Integer, col::Integer) where T
  a[row:row+size(b,1)-1,col:col+size(b,2)-1] = b
  return a
end

"""
grow(a::AbstractMatrix, scale::Integer)

Scales array using nearest neighbor by an integer factor
"""
function grow(a::AbstractMatrix, scale::Integer)
  @assert scale > 0 "You can not grow an array by an amount < 1: $scale"
  res = Matrix{eltype(a)}(undef, size(a,1)*scale, size(a,2)*scale)
  for r in 0:size(a,2) - 1
    for c in 0:size(a,1) - 1
      col = c*scale + 1
      row = r*scale + 1
      @inbounds res[col:col + scale - 1,row:row + scale - 1] .= a[c + 1,r + 1]
    end
  end
  return res
end

export grow
