using CalculusWithJulia

CalculusWithJulia.WeaveSupport.weave_all(force=false)
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
#Documenter.deploydocs(repo = "github.com/CalculusWithJulia/CalculusWithJulia.jl.git")
#=deploydocs(
    repo = "<repository url>"
)=#
