gradient(ex::SymPy.Sym, vars::AbstractArray=SymPy.free_symbols(ex)) = diff.(ex, [vars...])
divergence(F::Vector{SymPy.Sym}, vars=SymPy.free_symbols(F)) = sum(diff.(F, vars))
curl(F::Vector{SymPy.Sym}, vars=SymPy.free_symbols(F)) = curl(F.jacobian(vars))
