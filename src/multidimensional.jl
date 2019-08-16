# helpful bits for working with n \geq 2

"""
   uvec(x)

Helper to find a unit vector.
"""
function uvec(x)
    nm = norm(x)
    nm == 0 && return x
    return x/nm
end

"""
    `unzip(vs)`
    `unzip(v1, v2, ...)`
    `unzip(r::Function, a, b)`

Take a vector of points described by vectors (as returned by, say
`r(t)=[sin(t),cos(t)], r.([1,2,3])`, and return a tuple of collected x
values, y values, and optionally z values.

If the argument is specified as a comma separated collection of vectors, then these are combined and passed along.

If the argument is a function and two end point, then the function is
evaluated at 100 points between `a` and `b`.

This is useful for plotting when the data is more conveniently
represented in terms of vectors, but the plotting interface requires the x and y values collected.

Examples:
```
using Plots
r(t) = [sin(t), cos(t)]
rp(t) = [cos(t), -sin(t)]
plot(unzip(r, 0, 2pi)...)  # calls plot(xs, ys)

t0, t1 = pi/6, pi/4

p, v = r(t0), rp(t0)
plot!(unzip(p, p+v)...)  # connect p to p+v with line

p, v = r(t1), rp(t1)
quiver!(unzip([p])..., quiver=unzip([v]))
```

Based on `unzip` from the `Plots` package.
"""
unzip(vs::Vector) = Tuple([[vs[i][j] for i in eachindex(vs)] for j in eachindex(vs[1])])
function unzip(ws::Array; recursive=false)
    if recursive
        unzip([unzip(ws[:,j]) for j in 1:size(ws)[end]])
    else
        Tuple(eltype(first(ws))[xyz[j] for xyz in ws] for j in eachindex(first(ws)))
    end
end
#unzip(vs) = (A=hcat(vs...); Tuple([A[i,:] for i in eachindex(vs[1])]))
unzip(v,vs...) = unzip([v, vs...])
unzip(r::Function, a, b, n=100) = unzip(r.(range(a, stop=b, length=n)))


## -----------------------------------


## The gradient in SymPy.
## We avoid name collision with  ForwardDiff.gradient we use `grad`
import ForwardDiff: gradient
gradient(ex::SymPy.Sym, vars::AbstractArray=free_symbols(ex)) = diff.(ex, [vars...])
gradient(f::Function) = (x, xs...) -> ForwardDiff.gradient(f, vcat(x, xs...))


"""
    curl(F)

Find curl of a 2 or 3-D vector field.
"""
function curl(J::Matrix)
    if size(J) == (2,2)
        Mx, Nx, My, Ny = J
        return Nx - My # a scalar
    elseif size(J) == (3,3)
        Mx, Nx, Px, My, Ny, Py, Mz, Nz, Pz = J
        return [Py-Nz, Mz-Px, Nx-My] # ∇×VF
    else
        throw(ArgumentError("Wrong size jacobian matrix for a curl"))
    end
end
curl(F::Vector{Sym}, vars=free_symbols(F)) = curl(F.jacobian(vars))
curl(F::Tuple) = curl(F[1], F[2])
curl(F::Function, pt) = curl(ForwardDiff.jacobian(F, float.(pt)))
curl(F::Function) = (pt, pts...) -> curl(F, vcat(pt, pts...))

"""
    divergence(F)

Find divergence of a 3-D vector vield.
"""
divergence(F::Vector{Sym}, vars=free_symbols(F)) = sum(diff.(F, vars))
divergence(F::Tuple) = divergence(F[1], F[2])
divergence(F::Function, pt) = sum(diag(ForwardDiff.jacobian(F, float.(pt))))
divergence(F::Function) = (pt, pts...) -> divergence(F, vcat(pt, pts...))

## Is this a bad idea?
## syntax is a bit heavy with parentheses

struct DelOperator end
const ∇ = DelOperator()

## For symbolic objects, these use `free_symbols(ex)` to find variables
## this *may* not be right if sorting isn't as desired, or variables don't
## appear in the formula
(::DelOperator)(f) = return gradient(f)
(::DelOperator)(f::Tuple) = gradient(f[1],f[2])
LinearAlgebra.dot(::DelOperator, F) = divergence(F)
LinearAlgebra.dot(::DelOperator, F, vars) = divergence(F, vars)

LinearAlgebra.cross(::DelOperator, F) = curl(F)
LinearAlgebra.cross(::DelOperator, F, vars) = curl(F, vars)


##
