## integration.jl


"""
    riemann(f, a, b, n; method="right"

Compute an approximations to the definite integral of `f` over `[a,b]` using an equal-sized partition of size `n+1`.

method: `"right"` (default), `"left"`, `"trapezoid"`, `"simpsons"`, `"ct"`, `"m̃"` (minimum over interval), `"M̃"` (maximum over interval)

Example:
```
f(x) = exp(x^2)
riemann(f, 0, 1, 1000)   # default right-Riemann sums
riemann(f, 0, 1, 1000; method="left")       # left sums
riemann(f, 0, 1, 1000; method="trapezoid")  # use trapezoid rule
riemann(f, 0, 1, 1000; method="simpsons")   # use Simpson's rule
```

"""
function riemann(f::Function, a::Real, b::Real, n::Int; method="right")
    Ms = (left = (f,a,b) -> f(a),
      right= (f,a,b) -> f(b),
      mid  = (f,a,b) -> f(a/2 + b/2),
      m̃    = (f,a,b) -> first(findmin(f, range(a,b,10))),
      M̃    = (f,a,b) -> first(findmax(f, range(a,b,10))),
      trapezoid = (f,a,b) -> (f(a) + f(b))/2,
      simpsons  = (f,a,b) -> (c = a/2 + b/2;(1/6) * (f(a) + 4*f(c) + f(b))),
      ct = (f,a,b)-> (c = a/2+b/2; (f(a)+f(b))/2 + 1/12 * (f'(b)-f'(a))*(b-a))
      )

    F = Ms[Symbol(method)]
    xs = range(a, b, n+1)
    xs′ = zip(Iterators.take(xs, n), Iterators.drop(xs, 1))
    sum(F(f, xᵢ₋₁, xᵢ) * (xᵢ-xᵢ₋₁) for (xᵢ₋₁, xᵢ) ∈ xs′)
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


!!! Note
    This uses nested calls to `quadgk`. The use of `hcubature` is recommended, typically after a change of variables to make a rectangular domain. The relative tolerance increases at each nested level.
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
