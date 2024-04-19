module CalculusWithJuliaSymPyCoreExt

import CalculusWithJulia: gradient, divergence, curl
import SymPyCore: Sym, free_symbols

gradient(ex::Sym, vars::AbstractArray=free_symbols(ex)) =
    diff.(ex, [vars...])

divergence(F::Vector{<:Sym}, vars=free_symbols(F)) =
    sum(diff.(F, vars))

curl(F::Vector{<:Sym}, vars=free_symbols(F)) =
    curl(F.jacobian(vars))


end
