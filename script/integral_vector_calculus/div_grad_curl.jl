
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia
using Plots


pyplot()
using LaTeXStrings
_bar(x) = sum(x)/length(x)
_shrink(x, xbar, offset) = xbar .+ (1-offset/100)*(x .- xbar)
function _poly!(plt::Plots.Plot, ps; offset=5, kwargs...)
    push!(ps, first(ps))
    xs, ys = unzip(ps)
    xbar, ybar = _bar.((xs, ys))
    xs, ys = _shrink.(xs, xbar, offset), _shrink.(ys, ybar, offset)

    plot!(plt, xs, ys; kwargs...)
#    xn = [xs[end],ys[end]]
#    x0 = [xs[1], ys[1]]
#    dxn = 0.95*(x0 - xn)

#    plot!(plt, xn, dxn; kwargs...)

    plt
end
_poly!(ps;offset=5,kwargs...) = _poly!(Plots.current(), ps; offset=offset, kwargs...)

dx = .5
dy = .250
offset=5
p = plot(;ylim=(0-.2, 1+dy+.4), legend=false, aspect_ratio=:equal,xticks=nothing,yticks=nothing, border=:none)
plot!(p, [dx,dx],[dy,1+dy-offset/100], linestyle=:dash)
plot!(p, [0+offset/100,dx],[0+offset/100,dy], linestyle=:dash)
plot!(p, [dx,1+dx-2offset/100],[dy,dy], linestyle=:dash)

ps = [[1,1], [0,1],[0,0],[1,0]]
_poly!(ps, linewidth=3, color=:blue)

ps = [[1,1], [1+dx, 1+dy], [dx, 1+dy],[0,1]]
_poly!(ps,  linewidth=3, color=:red)

ps = [[1,0],[1+dx, dy],[1+dx, 1+dy],[1,1]]
_poly!(ps,  linewidth=3, color=:green)
arrow!([.55,.6],.3*[-1,-1/2], color=:blue)
arrow!([1+.6dx, .6], .3*[1,0], color=:blue)
arrow!([.75, 1+.5*dy], .3*[0,1], color=:blue)
annotate!([
        (.5, -.1, "Δy"),
        (1+.75dx, .1, "Δx"),
        (1+dx+.1, .75, "Δz"),
        (.5,.15,L"(x,y,z)"),
        (.45,.6, "î"),
        (1+.8dx, .7, "ĵ"),
        (.8, 1+dy+.1, "k̂")
        ])
p


divergence(F::Vector{Sym}, vars) = sum(diff.(F, vars))
divergence(F::Function, pt) = sum(diag(ForwardDiff.jacobian(F, pt)))


gr()
using LaTeXStrings
function apoly!(plt::Plots.Plot, ps; offset=5, kwargs...)
    xs, ys = unzip(ps)
    xbar, ybar = _bar.((xs, ys))
    xs, ys = _shrink.(xs, xbar, offset), _shrink.(ys, ybar, offset)

    plot!(plt, xs, ys; kwargs...)
    xn = [xs[end],ys[end]]
    x0 = [xs[1], ys[1]]
    dxn = 0.95*(x0 - xn)

    arrow!(plt, xn, dxn; kwargs...)

    plt
end
apoly!(ps;offset=5,kwargs...) = apoly!(Plots.current(), ps; offset=offset, kwargs...)

p = plot(legend=false, xticks=nothing, yticks=nothing, border=:none, xlim=(-1/4, 1+1/4),ylim=(-1/4, 1+1/4))
apoly!([[0,0],[1,0], [1,1], [0, 1]], linewidth=3, color=:blue)

dx = .025
arrow!([1/2, dx], .01 *[1,0], linewidth=3, color=:blue)
arrow!([1/2, 1-dx], .01 *[-1,0], linewidth=3, color=:blue)
arrow!([1-dx, 1/2], .01 *[0, 1], linewidth=3, color=:blue)

annotate!([
        (0,-1/16,L"(x,y)"),
        (1, -1/16, L"(x+\Delta{x},y)"),
        (0, 1+1/16, L"(x,y+\Delta{y})"),
        (1/2, 4dx, L"\hat{i}"),
        (1/2, 1-4dx, L"-\hat{i}"),
        (3dx, 1/2, L"-\hat{j}"),
        (1-3dx, 1/2, L"\hat{j}")
        ])


