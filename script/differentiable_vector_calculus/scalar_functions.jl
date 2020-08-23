
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia
using Plots


f(x,y) = x^2 + y^2
g(x,y) = x * y
h(x,y) = sin(x) * sin(y)


f(1,2), g(2, 3), h(3,4)


v = [1,2]
f(v...)


f(v) = v[1]^2 + v[2]^2


function g(v)
    x, y = v
    x * y
end


f(v), g([2,3])


f(x,y) = x^2 - 2x*y^2


f(v) = f(v...)


f([1,2])


f(1,2)


f(x, y) = x^2 + y^2

xs = range(-2, 2, length=100)
ys = range(-2, 2, length=100)

surface(xs, ys, f)


note("""Using `surface` as a function name is equivalent to `plot(xs, ys, f, seriestype=:surface)`.""")


zs = [f(x,y) for y in ys, x in xs]
surface(xs, ys, zs)


surface(xs, ys, f.(xs', ys))


wireframe(xs, ys, f)   # gr() or pyplot() wireplots render better than plotly()


f(x,y) = x^2 - y^2
xs = ys = range(-2, 2, length=100)
surface(xs, ys, f)


gr()
xs = [-1,1];ys = [-1,1]
f(x,y) = x*y
surface(xs, ys, f.(xs', ys))


xs = ys = range(-1, 1, length=100)
surface(xs, ys, f.(xs', ys))


n,m = 25,50
xs = range(-74.3129825592041, -74.2722129821777, length=n)
ys = range(40.7261855236006, 40.7869834960339, length=m)
d = DataFrame(xs =reshape([m[1] for m in [(xi,yi) for xi in xs, yi in ys]], (n*m),),
       ys = reshape([m[2] for m in [(xi,yi) for xi in xs, yi in ys]], (n*m,)))
# In RCall
using RCall
z = R"""
library(elevatr)
z = get_elev_point($d, prj="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
z = data.frame(z)
"""
elev = rcopy(DataFrame, z).elevation
zs = reshape(elev, m, n)
D = Dict(:xs => xs, :ys=>ys, :zs => elev)
io = open("data/somocon.json", "w")
JSON.print(io, D)
close(io)


using JSON
SC = JSON.parsefile("data/somocon.json")  # a local file
xs, ys, zs =  [float.(SC[i]) for i in ("xs", "ys","zs")]
gr()  # use GR backend
surface(xs, ys, zs)


surface(xs, ys, zs, camera=(0, 90))


contour(xs, ys, zs)


contour(xs, ys, zs, levels=[50,75,100, 125, 150, 175])


contour(xs, ys, zs, nlevels = 5)


plotly()
f(x, y) = sin(x) - cos(y)
xs = range(0, 2pi, length=100)
ys = range(-pi, pi, length = 100)
contour(xs, ys, f)


import Contour: contours, levels, level, lines, coordinates

function surface_contour(xs, ys, f; offset=0)
  p = surface(xs, ys, f, legend=false, fillalpha=0.5)

  ## we add to the graphic p, then plot
  zs = [f(x,y) for x in xs, y in ys]  # reverse order for use with Contour package
  for cl in levels(contours(xs, ys, zs))
    lvl = level(cl) # the z-value of this contour level
    for line in lines(cl)
        _xs, _ys = coordinates(line) # coordinates of this line segment
        _zs = offset * _xs
        plot!(p, _xs, _ys, _zs, alpha=0.5)        # add curve on x-y plane
    end
  end
  p
end

xs = ys = range(-pi, stop=pi, length=100)
f(x,y) = 2 + sin(x) - cos(y)

surface_contour(xs, ys, f)


imgfile = "figures/daily-map.jpg"
caption = """
Image from [weather.gov](https://www.weather.gov/unr/1943-01-22) of a contour map showing atmospheric pressures from January 22, 1943 in Rapid City, South Dakota.
"""
ImageFile(imgfile, caption)


imgfile = "figures/australia.png"
caption = """
Image from [IRI](https://iridl.ldeo.columbia.edu/maproom/Global/Ocean_Temp/Monthly_Temp.html) shows mean sea surface temperature near Australia in January 1982. IRI has zoomable graphs for this measurement from 1981 to the present. The contour lines are in 2 degree Celsius increments.
"""
ImageFile(imgfile, caption)


f(x,y) = exp(-(x^2 + y^2)/5) * sin(x) * cos(y)
xs= ys = range(-pi, pi, length=100)
heatmap(xs, ys, f)


f(x,y) = exp(-(x^2 + y^2)/5) * sin(x) * cos(y)
xs= ys = range(-pi, pi, length=100)
contourf(xs, ys, f)


f(x,y) = 2 - x^2 - 3y^2
f(x) = f(x...)
γ(t) = 2*[t, -t^2]   # use \gamma[tab]
xs = ys = range(-1, 1, length=100)
surface(xs, ys, f)
r3(t) = [γ(t)..., f(γ(t))]  # to plot the path on the surface
plot_parametric_curve!(r3, 0, 1/2, linewidth=5, color=:black)

r2(t) = [γ(t)..., 0]
plot_parametric_curve!(r2, 0, 1/2, linewidth=5, color=:black) # in the $x$-$y$ plane


plot(f ∘ γ, 0, 1/2)


f(x,y) = x^2 - 2x*y
f(v) = f(v...)       # to handle vectors. Need not be defined each time


using ForwardDiff
pt = [1, 2]
ForwardDiff.gradient(f, pt)      # uses the f(v) call above


FowardDiff.gradient(f::Function) = x -> ForwardDiff.gradient(f, x)


gradient(f)([1,2]), gradient(f)([3,4])


ForwardDiff.gradient(f::Function) = (x, xs...) -> ForwardDiff.gradient(f, vcat(x, xs...))


gradient(f)([1,2]), gradient(f)(3,4)


partial_x(f, y) = x -> ForwardDiff.gradient(f,[x,y])[1]   # first component of gradient


partial_x(f, y) = x -> ForwardDiff.derivative(u -> f(u,y), x)


note("""
For vector-valued functions, we can overide the syntax `'` using `Base.adjoint`, as `'` is treated as a postfix operator in `Julia` for the `adjoint` operation. The symbol `\\nabla` is also available in `Julia`, but it is not an operator, so can't be used as mathematically written `∇f` (this could be used as a name though). In `CalculusWithJulia` a definition is made so essentially `∇(f) = x -> ForwardDiff.gradient(f, x)`. It does require parentheses to be called, as in `∇(f)`.
""")


using SymPy
@vars x y
ex = x^2 - 2x*y
diff(ex, x)


diff(ex,x)(x=>1, y=>2)


diff(ex, y)(x=>1, y=>2)


[diff(ex, x), diff(ex, y)]


grad_ex = diff.(ex, [x,y])


subs.(grad_ex, x.=>1, y.=>2)


gradient(ex, [x, y])   # [∂f/∂x, ∂f/∂y]


∇((ex, [x,y]))


function vectorfieldplot!(V; xlim=(-5,5), ylim=(-5,5), nx=10, ny=10, kwargs...)

    dx, dy = (xlim[2]-xlim[1])/nx, (ylim[2]-ylim[1])/ny
    xs, ys = xlim[1]:dx:xlim[2], ylim[1]:dy:ylim[2]

    ps = [[x,y] for x in xs for y in ys]
    vs = V.(ps)
	λ = 0.9 * minimum([u/maximum(getindex.(vs,i)) for (i,u) in enumerate((dx,dy))])

    quiver!(unzip(ps)..., quiver=unzip(λ * vs))

end


gr()  # better arrows

f(x,y) = 2 - x^2 - 3y^2
f(v) = f(v...)

xs = ys = range(-2,2, length=50)

p = contour(xs, ys, f, nlevels=12)
vectorfieldplot!(p, gradient(f), xlim=(-2,2), ylim=(-2,2), nx=10, ny=10)

p


plotly()

f(x,y) = 2 - x^2 - y^2
f(x) = f(x...)

γ(t) = t*[cos(t), -sin(t)]

xs = ys = range(-3/2, 3/2, length=100)
surface(xs, ys, f, legend=false)

r(t) = [γ(t)..., (f∘γ)(t)]
plot_parametric_curve!(r, 0, pi/2, linewidth=5, color=:black)

t0 = pi/6
arrow!(r(t0), r'(t0), linewidth=5, color=:black)


plot(f∘γ, 0, pi/2)
plot!(t -> (f∘γ)(t0) + (f∘γ)'(t0)*(t - t0), 0, pi/2)


ForwardDiff.gradient(f, γ(t0)) ⋅ γ'(t0)


(f∘γ)'(t0)


using JSON, CSV, DataFrames
SC = JSON.parsefile("data/somocon.json")  # a local file
lenape = CSV.File("data/lenape.csv") |> DataFrame

xs, ys, zs =  [float.(SC[i]) for i in ("xs", "ys","zs")]

gr()
surface(xs, ys, zs, legend=false)
plot!(lenape.longitude, lenape.latitude, lenape.elevation, linewidth=5, color=:black)


xs, ys, zs = lenape.longitude, lenape.latitude, lenape.elevation
dzs = zs[2:end] - zs[1:end-1]
dxs, dys = xs[2:end] - xs[1:end-1], ys[2:end] - ys[1:end-1]
deltas = sqrt.(dxs.^2 + dys.^2) * 69 / 1.6 * 1000 # in meters now
slopes = abs.(dzs ./ deltas)
m = maximum(slopes)
atand(maximum(slopes))   # in degrees due to the `d`


import Statistics: mean
atand(mean(slopes))


f(x,y) = 2 - x^2 - y^2
f(x) = f(x...)
γ(t) = t*[cos(t), -sin(t)]
xs = ys = range(-3/2, 3/2, length=100)

plotly()
surface(xs, ys, f, legend=false)
r(t) = [γ(t)..., (f∘γ)(t)]
plot_parametric_curve!(r, 0, pi/2, linewidth=5, color=:black)


using QuadGK

plot(f∘γ, 0, pi/2)
slope(t) = abs((f∘γ)'(t))

1/(pi/2 - 0) * quadgk(t -> atand(slope(t)), 0, pi/2)[1]  # the average


using Roots
cps = fzeros(slope, 0, pi/2) # critical points

append!(cps, (0, pi/2))  # add end points
unique!(cps)

M, i = findmax(slope.(cps))  # max, index

cps[i], slope(cps[i])


f(x,y) = 2 - x^2 - y^2

xs = ys = range(-3/2, 3/2, length=100)
surface(xs, ys, f, legend=false)
M=f(3/2,3/2)

x0,y0 = 1/2, -1/2
plot!([-3/2, 3/2, 3/2, -3/2, -3/2], y0 .+ [0,0,0,0, 0], [M,M,2,2,M], linestyle=:dash)
r(x) = [x, y0, f(x,y0)]
plot_parametric_curve!(r, -3/2, 3/2, linewidth=5, color=:black)


plot!(x0 .+ [0,0,0,0, 0], [-3/2, 3/2, 3/2, -3/2, -3/2], [M,M,2,2,M], linestyle=:dash)
r(y) = [x0, y, f(x0, y)]
plot_parametric_curve!(r, -3/2, 3/2, linewidth=5, color=:black)


scatter!([x0],[y0],[M])
arrow!([x0,y0,M], [1,0,0], linewidth=3)
arrow!([x0,y0,M], [0, 1,0], linewidth=3)


f(x,y) = 2 - x^2 - y^2
f(x) = f(x...)
xs = ys = range(-3/2, 3/2, length=100)
p = surface(xs, ys, f, legend=false)
M=f(3/2,3/2)

x0,y0 = 1/2, -1/2
vx, vy = 1, 1
l1(t) = [x0, y0] .+ t*[vx, vy]
llx, lly = l1(-1)
rrx, rry = l1(1)
plot!([llx, rrx, rrx, llx, llx], [lly, rry, rry, lly, lly], [M,M, 2, 2, M], linestyle=:dash)

r(t) = [l1(t)..., f(l1(t))]
plot_parametric_curve!(r, -1, 1, linewidth=5, color=:black)
arrow!(r(0), r'(0), linewidth=5, color=:black)


scatter!([x0],[y0],[M])
arrow!([x0,y0,M], [vx, vy,0], linewidth=3)


f(x,y) = 2 - x^2 - y^2
gamma(t) = (pi-t) * [cos(t), sin(t)]
dd(t) = gradient(f)(gamma(t))  ⋅ gamma'(t)

using Roots
cps = fzeros(dd, 0, pi)
unique!(append!(cps, (0, pi)))  # add endpoints
M,i = findmax(dd.(cps))
M


f(x,y) = sqrt(x^2 + y^2)
f(v) = f(v...)

xs = ys = range(-2, 2, length=100)
p = surface(xs, ys, f, legend=false)

γ(t) = [cos(t), sin(t), f(cos(t), sin(t))]
plot_parametric_curve!(γ, 0, 2pi, linewidth=2)

t =7pi/4;
scatter!(p, unzip([γ(t)])...)


rad(t) = 1 * [cos(t), sin(t)]
γ(t) = [rad(t)..., 0]
plot_parametric_curve!(γ, 0, 2pi, linestyle=:dash)



arrow!(γ(t), γ'(t))
arrow!(γ(t), [ForwardDiff.gradient(f, rad(t))..., 0])


@vars x y
f(x, y) = exp(x) * cos(y)
ex = f(x,y)
diff(ex, x, x), diff(ex, x, y), diff(ex, y, x), diff(ex, y, y)


hessian(ex, (x, y))


f(x,y) = exp(x) * cos(y)
f(v) = f(v...)
pt = [1, 2]

ForwardDiff.hessian(f, pt)  # symmetric


f(x,y) = x * exp(-(x^2 + y^2))
xs = ys = range(-2, stop=2, length=50)
surface(xs, ys, f)


choices = ["positive", "negative"]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
L"The line $x=0$",
L"The line $y=0$"
]
ans = 1
radioq(choices, ans, keep_order=true)


contour(xs, ys, f)


val = 0.4
numericq(val, 1/3)


choices = [
L"is around $(-0.7, 0)$ and with a value less than $-0.4$",
L"is around $(0.7, 0)$ and with a value less than $-0.4$",
L"is around $(-2.0, 0)$ and with a value less than $-0.4$",
L"is around $(2.0, 0)$ and with a value less than $-0.4$"
]
ans = 1
radioq(choices, ans)


choices = [
L"near $(1/4, 0)$",
L"near $(1/2, 0)$",
L"near $(3/4, 0)$",
L"near $(1, 0)$"
]
ans = 1
radioq(choices, ans, keep_order=true)


f(x,y)= sin(x)*cos(x*y)
xs = ys = range(-3, stop=3, length=50)
contour(xs, ys, f)


choices = [
L"Yes, the closed loops near $(-1.5, 0)$ and $(1.5, 0)$ will contain these",
L"No, the vertical lines parallel to $x=0$ show this function to be flat"
]
ans = 1
radioq(choices, ans)


yesnoq(false)


yesnoq(true)


ImageFile("figures/stelvio-pass.png", "Stelvio Pass")


choices = [
"running essentially parallel to the contour lines",
"running essentially perpendicular to the contour lines"
]
ans = 1
radioq(choices, ans)


choices = [
"By being essentially parallel, the steepness of the roadway can be kept to a passable level",
"By being essentially perpendicular, the road can more quickly climb up the mountain"
]
ans = 1
radioq(choices, ans)


choices = [
"A saddle-like shape, called a *col* or *gap*",
"A upside down bowl-like shape like the top of a mountain"
]
ans = 1
radioq(choices, ans)


choices = [
L"When $i(\vec{x}) = 0$",
L"When any of $f(\vec{x})$, $g(\vec{x})$, or $i(\vec{x})$ are zero",
L"The limit exists everywhere, as the function $f$, $g$, $h$, and $i$ have limits at $\vec{c}$ by assumption"
]
ans = 1
radioq(choices, ans)


numericq(1)


numericq(-1)


yesnoq(true)


choices = [
L"\langle \cos(x)\cos(2y), 2\cos(2x)\cos(y)\rangle",
L"\langle \cos(2y), \cos(y) \rangle",
L"\langle \sin(x), \sin(2x) \rangle",
L"\sin(x)\cos(2y)"
]
ans = 1
radioq(choices, ans)


choices = [
L"\langle -2\sin(x)\sin(2y), -\sin(2x)\sin(y)  \rangle",
L"\langle 2\sin(x), \sin(2x)  \rangle",
L"\langle  -2\sin(2y), -\sin(y) \rangle",
L"- \sin(2x)\sin(y)"
]
ans = 1
radioq(choices, ans)


f(x,y) = x^(y*sin(x*y))
pt  = [1/2, 1/2]
fx, fy = ForwardDiff.gradient(f, pt)
numericq(fx)


numericq(fy)


choices = ["two dimensional", "three dimensional"]
ans = 1
radioq(choices, ans, keep_order=true)


choices = ["two dimensional", "three dimensional"]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
L"\langle f_x, f_y, -1 \rangle",
L"\langle -f_x, -f_y, 1 \rangle",
L"\langle f_x, f_y \rangle"
]
ans = 1
radioq(choices, ans)


imgfile = "figures/everest.png"
caption = "Climbers en route to the summit of Mt. Everest"
ImageFile(imgfile, caption)


choices = [
L"f(x,y)",
L"(f\circ\vec\gamma)(x,y)",
L"\vec\gamma(x,y)"
]
ans = 1
radioq(choices, ans)


choices = [
L"(f\circ\vec\gamma)(t)",
L"\vec\gamma(t)",
L"f(t)"
]
ans = 1
radioq(choices, ans)


choices = [
"The three dimensional position of the climber",
"The climbers gradient, pointing in the direction of greatest ascent"
]
ans = 1
radioq(choices, ans)


choices = [
L"Keep $\cos(\theta)$ smaller than $1$, so that the slope taken is not too great",
L"Keep $\cos(\theta)$ as close to $1$ as possible, so the slope taken is as big as possible",
L"Keep $\cos(\theta)$ as close to $0$ as possible, so that they climbers don't waste energy going up and down"
]
ans = 1
radioq(choices, ans)


choices = [
L"It would be $0$, as the top would be maximum for $f\circ\vec\gamma$",
L"It would be $\langle f_x, f_y\rangle$ and point towards the sky, the direction of greatest ascent",
"It would not exist, as there would not be enough oxygen to compute it"
]
ans = 1
radioq(choices, ans)


choices = [
L"|\hat{T} \cdot \hat{P}| \leq \cos(\pi/18)",
L"|\hat{T} \cdot \hat{P}| \leq \sin(\pi/18)",
L"|\hat{T} \cdot \hat{P}| \leq \pi/18"
]
ans = 1
radioq(choices, ans)


choices = [
L"|\hat{N} \cdot \hat{M}| \leq \cos(\pi/2 - \pi/36)",
L"|\hat{N} \cdot \hat{M}| \leq \sin(\pi/2 - \pi/18)",
L"|\hat{N} \cdot \hat{M}| \leq \pi/2 - \pi/18"
]
ans = 1
radioq(choices, ans)


choices = [
L"\frac{\sqrt{5}}{5}\left(2 \cos{\left (3 \right )} - 7 \sin{\left (3 \right )}\right)",
L"2 \cos{\left (3 \right )} - 7 \sin{\left (3 \right )}",
L"4 x^{2} y \sin{\left (x - y^{2} \right )} - x^{2} \sin{\left (x - y^{2} \right )} + 2 x \cos{\left (x - y^{2} \right )}"
]
ans = 1
radioq(choices, ans)


choices = [
"Yes, by definition",
L"No, not unless $\vec{v}$ were a unit vector"
]
ans = 2
radioq(choices, ans)


choices = [
L"\langle 4x^3 + 2x + 2y, 2x + 4y^3, 2x \rangle",
L"\langle 4x^3, 2z, 2y\rangle",
L"\langle x^3 + 2x + 2x, 2y+ y^3, 2x\rangle"
]
ans = 1
radioq(choices, ans)


choices = [
L"\langle 1, 2t, 3t^2\rangle",
L"1 + 2y + 3t^2",
L"\langle 1,2, 3 \rangle"
]
ans = 1
radioq(choices, ans)


choices = [
L"Taking the dot product of  $\nabla{f}(\vec\gamma(t))$ and $\vec\gamma'(t)$",
L"Taking the dot product of  $\nabla{f}(\vec\gamma'(t))$ and $\vec\gamma(t)$",
L"Taking the dot product of  $\nabla{f}(x,y,z)$ and $\vec\gamma'(t)$"
]
ans = 1
radioq(choices, ans)


plotly()
f(x,y) = 2 + x^2 - y^2
f(v) = f(v...)
pt = [1/2, -3/4]
xs = ys = range(-1, stop=1, length=50)
uvec(x) = x/norm(x)

gradf = ForwardDiff.gradient(f, pt)
surface(xs, ys, f, legend=false, aspect_ratio=:equal)
arrow!([pt...,0], [uvec(gradf)...,0], color=:blue, linewidth=3)
arrow!([pt...,0], [-1,0,0], color=:green, linewidth=3)
arrow!([pt..., f(pt...)], uvec([(-gradf)..., 1]), color=:red, linewidth=3)


choices = [
"The blue one",
"The green one",
"The red one"
]
ans = 1
radioq(choices, ans)


gr()
f(x,y) = 2 + x^2 - y^2
f(v) = f(v...)
xs = ys = range(-3/2, stop=3/2, length=50)
contour(xs, ys, f, aspect_ratio=:equal)
arrow!(pt, [uvec(gradf)...], color=:blue, linewidth=3)
arrow!(pt, [-1, 0], color=:green, linewidth=3)
arrow!([0,0], pt, color=:red, linewidth=3)


choices = [
"The blue one",
"The green one",
"The red one"
]
ans = 1
radioq(choices, ans)


choices = [
L"Linear means $H$ is the $0$ matrix, so $g(\vec{x})$ is the constant $f(\vec{c})$",
L"Linear means $H$ is linear, so $g(\vec{x})$ describes a plane",
L"Linear means $H$ is the $0$ matrix, so the gradient couldn't have been $\vec{0}$"
]
ans = 1
radioq(choices, ans)


choices = [
L"That $g(\vec{x}) \geq f(\vec{c})$",
L"That $g(\vec{x}) = f(\vec{c})$",
L"That $g(\vec{x}) \leq f(\vec{c})$"
]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
L"\partial^4{f}/\partial{x^4}",
L"\partial^4{f}/\partial{x^3}\partial{y}",
L"\partial^4{f}/\partial{x^2}\partial{y^2}",
L"\partial^4{f}/\partial{x^1}\partial{y^3}"
]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
L"f_x",
L"f_y",
L"f_{xx}",
L"f_{xy}",
L"f_{yy}"
]
x,y=1/2, 2
val, ans = findmax([6x*y, 3x^2, 6*y, 6x, 0])
radioq(choices, ans, keep_order=true)


ans = -1
numericq(ans)


ans = 1
numericq(ans)


choices = ["As this is the ratio of continuous functions, it is continuous at the origin",
L"This is not continuous at $(0,0)$, still the limit along the two paths $x=0$ and $y=0$ are equivalent.",
L"This is not continuous at $(0,0)$, as the limit along the two paths $x=0$ and $y=0$ are not equivalent."
]
ans = 3
radioq(choices, ans)


@vars x y Δ real=true

G = SymPy.SymFunction("G")
Dx(f,h) = (subs(f, x=>x+h) - f)/h
Dy(f,h) = (subs(f, y=>y+h) - f)/h

Dy(Dx(G(x,y), Δ), Δ) - Dx(Dy(G(x,y), Δ), Δ)


numericq(0)


yesnoq(false)


# 4 questions, don't edit this order!
choices = [
L"The wave equation: $f_{tt} = f_{xx}$; governs motion of light or sound",
L"The heat equation: $f_t = f_{xx}$; describes diffusion of heat",
L"The Laplace equation: $f_{xx} + f_{yy} = 0$; determines shape of a membrane",
L"The advection equation: $f_t = f_x$; is used to model transport in a wire",
L"The eiconal equation: $f_x^2 + f_y^2 = 1$; is used to model evolution of a wave front in optics",
L"The Burgers equation: $f_t + ff_x = f_{xx}$; describes waves at the beach which break",
L"The KdV equation: $f_t + 6ff_x+ f_{xxx} = 0$; models water waves in a narrow channel",
L"The Schrodinger equation: $f_t = (i\hbar/(2m))f_xx$; used to describe a quantum particle of mass $m$"
]
ans = 3
radioq(choices, ans, keep_order=true)


ans = 1
radioq(choices, ans, keep_order=true)


ans = 4
radioq(choices, ans, keep_order=true)


ans = 5
radioq(choices, ans, keep_order=true)

