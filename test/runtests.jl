using CalculusWithJulia
using Test

## test package
@testset "test packages" begin

    ## Roots
    @test fzero(sin, 3, 4)  ≈ pi
    @test fzero(sin, 3.0)  ≈ pi

    ## ForwardDiff
    f(x) = sin(x)
    @test f'(2)  ≈ cos(2)
    @test f''(2)  ≈ -sin(2)

    ## QuadGK
    @test quadgk(sin, 0, pi)[1]  ≈ 2
    @test abs(quadgk(x -> x^2, 0, 1)[2]) <= 1e-14

    ## HQuadrature
    @test hquadrature(x -> 2, (0.0, 0.0), (2pi, 1pi))[1]  ≈ 2 * (2pi) * (1pi)

    ## SymPy
    @test limit(x -> sin(x)/x, 0) == 1
    @test integrate(sin,  0, pi) == 2



end



@testset "multidimensional" begin

    x = [[1,2,3], [4,5,6]]
    @test unzip(x)[1] == [1, 4]
    @test unzip(x)[2] == [2, 5]
    @test unzip(x)[3] == [3, 6]

    xs = [1,2,3]
    ys = [1,2]
    M = ((x,y) -> (x,y)).(xs, ys')
    @test unzip(M, recursive=true)  == ([[1,2,3], [1,2,3]], [[1,1,1], [2,2,2]])


    @vars x y z real=true

    f(x,y,z) = x*y*z
    f(v) = f(v...)
    @test gradient(f(x,y,z), [x,y,z]) == [y*z, x*z, x*y]
    @test ∇(f)([1,2,3]) ≈  [2*3, 1*3, 1*2]

    F(x,y,z) = [x,y,z]
    F(v) = F(v...)
    @test divergence(F(x,y,z), [x,y,z]) == 3
    @test  (∇⋅F)([1,0,0]) ≈ 3


    F(x,y,z) = [-y, x, 0]
    F(v) = F(v...)
    @test curl(F(x,y,z), [x,y,z]) == [0,0,2]
    @test all((∇ × F)([1,2,3]) .≈ [0.0, 0.0, 2.0])

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

    @test quadgk(sin, 0, pi)[1]  ≈ 2
    @test hcubature(xy -> sin(xy[1])*sin(xy[2]), (0,0), (pi,pi))[1] ≈ 4
    @test riemann(sin, 0, pi, 10_000)  ≈ 2
    @test fubini((x,y) -> 1, (x->-sqrt(1-x^2), x->sqrt(1-x^2)), (-1,1)) ≈ pi


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
        plot_parametric_surface(Phi, xlims=(0, 1), ylims=(0,2pi))

        V(x,y) = [x, x-y]
        vectorfieldplot(V, xlims=(-2,2))#, nx=8, ny=8) # ylim=(-5,5) plotly not happy, gr is

        V(x,y,z) = [-y, x, 0]
        vectorfieldplot3d(V, nx=4, ny=4, nz=3)

        a,b = 1, 3
        F(x,y,z) =  (x^2+((1+b)*y)^2+z^2-1)^3-x^2*z^3-a*y^2*z^3
        CalculusWithJulia.plot_implicit_surface(F, xlims=(-2,2),ylims=(-1,1),zlims=(-1,2))
    end

end
