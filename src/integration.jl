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
