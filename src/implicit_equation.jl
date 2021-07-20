## Makie wrapper for implicit equations
## How to integrate in....
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

#==

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

==#
