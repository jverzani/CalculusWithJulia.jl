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
# for plotif. This identifies a vector of colors
function identify_colors(g, xs, colors=(:red, :blue, :black))
    F = (a,b) -> begin
        ga,gb=g(a),g(b)
        ga * gb < 0 && return nothing
        ga >= 0 && return true
        return false
    end
    find_colors(F, xs, colors)
end

# F(a,b) returns true, false, or nothing
function find_colors(F, xs, colors=(:red, :blue, :black))
    n = length(xs)
    cols = repeat([colors[1]], n)
    for i in 1:n-1
        a,b = xs[i], xs[i+1]
        val = F(a,b)
        if val == nothing
            cols[i] = colors[3]
        elseif val
            cols[i] = colors[1]
        else
            cols[i] = colors[2]
        end
    end
    cols[end] = cols[end-1]
    cols
end
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
