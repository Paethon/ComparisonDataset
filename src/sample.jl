struct Sample{T, I<:Integer}
  size::Size{I}
  patches::Vector{Patch{T,I}}
  background::T
  set::Set{T}
end

Sample(size::Size{I}, background::T, set::Set{T}) where {I<:Integer, T} =
  Sample(size, Vector{Patch{T,I}}(), background, set)

Sample(size::Size{I}, background::T, set::Vector{T}) where {I<:Integer, T} =
  Sample(size, Vector{Patch{T,I}}(), background, Set(set))

patches(s::Sample) = s.patches
Base.size(s::Sample) = (height(s.size), width(s.size))
Base.size(s::Sample, i::Integer) = i == 1 ? height(s.size) : width(s.size)

"Fill a sample with random patches"
function Base.rand(s::Sample{T,I}; patchsize::Size = Size(8), nbpatches::Integer = 5,
  nbsame::Integer = 3, diff::Integer = 1) where {T, I<:Integer}
  res = deepcopy(s)
  # Gather non-overlapping positions for patches
  patchpos = nonoverlappingrandrect(width(res.size), height(res.size),
                width(patchsize), height(patchsize), nbpatches)
  # Generate actual patches from the positions
  pos = pop!(patchpos)
  patch = rand(Patch, patchsize, s.set, top(pos), left(pos))
  push!(patches(res), patch)
  # Generate same patches
  for i in 1:nbsame-1
    pos = pop!(patchpos)
    newpatch = Patch(copy(content(patch)), set(patch), top(pos), left(pos))
    push!(patches(res), newpatch)
  end
  # Generate altered additional patches
  while(!isempty(patchpos))
    pos = pop!(patchpos)
    newpatch = Patch(copy(content(patch)), set(patch), top(pos), left(pos))
    flip!(newpatch, diff)
    push!(patches(res), newpatch)
  end
  return res
end

"Return an Array representing the sample"
function render(s::Sample)
  res = fill(s.background, (s.size.height, s.size.width))
  for p in s.patches
    paste!(res, p.content, p.top, p.left)
  end
  return res
end
