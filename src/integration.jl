## integration.jl


"""
riemann: compute Riemann sum approximations to a definite integral. As well, implement trapezoid and Simpson's rule.

Example:
```
f(x) = exp(x^2)
riemann(f, 0, 1, 1000)   # default right-Riemann sums
riemann(f, 0, 1, 1000, method="left")       # left sums
riemann(f, 0, 1, 1000, method="trapezoid")  # use trapezoid rule
riemann(f, 0, 1, 1000, method="simpsons")   # use Simpson's rule
```

"""
function riemann(f::Function, a::Real, b::Real, n::Int; method="right")
    if method == "right"
        meth = f -> (lr -> begin l,r = lr; f(r) * (r-l) end)
    elseif method == "left"
        meth = f -> (lr -> begin l,r = lr; f(l) * (r-l) end)
    elseif method == "trapezoid"
        meth = f -> (lr -> begin l,r = lr; (1/2) * (f(l) + f(r)) * (r-l) end)
    elseif method == "simpsons"
        meth = f -> (lr -> begin l,r=lr; (1/6) * (f(l) + 4*(f((l+r)/2)) + f(r)) * (r-l) end)
    end

    xs = a .+ (0:n) * (b-a)/n

    sum(meth(f), zip(xs[1:end-1], xs[2:end]))
end

#######
## simplified multivariable integrals

# limits of integration
endpoints(ys,x) = ((f,x) -> isa(f, Function) ? f(x...) : f).(ys, Ref(x))
# avoid specialization in quadgk
struct FWrapper
    f
end
(F::FWrapper)(x) = F.f(x)

"""
fubini(f, dy, dx)
fubini(f, dz, dy, dx)

Computes numeric integral of `f` over region specified by `dz`, `dy`, `dx`. These are a tuple of values of numbers or univariate functions depending on the value of the term on the right (`dy` can depend on `dx`s value).


*Much* slower than `hcubature` from the `HCubature` package, as it refines flat areas too many times, allocates too much, etc. But does allow a more flexible specification of the region to integrate over, as `hcubature` requires box-like regions.

```
f(x,y,z) = x * y^2 * z^3
fubini(f, (0,1), (0,2), (0,3))  # int_0^3 int_0^2 int_0^1 f(x,y,z) dz dy dx
g(v) = f(v...)
hcubature(g, (0,0,0), (3,2,1))  # same. Not order switched

# triangular like region
fubini(f, (0, y->y), (0, x->x), (0,3))
```
"""
fubini(f, dx)     = quadgk(FWrapper(f), dx...)[1]
fubini(f, ys, xs) = fubini(x -> fubini(y -> f(x,y), endpoints(ys, x)), xs)
fubini(f, zs, ys, xs) = fubini(x ->
    fubini(y ->
        fubini(z -> f(x,y,z),
            endpoints(zs, (x,y))),
        endpoints(ys,x)),
    xs)
