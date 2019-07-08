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
    @test hquadrature(x -> 2, (0.0, 0.0), (2pi, 1pi))  ≈ 2 * (2pi) * (1pi)

    ## SymPy
    @test limit(x -> sin(x)/x, 0) == 1
    @test integrate(sin,  0, pi) == 2



end



@testset "multidimenstional" begin

    x = [[1,2,3], [4,5,6]]
    @test unzip(x)[1] == [1, 4]
    @test unzip(x)[2] == [2, 5]
    @test unzip(x)[3] == [3, 6]

    xs = [1,2,3]
    ys = [1,2]
    M = ((x,y) -> (x,y)).(xs, ys')
    @test unzip(M)  == ([[1,2,3], [1,2,3]], [[1,1,1], [2,2,2]])

    @test uvec([2,2]) == 1/sqrt(2) * [1,1]

    @vars x y z
    F(x,y,z) = [x,y,z]
    F(v) = F(v...)
    @test divergence(F, [x,y,z]) == 3
    @test  (∇⋅F)([1,0,0]) ≈ 3

    f(x,y,z) = x*y*z
    f(v) = f(v...)
    @test gradient(f(x,y,z), [x,y,z]) == [y*z, x*z, x*y]
    @test ∇(f)([1,2,3]) ≈  [2*3, 1*3, 1*2]

    F(x,y,z) = [-y, x, 0]
    F(v) = F(v...)
    @test curl(F(x,y,z), [x,y,z]) == [0,0,1]
    @test (∇ × F)([1,2,3]) .≈ [0, 0, 1]

end


@testset "derivatives" begin
    f(x) = x^2
    @test secant(f, 0, 1)(1/2) ≈ 1/2
    @test tangent(f, 1/2)(1) ≈ f(1/2) + 2*(1/2)*(1-1/2)

    @test f'(1) ≈ 2
    @test f''(1)  ≈ 2
    @test iszero(f'''(1))

    r(t) = [t, t^2, t^3]
    @test r'(1) .≈ [1, 2*1, 3*1^2]
end

@testset "integration" begin

    @test riemann(sin, 0, pi, 10_000)  ≈ 2
    @test fubini((x,y) -> 1, (x->-sqrt(1-x^2), x->sqrt(1-x^2)), (-1,1)) ≈ pi


end

@testset "plot-utils" begin

    if isinteractive()

        f(x) = 1/x

        trimplot(f, -1, 1)

        plotif(f, f, -1, 1)
        plotif(f, f', -1, 1)

        signchart(sin, 0, 4pi)

        newton_vis(log, 1/2)

        r(t) = [sin(t), cos(t)]
        ts = range(0, stop=pi/2, length=100)
        plot(unzip(r.(ts))...)
        arrow!(r(pi/4), r'(pi/4))

        V(x,y) = [x, x-y]
        plot()
        vectorfieldplot!(V)

    end

end
