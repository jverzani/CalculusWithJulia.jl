using CalculusWithJulia
using Plots
@testset "plot-utils" begin

    f(x) = 1/x

    plotif(f, f, -1, 1)
    plotif(f, f', -1, 1)
    trimplot(f, -1, 1)
        signchart(f, -1, 1)

    rr₁(t) = cos(t)
    plot_polar(0..2pi, rr₁)

    rr₂(t) = [sin(t), cos(t)]
    plot_parametric_curve(rr₂, 0, 2pi)
    arrow!(rr₂(2pi), rr₂'(2pi))

    rr₃(t) = [sin(t), cos(t), t]
    plot_parametric_curve(0..2pi, rr₃)
    arrow!(rr₃(2pi), rr₃'(2pi))

    F(u, v) = [u*cos(v), u*sin(v)]
    us = range(0, 1, length=20)
    vs = range(0, 2pi, length=20)
    plot(legend=false)
    plot!(unzip(F.(us, vs'))...) # constant angle, draws rays
    plot!(unzip(F.(us', vs))...) # constant radii, draws circles

    plotly() # surface and gr() don't mix
    Phi(u,v) = [u*cos(v), u*sin(v), u]
    us, vs = 0:.1:1, 0:pi/8:2pi
    xs, ys, zs = unzip(Phi.(us, vs'))
    surface(Phi, xlims=(0, 1), ylims=(0,2pi))

    V(x,y) = [x, x-y]
    vectorfieldplot(V, xlims=(-2,2))#, nx=8, ny=8) # ylim=(-5,5) plotly not happy, gr is

    V(x,y,z) = [-y, x, 0]
    vectorfieldplot3d(V, nx=4, ny=4, nz=3)

end