pyplot()

dx = .5
dy = .250
offset=5
p = plot(;ylim=(0-.2, 1+dy+.4), legend=false, aspect_ratio=:equal,xticks=nothing,yticks=nothing, border=:none)
plot!(p, [dx,dx],[dy,1+dy-offset/100], linestyle=:dash)
plot!(p, [0+offset/100,dx],[0+offset/100,dy], linestyle=:dash)
plot!(p, [dx,1+dx-2offset/100],[dy,dy], linestyle=:dash)

ps = [[1,1], [0,1],[0,0],[1,0]]
apoly!(ps, linewidth=3, color=:blue)

ps = [[1,1], [1+dx, 1+dy], [dx, 1+dy],[0,1]]
apoly!(ps,  linewidth=3, color=:red)

ps = [[1,0],[1+dx, dy],[1+dx, 1+dy],[1,1]]
apoly!(ps,  linewidth=3, color=:green)
arrow!([.55,.6],.3*[-1,-1/2], color=:blue)
arrow!([1+.6dx, .6], .3*[1,0], color=:blue)
arrow!([.75, 1+.5*dy], .3*[0,1], color=:blue)
annotate!([
        (.5, -.1, "Δy"),
        (1+.75dx, .1, "Δx"),
        (1+dx+.1, .75, "Δz"),
        (.5,.15,L"(x,y,z)"),
        (.45,.6, "î"),
        (1+.8dx, .667, "ĵ"),
        (.8, 1+dy+.067, "k̂"),
        (.9, 1.1, "S₁")
        ])
p


pyplot()
p = plot(xlim=(-.1,1.25), ylim=(-.2, 1.25),legend=false, xticks=nothing, yticks=nothing, border=:none)
ps = [[1,0],[1,1],[0,1],[0,0]]
#push!(ps, first(ps))
apoly!(p, ps, linewidth=3, color=:red)
#plot!(p, unzip(ps), linewidth=3, color=:red)
dx = .025
arrow!([1/2,dx], .01*[1,0], color=:red, linewidth=3)
arrow!([1/2,1-dx],  .01*[-1,0], color=:red, linewidth=3)
arrow!([1-dx,1/2], .01*[0,1], color=:red, linewidth=3)
arrow!([dx,1/2], .01*[0,-1], color=:red, linewidth=3)
dx = .05
annotate!([
        (0, 1/2, "A"),
        (1/2,2dx, "B"),
        (1-(3/2)dx,1/2, "C"),
        (1/2,1-2dx, "D"),

        (.9, 1+dx, "C₁"),

        (2*dx, 1/2, L"\hat{T}=\hat{i}"),
        (1+2*dx,1/2, L"\hat{T}=-\hat{i}"),
        (1/2,-3/2*dx, L"\hat{T}=\hat{j}"),
        (1/2, 1+(3/2)*dx, L"\hat{T}=-\hat{j}"),

        (3dx,1-2dx, "(x,y,z+Δz)"),
        (4dx,2dx, "(x+Δx,y,z+Δz)"),
        (1-4dx, 1-2dx, "(x,y+Δy,z+Δz)"),
		(1-2dx, 2dx, "S₁")
        ])

plotly()
p


function curl(J::Matrix)
    Mx, Nx, Px, My, Ny, Py, Mz, Nz, Pz = J
    [Py-Nz, Mz-Px, Nx-My] # ∇×VF
end


curl(F::Vector{Sym}, vars=free_symbols(F)) = curl(F.jacobian(vars))
curl(F::Function, pt) = curl(ForwardDiff.jacobian(F, pt))


note("""
Mathematically operators have not been seen previously, but the concept of an operation on a function that returns another function is a common one when using `Julia`. We have seen many examples (`plot`, `D`, `quadgk`, etc.). In computer science such functions are called *higher order* functions, as they accept arguments which are also functions.
""")


f(x,y,z) = x*y*z
f(v) = f(v...)
F(x,y,z) = [x, y, z]
F(v) = F(v...)

@vars x y z
∇(f(x,y,z))  # symbolic operation on the symbolic expression f(x,y,z)


free_symbols(f(x,y,z))


∇( (f(x,y,z), [x,y,z]) )


∇(f)(1,2,3) # a numeric computation. Also can call with a point [1,2,3]


∇ ⋅ F(x,y,z)


