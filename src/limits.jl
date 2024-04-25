"""
    lim(f, c; n=6, m=1, dir="+-")
    lim(f, c, dir; n-5)

Means to generate numeric table of values of `f` as `h` gets close to `c`.

* `n`, `m`: powers of `10` to add (subtract) to (from) `c`.
* `dir`: Either `"+-"` (show left and right), `"+"` (right limit), or `"-"` (left limit). Can also use functions `+`, `-`, `±`.

Example:

```
julia> f(x) = sin(x) / x
f (generic function with 1 method)

julia> lim(f, 0)
0.1             0.9983341664682815
0.01            0.9999833334166665
0.001           0.9999998333333416
0.0001          0.9999999983333334
1.0e-5          0.9999999999833332
1.0e-6          0.9999999999998334
    :               :
-1.0e-6         0.9999999999998334
-1.0e-5         0.9999999999833332
-0.0001         0.9999999983333334
-0.001          0.9999998333333416
-0.01           0.9999833334166665
-0.1            0.9983341664682815
```
"""
function lim(f::Function, c::Real; n::Int=6, m::Int=1, dir="+-")
    dir = string(dir)
    Limit(f, c, n, m, dir)
end
lim(f::Function, c::Real, dir; n::Int=6, m::Int=1) = lim(f,c; n, m, dir=string(dir))


struct Limit{F,R}
    f::F
    c::R
    n::Int
    m::Int
    dir::String
end

# try to better align numbers
_l8(x) = length(string(x)) ÷ 8

function Base.show(io::IO, L::Limit)
    (; f,c,n,m,dir) = L

    h = 1/10^n
    nt = 2 + maximum(_l8, (c-h, c+h)) + (n ÷ 8)

    if dir == "+" || dir == "+-" || dir == "±"
        show₊(io, L; nt)
    end

    if dir == "-" || dir == "--" || dir == "+-" || dir == "±"
        show₋(io, L; nt)
    end
    nothing
end

function show₊(io::IO, L::Limit; nt=4)

    (; f,c,n,m,dir) = L

    hs = [1/10^i for i in m:n] # close to 0
    xsᵣ = c .+ hs
    ysᵣ = string.(f.(xsᵣ))

    last_y = nothing

    for (x,y) ∈ zip(xsᵣ, ysᵣ)
        print_next(io, nt, x, y, last_y)
        last_y = y
        println(io, "")
    end

    println(io, "    :" * "\t"^nt * "    :")
end

# show - case
function show₋(io::IO, L::Limit; nt=4)
    (; f,c,n,m,dir) = L

    hs = [1/10^i for i in n:-1:m] # close to 0
    xsₗ = c .- hs
    ysₗ = string.(f.(xsₗ))

    last_y = nothing

    i, l = 1, length(ysₗ)
    nl = true
    dir == "-" && println(io, "    :" * "\t"^nt * "    :")
    for (x, y) ∈ zip(xsₗ, ysₗ)
        if i == l
            last_y = nothing
            nl = false
        else
            last_y = ysₗ[i+1]
            i += 1
        end
        print_next(io, nt, x, y, last_y)
        nl && println(io, "")
    end

end

# print next number referring to last one for styling
function print_next(io::IO, nt, x, y, last_y=nothing)
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
end
