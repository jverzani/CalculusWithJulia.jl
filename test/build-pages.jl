# build_pages

include("weave-support.jl")
include("markdown-to-pluto.jl")

function build_pages(folder=nothing, file=nothing, target=:html, force=false)
    @show folder, file, target, force
    build_list = (target, )
    if folder != nothing && file !=nothing
        weave_file(folder, file * ".jmd", build_list=build_list, force=force)
    elseif folder != nothing
        weave_folder(folder, build_list = build_list, force=force)
    elseif force
        weave_all(; build_list=build_list, force=true)
    end
end
