using Documenter
using CalculusWithJulia

makedocs(
    sitename="Calculus with Julia",
    format = Documenter.HTML(),
    modules = [CalculusWithJulia],
    warnonly = Documenter.except(:autodocs_block)
)


# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

deploydocs(
    repo = "github.com/jverzani/CalculusWithJulia.jl.git"
)
