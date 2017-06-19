module ComparisonDataset

using Images
import Base.rand

include("rect.jl")

export genpatch, paste!

"Return an array of size n x n filled with random true/false values"
genpatch(n::Integer) = [rand(Bool) for y in 1:n, x in 1:n]

"Insert given smaller array into bigger array"
function paste!{T}(a::AbstractArray{T,2}, b::AbstractArray{T,2},
                   col::Integer, row::Integer)
  a[col:col+size(b,1)-1,row:row+size(b,2)-1] = b
end

end # module
