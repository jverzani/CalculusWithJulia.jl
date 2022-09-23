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
