using Documenter, CalculusWithJulia

makedocs(sitename="Calculus with Julia")

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

import Documenter
Documenter.deploydocs(
    repo = "github.com/jverzani/CalculusWithJulia.jl"
)