(∇ ⋅ F)(1,2,3)   # a numeric computation. Also can call (∇ ⋅ F)([1,2,3])


∇ × F(x,y,z)


(∇ × F)(1,2,3)  # numeric. Also can call (∇ × F)([1,2,3])


note("""
As mentioned, for the symbolic evaluations, a specification of three variables (here `x`, `y`, and `z`) is necessary. This use takes `free_symbols` to identify three free symbols which may not always be the case. (It wouldn't be for, say, `F(x,y,z) = [a*x,b*y,0]`, `a` and `b` constants.) In those cases, the notation accepts a tuple to specify the function or vector field and the variables, e.g. (`∇( (f(x,y,z), [x,y,z]) )`, as illustrated;  `∇ × (F(x,y,z), [x,y,z])`; or `∇ ⋅ (F(x,y,z), [x,y,z])` where this is written using function calls to produce the symbolic expression in the first positional argument, though a direct expression could also be used. In these cases, the named versions `gradient`, `curl`, and `divergence` may be preferred.
""")


F(x,y,z) = [x,y,z]
@vars x y z real=true
∇ ⋅ F(x,y,z)


gr()
F12(x,y) = [x,y]
F12(v) = F12(v...)
p = plot(legend=false)
vectorfieldplot!(p, F12, xlim=(-5,5), ylim=(-5,5), nx=10, ny=10)
t0, dt = -pi/6, 2pi/6
r0, dr = 3, 1
plot!(p, unzip(r -> r * [cos(t0), sin(t0)], r0, r0 + dr)..., linewidth=3)
plot!(p, unzip(r -> r * [cos(t0+dt), sin(t0+dt)], r0, r0 + dr)..., linewidth=3)
plot!(p, unzip(t -> r0 * [cos(t), sin(t)], t0, t0 + dt)..., linewidth=3)
plot!(p, unzip(t -> (r0+dr) * [cos(t), sin(t)], t0, t0 + dt)..., linewidth=3)

plotly()
p


@vars x y z real=true
R = [x,y,z]
Rhat = R/norm(R)
VF = (1/norm(R)^2) * Rhat
∇ ⋅ VF  |> simplify


curl([-y,x,0], [x,y,z])


gr()
V(x,y,z) = [-y, x,0]
V(v) = V(v...)
p = plot([NaN],[NaN],[NaN], legend=false)
ys = xs = range(-2,2, length=10 )
zs = range(0, 4, length=3)
CalculusWithJulia.vectorfieldplot3d!(p, V, xs, ys, zs, nz=3)
plot!(p, [0,0], [0,0],[-1,5], linewidth=3)
p


R = [-y, x, 0]
VF = R / norm(R)^2
curl(VF, [x,y,z]) .|> simplify


gr()
vectorfieldplot((x,y) -> [0, 1+y^2], xlim=(-1,1), ylim=(-1,1), nx=10, ny=8)


curl(Sym[0,1+y^2,0], [x,y,z])


gr()
vectorfieldplot((x,y) -> [0, 1+x^2], xlim=(-1,1), ylim=(-1,1), nx=10, ny=8)


curl([0, 1+x^2,0], [x,y,z])


@vars x y z a1 a2 a3
a = [a1, a2, a3]
r = [x, y, z]
curl(a × r, [x,y, z])


curl([x,y,z], [x,y,z])


H = SymFunction("H")
R = sqrt(x^2 + y^2 + z^2)
Rhat = [x, y, z]/R
curl(H(R) * Rhat, [x, y, z])


gr()

dx = .5
dy = .250
offset=5
p = plot(;ylim=(0-.1, 1+dy+.1), legend=false, aspect_ratio=:equal,xticks=nothing,yticks=nothing, border=:none)
plot!(p, [dx,dx],[dy,1+dy-offset/100], linestyle=:dash)
plot!(p, [0+offset/100,dx],[0+offset/100,dy], linestyle=:dash)
plot!(p, [dx,1+dx-2offset/100],[dy,dy], linestyle=:dash)

ps = [[1,1], [0,1],[0,0],[1,0]]
apoly!(ps, linewidth=3, color=:blue)

ps = [[1,1], [1+dx, 1+dy], [dx, 1+dy],[0,1]]
apoly!(ps,  linewidth=3, color=:red)

