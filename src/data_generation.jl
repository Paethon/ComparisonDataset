immutable Size{T}
  height::T
  width::T
end

width(s::Size) = s.width
height(s::Size) = s.height

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
  res = zeros(T, width(size), height(size))
  # Gather non-overlapping positions for patches
  patchpos = nonoverlappingrandrect(width(size), height(size),
                width(patchsize), height(patchsize), nbpatches)
  # Fill in the identical patches
  patch = genpatch(T, width(patchsize))
  for i in 1:nbsame
    pos = pop!(patchpos)
    paste!(res, patch, left(pos), top(pos))
  end
  while !isempty(patchpos)
    patch = genpatch(T, width(patchsize))
    pos = pop!(patchpos)
    paste!(res, patch, left(pos), top(pos))
  end
  return res
end

gensample(size::Size, patchsize::Size,
  nbpatches::Int, nbsame::Int) =
    gensample(Int8, size, patchsize, nbpatches, nbsame)
