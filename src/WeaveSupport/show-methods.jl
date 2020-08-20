## Show method


## WeaveTpl
function Base.show(io::IO, ::MIME"text/html", x::ImageFile)
    write(io, gif_to_data(x.f, x.caption))
end

function Base.show(io::IO, ::MIME"text/latex", x::ImageFile)
    fname = x.f
    if occursin(r"gif$", fname)
        println(io, "XXX can not include `.gif` file here")
    else
        print(io, """
\\begin{figure}
\\caption{$(x.caption)}
\\includegraphics[width=0.6\\textwidth]{$(x.f)}
\\end{figure}
""")
    end
end


# Show SymPy
## Type piracy
function Base.show(io::IO, ::MIME"text/html", x::T) where {T <: SymPy.SymbolicObject}
    write(io, "<div class=\"well well-sm\">")
    show(io, "text/latex", x)
    write(io, "</div>")
end

function Base.show(io::IO, ::MIME"text/html", x::Array{T}) where {T <: SymPy.SymbolicObject}
    write(io, "<div class=\"well well-sm\">")
    show(io, "text/latex", x)
    write(io, "</div>")
end