ps = [[1,0],[1+dx, dy],[1+dx, 1+dy],[1,1]]
apoly!(ps,  linewidth=3, color=:green)
annotate!(dx+.02, dy-0.05, L"P_1")
annotate!(0+0.05, 0 - 0.02, L"P_2")
annotate!(1+0.05, 0 - 0.02, L"P_3")
annotate!(1+dx+.02, dy-0.05, L"P_4")
p


@vars x y z Δx Δy Δz
p1, p2, p3, p4=(x, y, z), (x + Δx, y, z), (x + Δx, y + Δy, z), (x, y + Δy, z)
F_z = SymFunction("F_z")
ex = (-F_z(p2...) + F_z(p3...))*Δz +   # face A
(-F_z(p3...) + F_z(p4...))*Δz +   # face B
(F_z(p1...) - F_z(p4...))*Δz  +   # face C
(F_z(p2...) - F_z(p1...))*Δz      # face D


simplify(ex)


plotly()
Fx(r, theta, phi) = r * cos(theta) * sin(phi)
Fy(r, theta, phi) = r * sin(theta) * sin(phi)
Fz(r, theta, phi) = r * cos(phi)
F(r, theta, phi) = [Fx(r,theta,phi), Fy(r, theta, phi), Fz(r, theta, phi)]
Ftp(theta, phi;r = r0) = F(r, theta, phi)

r0, t0, p0 = 1, pi/4, pi/4
dr, dt, dp = 0.15, pi/8, pi/24
nr = nt = np = 5
rs = range(r0, r0+dr, length=nr)
ts = range(t0, t0+dt, length=nt)
ps = range(p0, p0 + dp, length=np)


# plot lines for fixed r, theta, phi
p = plot(unzip(r -> F(r,t0,p0), r0, r0+dr)..., legend=false, linewidth=2, color=:black, camera=(50, 60))
plot!(p, unzip(t -> F(r0,t,p0), t0, t0+dt)..., linewidth=2, color=:black)
plot!(p, unzip(p -> F(r0,t0,p), p0, p0+dp)..., linewidth=2, color=:black)

for theta in ts[2:end]
   plot!(p, unzip(phi -> Ftp(theta, phi), p0, p0+dp)...)
end
for phi in ps[2:end]
   plot!(p, unzip(theta -> Ftp(theta, phi), t0, t0+dt)...)
end

∂Fr(r, theta, phi) = [cos(theta) * sin(phi), sin(theta) * sin(phi), cos(phi)]
∂Fθ(r, theta, phi) = [-r*sin(theta)*sin(phi), r*cos(theta)*sin(phi), 0]
∂Fϕ(r, theta, phi) = [r*cos(theta)*cos(phi), r*sin(theta)*cos(phi), -r*sin(phi)]

pt = (r0, t0, p0)
arrow!(p, F(pt...), (1/15) * ∂Fr(pt...), color=:blue, linewidth=4)
arrow!(p, F(pt...), (1/4) * ∂Fθ(pt...), color=:blue, linewidth=4)
arrow!(p, F(pt...), (1/10) * ∂Fϕ(pt...), color=:blue, linewidth=4)
p


plotly()
Fx(r, theta, phi) = r * cos(theta) * sin(phi)
Fy(r, theta, phi) = r * sin(theta) * sin(phi)
Fz(r, theta, phi) = r * cos(phi)
F(r, theta, phi) = [Fx(r,theta,phi), Fy(r, theta, phi), Fz(r, theta, phi)]
Ftp(theta, phi;r = r0) = F(r, theta, phi)

r0, t0, p0 = 1, pi/4, pi/4
dr, dt, dp = 0.15, pi/8, pi/24
nr = nt = np = 5
rs = range(r0, r0+dr, length=nr)
ts = range(t0, t0+dt, length=nt)
ps = range(p0, p0 + dp, length=np)


# plot lines for fixed r, theta, phi
p = plot(unzip(r -> F(r,t0,p0), r0, r0+dr)..., legend=false, linewidth=2, color=:black, camera=(50, 60))
plot!(p, unzip(r -> F(r,t0+dt,p0), r0, r0+dr)..., linewidth=2, color=:black)
plot!(p, unzip(r -> F(r,t0,p0+dp), r0, r0+dr)..., linewidth=2, color=:black)
plot!(p, unzip(r -> F(r,t0+dt,p0+dp), r0, r0+dr)..., linewidth=2, color=:black)

