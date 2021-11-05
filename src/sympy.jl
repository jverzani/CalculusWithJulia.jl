using SymPy

# Show SymPy
## Type piracy; messes with Pluto!
# function Base.show(io::IO, ::MIME"text/html", x::T) where {T <: SymPy.SymbolicObject}
#     #write(io, "<div class=\"well well-sm\">")
#     write(io, "<div class=\"output\">")
#     show(io, "text/latex", x)
#     write(io, "</div>")
# end

# function Base.show(io::IO, ::MIME"text/html", x::Array{T}) where {T <: SymPy.SymbolicObject}
#     #write(io, "<div class=\"well well-sm\">")
#     write(io, "<div class=\"output\">")
#     show(io, "text/latex", x)
#     write(io, "</div>")
#end

## --------

gradient(ex::SymPy.Sym, vars::AbstractArray=free_symbols(ex)) = diff.(ex, [vars...])
divergence(F::Vector{Sym}, vars=free_symbols(F)) = sum(diff.(F, vars))
curl(F::Vector{Sym}, vars=free_symbols(F)) = curl(F.jacobian(vars))
