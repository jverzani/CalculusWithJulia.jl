## Derivative related code
struct TangentLine{F,R} <: Function
    f::F
    c::R
end

function Base.show(io::IO,  ::MIME"text/plain", T::TangentLine{F,R})  where {F, R}
    print(io, "Function of `x` to compute tangent line of `f` at `c`:\n",
          "\tf(c) + f'(c) * (x-c)")
end


(F::TangentLine)(x) = begin
    (; f,c ) = F
    f(c) + f'(c) * (x-c)
end


struct SecantLine{F,R,S} <: Function
    f::F
    a::R
    b::S
end

function Base.show(io::IO,  ::MIME"text/plain", T::SecantLine{F,R,S})  where {F, R,S}
    print(io, "Function of `x` to compute secant line of `f` between `a` and `b`:\n",
          "\tf(a) + ((f(b)-f(a)) / (b-a)  * (x-a)"
          )
end


(F::SecantLine)(x) = begin
    (; f, a, b ) = F
    m = (f(b) - f(a)) / (b - a)
    f(a) + m * (x-a)
end


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
tangent(f,c) = TangentLine(f,c)

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
secant(f, a, b) = SecantLine(f, a, b)



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

function _is_f_approx_0(f, x, atol, rtol)
    tol = min(abs(x)*rtol, atol)
    abs(f) ≤ tol
end

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
    pm(a,b) = begin
        fa,fb = f(a), f(b)
        fa < 0 && fb < 0 && return MM()
        fa < 0 && fb > 0 && return MP()
        fa > 0 && fb < 0 && return PM()
        fa > 0 && fb > 0 && return PP()
        ZZ
    end

    pm(x) = x < 0 ? "-" : x > 0 ? "+" : "0"
    summarize(f,cp,d) = (DNE_0_∞ = cp, sign_change = pm(cp-d, cp+d))

    if _is_f_approx_0(f(a),a, eps(), eps()) ||
        _is_f_approx_0(f(b), b, eps(), eps())
        return "Sorry, the endpoints must not be zeros for the function"
    end

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


    if isempty(zs)
	fc = f(a + (b-a)/2)
	return "No sign change, always " * (fc > 0 ? "positive" : iszero(fc) ? "zero" : "negative")
    end

    sort!(zs)
    m,M = extrema(zs)
    d = min((m-a)/2, (b-M)/2)
    if length(zs) > 1
        d′ = minimum(diff(zs))/2
        d = min(d, d′ )
    end
    summarize.(f, zs, d)
end

abstract type SignChange end
struct PM <: SignChange end
struct MP <: SignChange end
struct PP <: SignChange end
struct MM <: SignChange end
struct ZZ <: SignChange end
Base.show(io::IO, ::PM) = print(io, "+ → -")
Base.show(io::IO, ::MP) = print(io, "- → +")
Base.show(io::IO, ::PP) = print(io, "+ → +")
Base.show(io::IO, ::MM) = print(io, "- → -")
Base.show(io::IO, ::ZZ) = print(io, "a zero")
