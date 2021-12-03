# build_pages

include("weave-support.jl")
include("markdown-to-pluto.jl")

# what to build
function build_pages(folder=nothing, file=nothing, target=:html, force=false)
    build_list = (target, )
    if folder != nothing && file !=nothing
        weave_file(folder, file * ".jmd", build_list=build_list, force=force)
    elseif folder != nothing
        if folder == "all"
            weave_all(; build_list=build_list, force=true)
        else
            weave_folder(folder, build_list = build_list, force=force)
        end
    elseif force
        weave_all(; build_list=build_list, force=true)
    end
end
