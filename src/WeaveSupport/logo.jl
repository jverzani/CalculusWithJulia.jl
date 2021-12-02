## Logo and footer
struct Logo
    width::Int
end
Logo() = Logo(120)

const logo_url = "https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png"

function Base.show(io::IO, ::MIME"text/html", l::Logo)
    show(io, "text/html", Markdown.HTML("""
<img src="$(logo_url)" alt="Calculus with Julia" width="$(l.width)" />
"""))
end



header_cmd =  """
HTML(\"\"\"
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="$(logo_url)" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
\"\"\")
"""



"""
    Footer(:file, :directory)

Footer object for HTML display
"""
struct Footer
    f
    d
end

# create footer from basename of file, folder name
function footer_cmd(bnm, folder)
    f = Footer(Symbol(bnm), Symbol(folder))
    out = sprint(io -> show(io, "text/html", f))
    "HTML(\"\"\"$(out)\"\"\")"
end


# compute from URL
file_dir(f::Symbol,d::Symbol) = (f,d)
function file_dir(f, d)
    f = Symbol(last(split(foot.f, "/"))[1:end-4])
    d = Symbol(split(foot.d, "/")[end])
    f,d
end

function previous_current_next(foot::Footer)
    f₀, d₀ = file_dir(foot.f, foot.d)

    toc_url = "../misc/toc.html"
    suggest_url = "https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/$(d₀)/$(f₀).jmd"

    prev_url = "https://calculuswithjulia.github.io"
    next_url = "https://calculuswithjulia.github.io"

    prev,nxt = prev_next(d₀, f₀)

    if prev != nothing
        d,f = prev
        prev_url = "../$(d)/$(f).html"
    end

    if nxt != nothing
        d,f = nxt
        next_url = "../$(d)/$(f).html"
    end

    (base_url="https://calculuswithjulia.github.io",
     toc_url=toc_url,
     prev_url=prev_url,
     next_url = next_url,
     suggest_edit_url = suggest_url
     )
end

function Base.show(io::IO, ::MIME"text/html", x::Footer)
    #Mustache.render(io, footer_html_tpl, previous_current_next(x))

    home, toc, prev, next, suggest = previous_current_next(x)
    show(io, "text/html", Markdown.parse("""
>  [◅ previous]($prev)  [▻  next]($next)  [⌂ table of contents]($toc)  [✏ suggest an edit]($suggest)
"""))
end

# add suggest edit
# <div class="container d-flex justify-content-end">
#==
==#
footer_html_tpl = """
<div class="card admonition info" style="">
  <div class="card-header float-end text-muted">
    <span class="text-muted  float-end align-middle">

<a href="{{{:prev_url}}}"
data-bs-toggle="tooltip"
data-bs-placement="top"
aria-label="Previous section"
class="bi bi-arrow-left-circle-fill">
Previous section
</a>

&nbsp;

<a href="{{{:next_url}}}"
data-bs-toggle="tooltip"
data-bs-placement="top"
aria-label="Next section"
class="bi bi-arrow-right-circle-fill">
Next section
</a>

&nbsp;

<a href="{{{:suggest_edit_url}}}"
data-bs-toggle="tooltip"
data-bs-placement="top"
aria-label="Suggest an edit"
class="bi bi-pencil-square">
Suggest an edit
</a>

&nbsp;

<a href="{{{:toc_url}}}"
data-bs-toggle="tooltip"
data-bs-placement="top"
aria-label="Table of contents"
class="bi bi-card-list">
Table of contents
</a>

    </span>
  </div>
</div>
"""
