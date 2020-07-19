struct Size{T}
  height::T
  width::T
end
Size(size::T) where T<:Int = Size(size, size)

width(s::Size) = s.width
height(s::Size) = s.height

"""
genpatch!(patch::AbstractArray, set::Vector)

Fill an array with random values selected from a given set
"""
function genpatch!(patch::AbstractArray, set::Vector)
  for i in 1:length(patch)
    @inbounds patch[i] = rand(set)
  end
  return patch
end
genpatch!(patch::AbstractArray) = genpatch!(patch, UInt8[0,255])

"Return an array of size n x n filled with random values
selected from a given set"
function genpatch(set::Vector, n::Integer)
  res = Matrix{eltype(set)}(undef, n,n)
  genpatch!(res, set)
end
"Return an array of size n x n filled with random values of 0/1"
genpatch(n::Integer) = genpatch(UInt8[0,255], n)

"""
Return an Array of given size, filled with a specified number of
randomly filled patches of a given size of which a certain amount are
identical
"""
function gensample(T::Type, size::Size, patchsize::Size,
                   nbpatches::Int, nbsame::Int)
  @assert nbpatches >= nbsame "Number of identical patches has to be <=
            number of total patches!"
  # Generate image
  # res = zeros(T, width(size), height(size))
  res = fill(convert(T, 128), (width(size), height(size)))
  # Gather non-overlapping positions for patches
  patchpos = nonoverlappingrandrect(width(size), height(size),
                width(patchsize), height(patchsize), nbpatches)
  # Fill in the identical patches
  patch = genpatch(width(patchsize))
  for i in 1:nbsame
    pos = pop!(patchpos)
    paste!(res, patch, left(pos), top(pos))
  end
  # Fill in non-identical patches
  while !isempty(patchpos)
    genpatch!(patch)
    pos = pop!(patchpos)
    paste!(res, patch, left(pos), top(pos))
  end
  return res
end

gensample(size::Size, patchsize::Size,
  nbpatches::Int, nbsame::Int) =
    gensample(UInt8, size, patchsize, nbpatches, nbsame)
