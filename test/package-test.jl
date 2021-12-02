# Test the package utilities
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
