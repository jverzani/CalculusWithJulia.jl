## Derivative related code

"""
    tangent(f::Function, c)

Returns a function describing the tangent line to the graph of f at x=c.

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
Returns a function describing the secant line to the graph of f at x=a and x=b.

Example. Where does the secant line intersect the y axis?
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
