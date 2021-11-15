## Derivative related code

"""
    tangent(f::Function, c)

Returns a function describing the tangent line to the graph of `f` at `x=c`.

Example. Where does the tangent line intersect the y axis?
```
f(x) = sin(x)
tl(x) = tangent(f, pi/4)(x)  # or tl = tangent(f, pi/3) to use a non-generic function
tl(0)
```

Uses the automatic derivative of `f` to find the slope of the tangent line at `x=c`.

"""
tangent(f,c) = x -> f(c) + f'(c) * (x-c)

"""
    secant(f::Function, a, b)

Returns a function describing the secant line to the graph of `f` at `x=a` and `x=b`.

Example. Where does the secant line intersect the `y` axis?

```
f(x) = sin(x)
a, b = pi/4, pi/3
sl(x) = secant(f, a, b)(x)  # or sl = sl(f, a, b) to use a non-generic function
sl(0)
```


"""
secant(f, a, b) = x -> f(a) + (f(b) - f(a)) / (b-a) * (x - a)



"""
    D(f)

Function interface to `ForwardDiff.derivative`.

Also *overrides* `f'` to take take a derivative.
"""
function D(f, n::Int=1)
    n < 0 && throw(ArgumentError("n is a non-negative integer"))
    n == 0 && return f
    n == 1 && return t -> ForwardDiff.derivative(f, float(t))
    D(D(f), n-1)
end

## Create r' to mean the derivative for functions
## warning, this would be odd for [sin, cos]' as
## is it [sin', cos'] or the transpose...
Base.adjoint(r::Function) = D(r)

"""
   sign_chart(f, a, b; atol=1e-4)

Create a sign chart for `f` over `(a,b)`. Returns a tuple with an identified zero or vertical asymptote and the corresponding sign change. The tolerance is used to disambiguate numerically found values.

# Example

```
julia> sign_chart(x -> x/(x-1)^2, -5, 5)
2-element Vector{NamedTuple{(:∞0, :sign_change), Tuple{Float64, String}}}:
 (∞0 = 0.0, sign_change = "- → +")
 (∞0 = 1.0000000000000002, sign_change = "+ → +")
```

"""
function sign_chart(f, a, b; atol=1e-6)
    pm(x) = x < 0 ? "-" : x > 0 ? "+" : "0"
    summarize(f,cp,d) = (∞0=cp, sign_change=pm(f(cp-d)) * " → " * pm(f(cp+d)))

    zs = find_zeros(f, a, b)
    pts = vcat(a, zs, b)
    for (u,v) ∈ zip(pts[1:end-1], pts[2:end])
        zs′ = find_zeros(x -> 1/f(x), u, v)
        for z′ ∈ zs′
            flag = false
            for z ∈ zs
                if isapprox(z′, z, atol=atol)
                    flag = true
                    break
                end
            end
            !flag && push!(zs, z′)
        end
    end
    sort!(zs)

    length(zs) == 0 && return []
    m,M = extrema(zs)
    d = min((m-a)/2, (b-M)/2)
    if length(zs) > 0
        d′ = minimum(diff(zs))/2
        d = min(d, d′ )
    end
    summarize.(f, zs, d)
end
