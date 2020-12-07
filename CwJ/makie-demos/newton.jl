using AbstractPlotting
using AbstractPlotting.MakieLayout
using GLMakie

using ForwardDiff
D(f) = x -> ForwardDiff.derivative(f, float(x))


function newton(;f=x->x^5 - x - 1, x0=1, a=-1, b=1.5, n = 20)

    descr = """
Illustration of $n iterations in Newton's method. 
The initial point can be adjusted with the mouse to
show sensitivity to initial point.
"""
    
    function add_move!(scene, points, pplot)
        idx = Ref(0); dragstart = Ref(false); startpos = Base.RefValue(Point2f0(0))
        on(events(scene).mousedrag) do drag
            if ispressed(scene, Mouse.left)
                if drag == Mouse.down
                    plot, _idx = mouse_selection(scene)
                    if plot == pplot
                        idx[] = _idx; dragstart[] = true
                        startpos[] = to_world(scene, Point2f0(scene.events.mouseposition[]))
                    end
                elseif drag == Mouse.pressed && dragstart[] && checkbounds(Bool, points[], idx[])
                    pos = to_world(scene, Point2f0(scene.events.mouseposition[]))
                    
                    # we work with components, not vector
                    x,y = pos
                    
                    ptidx = idx[]
                    
                    x = clamp(x, a, b)
                    y = zero(y)
                    points[][idx[]] = [x,y]
                    
                    points[] = points[]
                end
            else
                dragstart[] = false
            end
            return
        end
    end

    start_point = Node(Point2f0[(x0, 0)])
    points = lift(start_point) do x₀
        xs = [x₀[1][1]]
        for i in 1:n
            xᵢ₋₁ = xs[end]
            xᵢ = xᵢ₋₁ - f(xᵢ₋₁) /D(f)(xᵢ₋₁)
            push!(xs, xᵢ)
        end
        xs
    end

    plt_points = lift(points) do pts
        xs = Float64[]
        ys = Float64[]
        for i in 1:length(pts)-1
            pᵢ, pᵢ₊₁ = pts[i], pts[i+1]
            append!(xs, [pᵢ, pᵢ, pᵢ₊₁])
            append!(ys, [0, f(pᵢ), 0])
        end
        (xs, ys)
    end

    # where we lay our scene:
    scene, layout = layoutscene()
    layout.halign = :left
    layout.valign = :top


    p = layout[1, 1:2] = LScene(scene)
    layout[2,1:2] = LText(scene, chomp(descr))
    rowsize!(layout, 1, Auto(1))
    colsize!(layout, 1, Auto(1))
    colsize!(layout, 2, Auto(1))

    lines!(p.scene, a..b, f, linewidth=5, color=:blue)
    lines!(p.scene, a..b, zero, color=:red)
    lines!(p.scene, plt_points, color=:black, linewidth=2)
    scatter!(p.scene, start_point, color=:red)

    add_move!(p.scene, start_point, p.scene[end])

    scene
end

