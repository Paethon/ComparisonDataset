"""
Type encoding a rectangular region
"""
immutable Rect{T}
  top::T
  left::T
  bottom::T
  right::T

  # Constructor ensures that top is above bottom etc.
  function Rect(t::T, l::T, b::T, r::T)
    top = t > b ? b : t
    bottom = t > b ? t : b
    left = l > r ? r : l
    right = l > r ? l : r
    new(top, left, bottom, right)
  end
end
Rect{T}(t::T, l::T, b::T, r::T) = Rect{T}(t, l, b, r)

top(r::Rect) = r.top
left(r::Rect) = r.left
bottom(r::Rect) = r.bottom
right(r::Rect) = r.right
width(r::Rect) = r.right - r.left
height(r::Rect) = r.bottom - r.top

"""
Return true if two rectangles are overlapping.
Warning: If one shape completely contains the other one this will not work!
"""
function isoverlapping(a::Rect, b::Rect)
  return !(right(a) < left(b) ||
           right(b) < left(a) ||
           bottom(a)< top(b) ||
           bottom(b)< top(a))
end

"""
Return a random rectangle given size and max coordinates
"""
function randrect(maxx::Integer, maxy::Integer,
                  width::Integer, height::Integer)
  top = rand(1:(maxy-height))
  left = rand(1:(maxx-width))
  return Rect(top, left, top + height, left + width)
end

"""
Error that is thrown when searching for non-overlapping patches reaches
an upper limit of tries
"""
immutable ExhaustionError{T}
  message::T
end

"""
Return a Vector of rectangles that are all non-overlapping, given size and
max coordinates
"""
function nonoverlappingrandrect(maxx::Integer, maxy::Integer,
                                width::Integer, height::Integer,
                                amount::Integer)
  rects = Vector{Rect}()
  const max_tries = 100 # How many tries until we give up?
  for i in 1:amount
    for tries in 1:max_tries
      newrect = randrect(maxx, maxy, width, height)

      if !any(x -> isoverlapping(newrect, x), rects)
        push!(rects, newrect)
        break
      end

      tries == max_tries && throw(ExhaustionError("$max_tries was not enough"))
    end
  end
  return rects
end
