
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
rangeclamp(f, hi=20, lo=-hi; replacement=NaN) = x -> lo < f(x) < hi ? f(x) : replacement
