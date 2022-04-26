using CalculusWithJulia

# hacky build script
using Pkg
Pkg.test("CalculusWithJulia", test_args=["folder=:precalc"])
Pkg.test("CalculusWithJulia", test_args=["folder=:limits"])
Pkg.test("CalculusWithJulia", test_args=["folder=:derivatives"])
Pkg.test("CalculusWithJulia", test_args=["folder=:integrals"])
Pkg.test("CalculusWithJulia", test_args=["folder=:ODEs"])
Pkg.test("CalculusWithJulia", test_args=["folder=:differentiable_vector_calculus"])
Pkg.test("CalculusWithJulia", test_args=["folder=:integral_vector_calculus"])


Pkg.test("CalculusWithJulia", test_args=["folder=:alternatives",
                                         "target=:weave_html"])
Pkg.test("CalculusWithJulia", test_args=["folder=:misc",
                                         "target=:weave_html"])

#=
using Pkg
Pkg.test("CalculusWithJulia", test_args=["folder=:all"])
=#
#CalculusWithJulia.WeaveSupport.weave_all(force=false, build_list=(:html,))
# move files to "/build"
builddir = joinpath(@__DIR__, "build")
htmldir = joinpath(@__DIR__, "..", "html")
isdir(builddir) || mkdir(builddir)
for d in readdir(htmldir)
    dir = joinpath(htmldir, d)
    if isdir(dir)
        cp(dir, joinpath(builddir, basename(dir)), force=true)
    end
end
toc = joinpath(htmldir, "misc", "toc.html")
cp(toc, joinpath(builddir,"index.html"), force=true)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

import Documenter
Documenter.deploydocs(
    repo = "github.com/CalculusWithJulia/CalculusWithJulia.jl.git""
#
