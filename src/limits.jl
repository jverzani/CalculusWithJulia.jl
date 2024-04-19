"""
    lim(f, c; n=5, dir="+")
    lim(f, c, dir; n-5)

Means to generate numeric table of values of `f` as `h` gets close to `c`.

Example:
```
f(x) = sin(x) / x
lim(f, 0)
```
"""
function lim(f::Function, c::Real; n::Int=5, dir="+")
    dir = ( (dir == +) ? "+" : ( (dir == -) ? "-" : dir == "-" ? "-" : "+"))
    Limit(f, c, n, dir)
end
lim(f::Function, c::Real, dir; n::Int=5) = lim(f,c;n, dir)

struct Limit{F,R}
    f::F
    c::R
    n::Int
    dir::String
end

function Base.show(io::IO, L::Limit)
    (; f,c,n,dir) = L

    hs = [(1/10)^i for i in 1:n] # close to 0
    if dir == "+"
	xs = c .+ hs
    else
	xs = c .- hs
    end
    ys = map(f, xs)
    show(io, "text/plain", [xs ys])
end
