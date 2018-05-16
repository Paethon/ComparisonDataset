"""
Type encoding a rectangular region
"""
struct Rect{T}
  top::T
  left::T
  bottom::T
  right::T

  # Constructor ensures that top is above bottom etc.
  function Rect{T}(t::T, l::T, b::T, r::T) where T
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
isoverlapping(a::Rect, b::Rect)

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
randrect(maxx::Integer, maxy::Integer, width::Integer, height::Integer)

Return a random rectangle given size and max coordinates
"""
function randrect(maxx::Integer, maxy::Integer,
                  width::Integer, height::Integer)
  top = rand(1:(maxy-height))
  left = rand(1:(maxx-width))
  return Rect(top, left, top + height, left + width)
end

"""
Error that is thrown when the search for non-overlapping patches reaches
an upper limit of tries
"""
immutable ExhaustionError{T}
  message::T
end

"""
nonoverlappingrandrect(maxx, maxy, width, height, amount; maxtries = 100)

Return a Vector of rectangles that are all non-overlapping, given size and
max coordinates.

maxtries defines how many times we want to try to find a non-overlapping
  orientation. After this we get an ExhaustionError
"""
function nonoverlappingrandrect(maxx::Integer, maxy::Integer,
                                width::Integer, height::Integer,
                                amount::Integer; maxtries = 100)
  rects = Vector{Rect}()
  for i in 1:amount
    for tries in 1:maxtries
      newrect = randrect(maxx, maxy, width, height)

      if !any(x -> isoverlapping(newrect, x), rects)
        push!(rects, newrect)
        break
      end

      tries == maxtries && throw(ExhaustionError("$max_tries was not enough"))
    end
  end
  return rects
end