plot!(p, unzip(t -> F(r0,t,p0), t0, t0+dt)..., linewidth=2, color=:black)
plot!(p, unzip(t -> F(r0+dr,t,p0), t0, t0+dt)..., linewidth=2, color=:black)
plot!(p, unzip(t -> F(r0,t,p0+dp), t0, t0+dt)..., linewidth=2, color=:black)
plot!(p, unzip(t -> F(r0+dr,t,p0+dp), t0, t0+dt)..., linewidth=2, color=:black)

plot!(p, unzip(p -> F(r0,t0,p), p0, p0+dp)..., linewidth=2, color=:black)
plot!(p, unzip(p -> F(r0+dr,t0,p), p0, p0+dp)..., linewidth=2, color=:black)
plot!(p, unzip(p -> F(r0,t0+dt,p), p0, p0+dp)..., linewidth=2, color=:black)
plot!(p, unzip(p -> F(r0+dr,t0+dt,p), p0, p0+dp)..., linewidth=2, color=:black)


∂Fr(r, theta, phi) = [cos(theta) * sin(phi), sin(theta) * sin(phi), cos(phi)]
∂Fθ(r, theta, phi) = [-r*sin(theta)*sin(phi), r*cos(theta)*sin(phi), 0]
∂Fϕ(r, theta, phi) = [r*cos(theta)*cos(phi), r*sin(theta)*cos(phi), -r*sin(phi)]

pt = (r0, t0, p0)
arrow!(p, F(pt...), (1/15) * ∂Fr(pt...), color=:blue, linewidth=4)
arrow!(p, F(pt...), (1/4) * ∂Fθ(pt...), color=:blue, linewidth=4)
arrow!(p, F(pt...), (1/10) * ∂Fϕ(pt...), color=:blue, linewidth=4)
p


F(x,y,z) = [x*y, y*z, z*x]
pt = [1,2,3]
Jac = ForwardDiff.jacobian(pt -> F(pt...), pt)
val = sum(diag(Jac))
numericq(val)


F(x,y,z) = [x*y, y*z, z*x]
F(v) = F(v...)
pt = [1,2,3]
vals = (∇×F)(pt)
val = vals[1]
numericq(val)


choices = [
L"x y + x e^{x y} + \cos{\left (x \right )}",
L"x y + x e^{x y}",
L"x e^{x y} + \cos{\left (x \right )}"
]
ans=1
radioq(choices, ans)


choices = [
L"xz",
L"-yz",
L"ye^{xy}"
]
ans = 1
radioq(choices, ans)


choices=[
L"0",
L"\vec{0}",
L"6"
]
ans=1
radioq(choices, ans)


choices = [
L"This is $0$ if the partial derivatives are continuous by Schwarz's (Clairault's) theorem",
L"This is $0$ for any $f$, as $\nabla\times\nabla$ is $0$ since the cross product of vector with itself is the $0$ vector."
]
ans = 1
radioq(choices, ans)


gr()
F(x,y) = [-y,x]/sqrt(0.0000001 + x^2+y^2)
vectorfieldplot(F, xlim=(-5,5),ylim=(-5,5), nx=15, ny=15)


choices=[
"The field is incompressible (divergence free)",
"The field is irrotational (curl free)",
"The field has a non-trivial curl and divergence"
]
ans=1
radioq(choices, ans, keep_order=true)


gr()
F(x,y) = [x,y]/sqrt(0.0000001 + x^2+y^2)
vectorfieldplot(F, xlim=(-5,5),ylim=(-5,5), nx=15, ny=15)


choices=[
"The field is incompressible (divergence free)",
"The field is irrotational (curl free)",
"The field has a non-trivial curl and divergence"
]
ans=2
radioq(choices, ans, keep_order=true)


choices=[
"The field is incompressible (divergence free)",
"The field is irrotational (curl free)",
"The field has a non-trivial curl and divergence"
]
ans=3
radioq(choices, ans, keep_order=true)


choices=[
"The field is incompressible (divergence free)",
"The field is irrotational (curl free)",
"The field has a non-trivial curl and divergence"
]
ans=1
radioq(choices, ans, keep_order=true)


choices = [
L"\vec{0}",
L"re_\phi",
L"rh'(r)e_\phi"
]
ans=1
radioq(choices, ans)

