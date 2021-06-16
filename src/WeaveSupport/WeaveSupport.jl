module WeaveSupport
## Modified from
## https://github.com/SciML/SciMLTutorials.jl/blob/master/src/SciMLTutorials.jl

import Base64: base64encode
using Random

using Weave

using Mustache
import Markdown
using JSON
using Reexport
@reexport using LaTeXStrings
#using SymPy
#function Base.show(io::IO, ::MIME"text/latex", x::SymPy.SymbolicObject)
#    print(io, SymPy.as_markdown(sympy.latex(x)))
#end


using Pkg

include("formatting.jl")
include("bootstrap.jl")
include("questions.jl")
include("show-methods.jl")
include("toc.jl")

#import Plots
# just show body, not standalone
#function Plots._show(io::IO, ::MIME"text/html", plt::Plots.Plot{Plots.PlotlyBackend})
#    write(io, Plots.html_body(plt))
#end


## we have jmd files that convert to html files
## using a specialized template

const repo_directory = joinpath(@__DIR__,"..", "..")
const cssfile = joinpath(@__DIR__, "..", "..", "templates", "skeleton_css.css")
const htmlfile = joinpath(@__DIR__,"..", "..", "templates", "bootstrap.tpl")
const latexfile = joinpath(@__DIR__, "..", "..", "templates", "julia_tex.tpl")

function weave_file(folder, file; build_list=(:script,:html,:pdf,:github,:notebook), force=false, kwargs...)


    jmddir = joinpath(repo_directory,"CwJ",folder)
    tmp = joinpath(jmddir, file)
    bnm = replace(basename(tmp), r".jmd$" => "")


    if !force
        testfile = joinpath(repo_directory, "html", folder, bnm*".html")
        if isfile(testfile) && (mtime(testfile) >= mtime(tmp))
            return
        end
    end

    Pkg.activate(dirname(tmp))
    Pkg.instantiate()
    args = Dict{Symbol,String}(:folder=>folder,:file=>file)

    if :script ∈ build_list
        println("Building Script")
        dir = joinpath(repo_directory,"script",folder)
        isdir(dir) || mkpath(dir)
        args[:doctype] = "script"
        tangle(tmp;out_path=dir)
    end

    if :html ∈ build_list
        println("Building HTML")
        dir = joinpath(repo_directory,"html",folder)
        isdir(dir) || mkpath(dir)

        figdir = joinpath(jmddir,"figures")
        htmlfigdir = joinpath(dir, "figures")

        if isdir(figdir)
            isdir(htmlfigdir) && rm(htmlfigdir, recursive=true)
            cp(figdir, htmlfigdir)
        end

        Weave.set_chunk_defaults!(:wrap=>false)
        args[:doctype] = "html"
        #weave(tmp,doctype = "md2html",out_path=dir,args=args; fig_ext=".svg", css=cssfile, kwargs...)
        weave(tmp,doctype = "md2html", out_path=dir,args=args; fig_ext=".svg",
              template=htmlfile,
              fig_path=tempdir(),
              kwargs...)

        # clean up
        isdir(htmlfigdir) && rm(htmlfigdir, recursive=true)

    end

    if :pdf ∈ build_list

        eval(quote using Tectonic end) # load Tectonic; wierd testing error

        println("Building PDF")
        dir = joinpath(repo_directory,"pdf",folder)
        isdir(dir) || mkpath(dir)

        fig_path = "_figures_" * bnm
        figdir = joinpath(jmddir,"figures")
        texfigdir = joinpath(dir, "figures")

        if isdir(figdir)
            isdir(texfigdir) && rm(texfigdir, recursive=true)
            cp(figdir, texfigdir)
        end

        args[:doctype] = "pdf"
        try
            weave(tmp,doctype="md2tex",out_path=dir,args=args;
                  template=latexfile,
                  fig_path=fig_path,
                  kwargs...)

            texfile = joinpath(dir, bnm * ".tex")
            Base.invokelatest(Tectonic.tectonic, bin -> run(`$bin $texfile`))


            # clean up
            for ext in (".tex",)
                f = joinpath(dir, bnm * ext)
                isfile(f) && rm(f)
            end

        catch ex
            @warn "PDF generation failed" exception=(ex, catch_backtrace())

        end

        isdir(texfigdir) && rm(texfigdir, recursive=true)
        isdir(joinpath(dir,fig_path)) && rm(joinpath(dir,fig_path), recursive=true)
        for ext in (".aux", ".log", ".out")
            f = joinpath(dir, bnm * ext)
            isfile(f) && rm(f)
        end

    end

    if :github ∈ build_list
        println("Building Github Markdown")
        dir = joinpath(repo_directory,"markdown",folder)
        isdir(dir) || mkpath(dir)
        args[:doctype] = "github"
        weave(tmp,doctype = "github",out_path=dir, args=args;
              fig_path=tempdir(),
              kwargs...)
    end

    if :notebook ∈ build_list
        println("Building Notebook")
        dir = joinpath(repo_directory,"notebook",folder)
        isdir(dir) || mkpath(dir)
        args[:doctype] = "notebook"
        Weave.convert_doc(tmp,joinpath(dir,file[1:end-4]*".ipynb"))
    end
end

"""
    weave_all(; force=false, build_list=(:script,:html,:pdf,:github,:notebook))

Run `weave` on all source files.

* `force`: by default, only run `weave` on files with `html` file older than the source file in `CwJ`
* `build_list`: list of output types to be built. The default is all types

The files will be built as subdirectories in the package directory. This is returned by `pathof(CalculusWithJulia)`.

"""
function weave_all(;force=false, build_list=(:script,:html,:pdf,:github,:notebook))
    for folder in readdir(joinpath(repo_directory,"CwJ"))
        folder == "test.jmd" && continue
        weave_folder(folder; force=force, build_list=build_list)
    end
end

function weave_folder(folder; force=false, build_list=(:script,:html,:pdf,:github,:notebook))
    !isnothing(match(r"\.ico$", folder)) && return nothing
    for file in readdir(joinpath(repo_directory,"CwJ",folder))
        !occursin(r".jmd$", basename(file)) && continue
        println("Building $(joinpath(folder,file))")
        try
            weave_file(folder,file; force=force, build_list=build_list)
        catch
        end
    end
end





macro q_str(x)
    "`$x`"
end

export mmd
export @q_str
export ImageFile, Verbatim, Invisible, Outputonly, HTMLonly
export alert, warning, note
export example, popup, table
export gif_to_data
export numericq, radioq, booleanq, yesnoq, shortq, longq, multiq


end # module
