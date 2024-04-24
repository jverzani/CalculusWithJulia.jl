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
function lim(f::Function, c::Real; n::Int=6, m::Int=1, dir="+")
    dir = string(dir)
    Limit(f, c, n, m, dir)
end
lim(f::Function, c::Real, dir; n::Integer=5, m::Integer=1) = lim(f,c; n, m, dir=string(dir))


struct Limit{F,R}
    f::F
    c::R
    n::Int
    m::Int
    dir::String
end

# try to better align numbers
function Base.show(io::IO, L::Limit)
    (; f,c,n,m,dir) = L
    hs = [1/10^i for i in m:n] # close to 0
    if dir == "+"
	xs = c .+ hs
    else
	xs = c .- hs
    end
    ys = string.(map(f, xs))

    _l8(x) = length(string(x)) ÷ 8
    nt = 2 + _l8(first(xs)) + (n ÷ 8)
    nl = false
    last_y = nothing
    for (x,y) ∈ zip(xs, ys)
        nl && println(io, "")
        nl = true
        print(io, x)
        m = _l8(x)
        print(io, "\t"^(nt-m))
        if isnothing(last_y)
            print(io, y)
        else
            flag = true
            ly = length(last_y)
            for (i,yᵢ) ∈ enumerate(y)
                if flag && i <= ly && yᵢ == last_y[i]
                    printstyled(io, yᵢ; bold=true)
                else
                    print(io, yᵢ)
                    flag=false
                end
            end
        end
        last_y = y
    end
    nothing
end
