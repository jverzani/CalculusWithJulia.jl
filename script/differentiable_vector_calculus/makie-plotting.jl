
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using AbstractPlotting
nothing


using AbstractPlotting
using GLMakie
#using WGLMakie; WGLMakie.activate!()
#AbstractPlotting.set_theme!(scale_figure=false, resolution = (480, 400))


scene = Scene()


xs = [1,2,3]
ys = [2,3,2]
scatter(xs, ys)


pts = [Point2(1,2), Point2(2,3), Point2(3,2)]
scatter(pts)


r(t) = [sin(t), cos(t)]


ts = [1,2,3]
r.(ts)


pts = Point2.(r.(ts))


scatter(pts)


r(t) = [sin(t), cos(t), t]
ts = range(0, 4pi, length=100)
pts = Point3.(r.(ts))
scatter(pts)


unzip(vs) = Tuple([vs[j][i] for j in eachindex(vs)] for i in eachindex(vs[1]))


scatter(unzip(r.(ts))...)


scatter(xs, ys, marker=[:x,:cross, :circle], markersize=25, color=:blue)


pts = Point2.(1:5, 1:5)
scene = scatter(pts)
[text!(scene, "text", position=pt, textsize=1/i, rotation=2pi/i) for (i,pt) in enumerate(pts)]
scene


f(x) = sin(x)
a, b = 0, 2pi
xs = range(a, b, length=250)
lines(xs, f.(xs))


f(x) = cos(x)
a, b = -pi, pi
xs = a:pi/100:b
lines(xs, f.(xs))


xs = range(0, 2pi, length=100)
scene = lines(xs, sin.(xs))
lines!(scene, xs, cos.(xs))


xs = range(0, 2pi, length=10)
lines(xs, sin.(xs))
scatter!(xs, sin.(xs), markersize=10)


xs = range(0, 2pi, length=200)
scene = plot(xs, sin.(xs))
rect = scene.data_limits[] # get limits for g from f
a, b = rect.origin[1],  rect.origin[1] + rect.widths[1]


using ForwardDiff
f(x) = x^x
a, b= 0, 2
c = 0.5
xs = range(a, b, length=200)

tl(x) = f(c) + ForwardDiff.derivative(f, c) * (x-c)

scene = lines(xs, f.(xs))
lines!(scene, xs, tl.(xs), color=:blue)


pts = [Point2(1,2), Point2(2,3), Point2(3,2)]
scene = scatter(pts)
title(scene, "3 points")
ylabel!(scene, "y values")
xticks!(scene, xtickrange=[1,2,3], xticklabels=["a", "b", "c"])


f(x) = 1/x
a,b = -1, 1
xs = range(-1, 1, length=200)
scene = lines(xs, f.(xs))
ylims!(scene, (-10, 10))
center!(scene)


r(t) = [sin(2t), cos(3t)]
ts = range(0, 2pi, length=200)
pts = Point2.(r.(ts))  # or (Point2∘r).(ts)
lines(pts)


r(t) = [sin(2t), cos(3t), t]
ts = range(0, 2pi, length=200)
pts = Point3.(r.(ts))
lines(pts)


xs, ys, zs = unzip(r.(ts))
lines(xs, ys, zs)


using ForwardDiff
r(t) = [sin(t), cos(t)] # vector, not tuple
ts = range(0, 4pi, length=200)
scene = Scene()
lines!(scene, Point2.(r.(ts)))

nts = 0:pi/4:2pi
us = r.(nts)
dus = ForwardDiff.derivative.(r, nts)

arrows!(scene, Point2.(us), Point2.(dus))


r(t) = [sin(t), cos(t), t] # vector, not tuple
ts = range(0, 4pi, length=200)
scene = Scene()
lines!(scene, Point3.(r.(ts)))

nts = pi:pi/4:3pi
us = r.(nts)
dus = ForwardDiff.derivative.(r, nts)

arrows!(scene, Point3.(us), Point3.(dus))


using MDBM


function implicit_equation(f, axes...; iteration::Int=4, constraint=nothing)

    axes = [axes...]

    if constraint == nothing
        prob = MDBM_Problem(f, axes)
    else
        prob = MDBM_Problem(f, axes, constraint=constraint)
    end

    solve!(prob, iteration)

    prob
end


f(x,y) = x^3 + x^2 + x + 1 - x*y        # solve x^3 + x^2 + x + 1 = x*y
ie = implicit_equation(f, -5:5, -10:10)


AbstractPlotting.plot(m::MDBM_Problem; kwargs...) = plot!(Scene(), m; kwargs...)
AbstractPlotting.plot!(m::MDBM_Problem; kwargs...) = plot!(AbstractPlotting.current_scene(), m; kwargs...)
AbstractPlotting.plot!(scene::AbstractPlotting.Scene, m::MDBM_Problem; kwargs...) =
    plot!(Val(_dim(m)), scene, m; kwargs...)

_dim(m::MDBM.MDBM_Problem{a,N,b,c,d,e,f,g,h}) where {a,N,b,c,d,e,f,g,h} = N


# 2D plot
function AbstractPlotting.plot!(::Val{2}, scene::AbstractPlotting.Scene,
    m::MDBM_Problem; color=:black, kwargs...)

    mdt=MDBM.connect(m)
    for i in 1:length(mdt)
        dt=mdt[i]
        P1=getinterpolatedsolution(m.ncubes[dt[1]], m)
        P2=getinterpolatedsolution(m.ncubes[dt[2]], m)
        lines!(scene, [P1[1],P2[1]],[P1[2],P2[2]], color=color, kwargs...)
    end

    scene
