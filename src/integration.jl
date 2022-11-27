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


    xs = range(a, b, n+1)
    pairs = zip(xs[begin:end-1], xs[begin+1:end]) # (x₀,x₁), …, (xₙ₋₁,xₙ)
    sum(meth(f), pairs)

end


"""
    fubini(f, [zs], [ys], xs; rtol=missing, kws...)

Integrate `f` of 1, 2, or 3 input variables.

The zs may depend (x,y), the ys may depend on x

## Examples
```
# integrate over the unit square
fubini((x,y) -> sin(x-y), (0,1), (0,1))

# integrate over a triangle
fubini((x,y) -> 1, (0,identity), (0,1 ))

#
f(x,y,z) = x*y^2*z^3
fubini(f, (0,(x,y) ->  x+ y), (0, x -> x), (0,1))
```

Note: This code relies on `quadgk` which isn't loaded in this package. It won't run unless defined elsewhere, say by copy-and-paste.

Note: This uses nested calls to `quadgk`. The use of `hcubature` is recommended, typically after a change of variables to make a rectangular domain. The relative tolerance increases at each nested level.
"""
fubini(@nospecialize(f), dx; rtol=missing, kws...) =
    quadgk(f, dx...; rtol=first(skipmissing((rtol, nothing))), kws...)[1]

fubini(@nospecialize(f), ys, xs; rtol=missing, kws...) =
    fubini(x -> fubini(y -> f(x,y), endpoints(ys, x); rtol=rtol), xs;
           rtol = 10*rtol, kws...)

fubini(@nospecialize(f), zs, ys, xs; rtol=missing, kws...) =
    fubini(x ->
           fubini(y ->
                  fubini(z -> f(x,y,z), endpoints(zs, (x,y));
                         rtol=10*10*rtol, kws...),
                  endpoints(ys,x);
                  rtol = 10*rtol),

           xs;
           rtol=rtol)

endpoints(ys,x) = ((f,x) -> isa(f, Function) ? f(x...) : f).(ys, Ref(x))
