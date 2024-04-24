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


end

@testset "test functions" begin

    f(x) = sin(x)
    c = pi/4
    fn = tangent(f, c)
    @test fn(1)  ≈ f(c) + f'(c)*(1 - c)

    fn = secant(f, pi/6, pi/3)
    @test fn(pi/4) <= f(pi/4)

    out = lim(x -> sin(x)/x, 0)
    @test_broken out[end, 2]  ≈ 1 # an iterator now


    out = sign_chart(x -> (x-1)*(x-2)/(x-3), 0, 4)
    @test all([o[1] for o ∈ out] .≈[1,2,3])

    @test riemann(sin, 0, pi, 10_000)  ≈ 2
end


@testset "2d" begin

    x = [[1,2,3], [4,5,6]]
    @test unzip(x)[1] == [1, 4]
    @test unzip(x)[2] == [2, 5]
    @test unzip(x)[3] == [3, 6]

    @test length(unzip(x -> x, 0, 1)[1])  <= 50 # 21
    @test length(unzip(x-> sin(10pi*x), 0, 1)[1]) >= 50 # 233

    @test uvec([2,2]) == 1/sqrt(2) * [1,1]

end