end


# 3D plot
function AbstractPlotting.plot!(::Val{3}, scene::AbstractPlotting.Scene,
    m::MDBM_Problem; color=:black, kwargs...)

    positions = Point{3, Float32}[]
    scales = Vec3[]
    
    mdt=MDBM.connect(m)
    for i in 1:length(mdt)
        dt=mdt[i]
        P1=getinterpolatedsolution(m.ncubes[dt[1]], m)
        P2=getinterpolatedsolution(m.ncubes[dt[2]], m)

        a, b = Vec3(P1), Vec3(P2)
        push!(positions, Point3(P1))
        push!(scales, b-a)
    end

    cube = Rect{3, Float32}(Vec3(-0.5, -0.5, -0.5), Vec3(1, 1, 1))
    meshscatter!(scene, positions, marker=cube, scale = scales, color=color, transparency=true, kwargs...)
    
    scene
end


plot(ie)


peaks(x,y) = 3*(1-x)^2*exp(-x^2 - (y+1)^2) - 10(x/5-x^3-y^5)*exp(-x^2-y^2)- 1/3*exp(-(x+1)^2-y^2)
xs = ys = range(-5, 5, length=25)
surface(xs, ys, peaks)


zs = peaks.(xs, ys')
surface(xs, ys, zs)


xs = ys = range(-5, 5, length=5)
pts = [Point3(x, y, peaks(x,y)) for x in xs for y in ys]
scatter(pts, markersize=25)


wireframe(xs, ys, peaks.(xs, ys'), linewidth=5)


surface!(xs, ys, peaks.(xs, ys'))


r₂(x,y,z) = x^2 + y^2 + z^2 - 5/4 # a sphere
r₄(x,y,z) = x^4 + y^4 + z^4 - 1
xs = ys = zs = -2:2
m2,m4 = implicit_equation(r₂, xs, ys, zs), implicit_equation(r₄, xs, ys, zs)

plot(m4, color=:yellow)
plot!(m2, color=:red)


function parametric_grid(us, vs, r)
    n,m = length(us), length(vs)
    xs, ys, zs = zeros(n,m), zeros(n,m), zeros(n,m)
    for (i, uᵢ) in enumerate(us)
        for (j, vⱼ) in enumerate(vs)
            x,y,z = r(uᵢ, vⱼ)
            xs[i,j] = x
            ys[i,j] = y
            zs[i,j] = z
        end
    end
    (xs, ys, zs)
end


r(u,v) = [sin(u)*cos(v), sin(u)*sin(v), cos(u)]
us = range(0, pi, length=25)
vs = range(0, pi/2, length=25)
xs, ys, zs = parametric_grid(us, vs, r)

scene = Scene()
surface!(scene, xs, ys, zs)
wireframe!(scene, xs, ys, zs)


g(u) = u^2 * exp(-u)
r(u,v) = (g(u)*sin(v), g(u)*cos(v), u)
us = range(0, 3, length=10)
vs = range(0, 2pi, length=10)
xs, ys, zs = parametric_grid(us, vs, r)

scene = Scene()
surface!(scene, xs, ys, zs)
wireframe!(scene, xs, ys, zs)


r1, r2 = 2, 1/2
r(u,v) = ((r1 + r2*cos(v))*cos(u), (r1 + r2*cos(v))*sin(u), r2*sin(v))
us = vs = range(0, 2pi, length=25)
xs, ys, zs = parametric_grid(us, vs, r)

scene = Scene()
surface!(scene, xs, ys, zs)
wireframe!(scene, xs, ys, zs)


ws = range(-1/4, 1/4, length=8)
thetas = range(0, 2pi, length=30)
r(w, θ) = ((1+w*cos(θ/2))*cos(θ), (1+w*cos(θ/2))*sin(θ), w*sin(θ/2))
xs, ys, zs = parametric_grid(ws, thetas, r)

scene = Scene()
surface!(scene, xs, ys, zs)
wireframe!(scene, xs, ys, zs)


xs = ys = range(-5, 5, length=100)
contour(xs, ys, peaks)


contour(xs, ys, peaks.(xs, ys'), levels = 20)


heatmap(xs, ys, peaks)


xs = ys = range(-5, 5, length=51)
zs = peaks.(xs, ys') / 5;


scene = surface(xs, ys, zs)
wireframe!(scene, xs, ys, zs, overdraw = true, transparency = true, color = (:black, 0.1))


xmin, ymin, zmin = minimum(scene_limits(scene))
contour!(scene, xs, ys, zs, levels = 15, linewidth = 2, transformation = (:xy, zmin))
center!(scene)


f(x,y,z) = x^2 + y^2 + z^2
xs = ys = zs = range(-3, 3, length=100)
contour(xs, ys, zs, f)


f(x, y) = [y, -x]
xs = ys = -5:5
pts = vec(Point2.(xs, ys'))
dus = vec(Point2.(f.(xs, ys')))


arrows(pts, dus)


using LinearAlgebra
dvs = dus ./ norm.(dus)
arrows(pts, dvs)


g(x,y) = Point2(f(x,y))
streamplot(g, xs, ys)

