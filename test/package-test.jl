

@testset "multidimensional" begin

    x = [[1,2,3], [4,5,6]]
    @test unzip(x)[1] == [1, 4]
    @test unzip(x)[2] == [2, 5]
    @test unzip(x)[3] == [3, 6]

    xs = [1,2,3]
    ys = [1,2]
    M = ((x,y) -> (x,y)).(xs, ys')
    @test unzip(M, recursive=true)  == ([[1,2,3], [1,2,3]], [[1,1,1], [2,2,2]])



    f(x,y,z) = x*y*z
    f(v) = f(v...)
    @test ∇(f)([1,2,3]) ≈  [2*3, 1*3, 1*2]

    F₁(x,y,z) = [x,y,z]
    F₁(v) = F₁(v...)
    @test  (∇⋅F₁)([1,0,0]) ≈ 3


    F₂(x,y,z) = [-y, x, 0]
    F₂(v) = F₂(v...)
    @test all((∇ × F₂)([1,2,3]) .≈ [0.0, 0.0, 2.0])

end


@testset "derivatives" begin

    f(x) = x^2
    @test secant(f, 0, 1)(1/2) ≈ 1/2
    @test tangent(f, 1/2)(1) ≈ f(1/2) + 2*(1/2)*(1-1/2)

    @test f'(1) ≈ 2
    @test f''(1)  ≈ 2
    @test iszero(f'''(1))

    r(t) = [t, t^2, t^3]
    @test all(r'(1) .≈ [1.0, 2*1, 3*1^2])
end

@testset "integration" begin

    @test riemann(sin, 0, pi, 10_000)  ≈ 2
#    @test fubini((x,y) -> 1, (x->-sqrt(1-x^2), x->sqrt(1-x^2)), (-1,1)) ≈ pi

end

@testset "plot-utils" begin

    if isinteractive()

        pyplot()
        f(x) = 1/x

        plotif(f, f, -1, 1)
        plotif(f, f', -1, 1)
        trimplot(f, -1, 1)
        signchart(f, -1, 1)

        rr(theta) = cos(theta)
        plot_polar(rr, 0, 2pi)

        rr(t) = [sin(t), cos(t)]
        plot_parametric_curve(rr, 0, 2pi)
        arrow!(rr(2pi), rr'(2pi))

        rr(t) = [sin(t), cos(t), t]
        plot_parametric_curve(rr, 0, 2pi)
        arrow!(rr(2pi), rr'(2pi))

        F(u, v) = [u*cos(v), u*sin(v)]
        us = range(0, 1, length=20)
        vs = range(0, 2pi, length=20)
        plot(legend=false)
        plot!(unzip(F.(us, vs'))...) # constant angle, draws rays
        plot!(unzip(F.(us', vs))...) # constant radii, draws circles

        pyplot() # surface doesn't work with gr()
        Phi(u,v) = [u*cos(v), u*sin(v), u]
        us, vs = 0:.1:1, 0:pi/8:2pi
        xs, ys, zs = unzip(Phi.(us, vs'))
        surface(Phi, xlims=(0, 1), ylims=(0,2pi))

        V(x,y) = [x, x-y]
        vectorfieldplot(V, xlims=(-2,2))#, nx=8, ny=8) # ylim=(-5,5) plotly not happy, gr is

        V(x,y,z) = [-y, x, 0]
        vectorfieldplot3d(V, nx=4, ny=4, nz=3)

    end

end
