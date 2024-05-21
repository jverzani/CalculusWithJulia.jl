"""
    fisheye(f)

Transform `f` defined on `(-∞, ∞)` to a new function whose domain is in `(-π/2, π/2)` and range is within `(-π/2, π/2)`. Useful for finding all zeros over the real line. For example

```
f(x) = 1 + 100x^2 - x^3
fzeros(f, -100, 100) # empty just misses the zero found with:
fzeros(fisheye(f), -pi/2, pi/2) .|> tan  # finds 100.19469143521222, not perfect but easy to get
```

By Gunter Fuchs.
"""
fisheye(f) = atan ∘ f ∘ tan

## ---
# some plotting utilities
"""
    rangeclamp(f, hi=20, lo=-hi; replacement=NaN)

Modify `f` so that values of `f(x)` outside of `[lo,hi]` are replaced by `replacement`.

Examples
```
f(x) = 1/x
plot(rangeclamp(f), -1, 1)
plot(rangeclamp(f, 10), -1, 1) # no `abs(y)` values exceeding 10
```
"""
rangeclamp(f, hi::Real=20, lo::Real=-hi; replacement=NaN) = x -> lo < f(x) < hi ? f(x) : replacement

function rangeclamp(f, xs; replacement=NaN)
    a,b = extrema(xs)
    rangeclamp(f, b, a; replacement)
end
