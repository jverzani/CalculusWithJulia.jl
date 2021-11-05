## formatting conveniences
abstract type OutputOnlyType end

"markdown can leave wrapping p's"
function strip_p(txt)
    if occursin(r"^<p>", txt)
        txt = replace(replace(txt, r"^<p>" => ""), r"</p>$" => "")
    end
    txt
end

function md(x)
    out = sprint(io ->  show(io, "text/html", Markdown.parse(string(x))))
    strip_p(out)
end

markdown_to_latex(x) = sprint(io -> show(io, "text/latex", Markdown.parse(x)))

"""
Hide output and input, but execute cell.

Examples
```
2 + 2
Invisible()
```
"""
mutable struct Invisible <: OutputOnlyType
end

"""
Show output as HTML

Examples
```
HTMLoutput("<em>em</em>")
```

"""
mutable struct HTMLoutput <: OutputOnlyType
    x
end
Base.show(io::IO, ::MIME"text/plain", x::HTMLoutput) = print(io, """<div>$(x.x)</div>""")
Base.show(io::IO, ::MIME"text/html", x::HTMLoutput) = print(io, x.x)
Base.show(io::IO, ::MIME"text/latex", x::HTMLoutput) = println(io, "...unable to display raw html...")



"""
Show as input, but do not execute.
Examples:
```
Verbatim("This will print, but not be executed")
```
"""
mutable struct Verbatim <: OutputOnlyType
    x
end
Base.show(io::IO, ::MIME"text/plain", x::Verbatim) = print(io, """<pre class="sourceCode julia">$(x.x)</pre>""")
Base.show(io::IO, ::MIME"text/html", x::Verbatim) = print(io, x.x)
Base.show(io::IO, ::MIME"text/latex", x::Verbatim) = print(io, "\verb@$(markdown_to_latex(x.x))@")


"""
Hide input, but show output

Examples
```
x = 2 + 2
Outputonly(x)
```
"""
mutable struct Outputonly
    x
end


"""
    JSXGraph(f; [ID], [CLASS], [WIDTH], [HEIGHT]

Show jsxgraph commands contained in file `f`.
"""
function JSXGraph(f, caption="JSXGraph Demo"; ID="jsxgraph", CLASS="jsxgraph", WIDTH=600, HEIGHT=400)
    JSXGRAPH(read(f, String),
             markdown(caption),
             ID, CLASS, WIDTH, HEIGHT)
end

mutable struct JSXGRAPH  <: OutputOnlyType
    FILE_CONTENTS
    CAPTION
    ID
    CLASS
    WIDTH
    HEIGHT
end

#<div class="card">
#   <div class="card-header">{{{CAPTION}}}</div>

#  <div class="card-body">
#    <div id="{{ID}}" class='{{CLASS}}' style='width:{{WIDTH}}px; height:{{HEIGHT}}px'></div>
#  </div>
#</div>


## XXX Put in centered
jsxgraph_tpl = Mustache.mt"""
<div class="d-flex justify-content-center">
<div class="card border-light mx-3 px-3 my-3 py-3" style="width:{{WIDTH}}px">
   <div id="{{ID}}" class='{{CLASS}}' style='width:{{WIDTH}}px; height:{{HEIGHT}}px'></div>
  <div class="card-footer text-muted">
    <span class="card-text">
      <small class="text-muted">
      {{{CAPTION}}}
      </small>
    </span>
  </div>
</div>
</div>


<script src='https://cdnjs.cloudflare.com/ajax/libs/jsxgraph/1.2.2/jsxgraphcore.js' type='text/javascript'>
</script>
<script src='https://cdnjs.cloudflare.com/ajax/libs/jsxgraph/1.2.2/geogebra.min.js' type='text/javascript'>
</script>

<script>
{{{FILE_CONTENTS}}}
</script>

"""

Base.show(io::IO, ::MIME"text/html", x::JSXGRAPH) = Mustache.render(io, jsxgraph_tpl, x)
Base.show(io::IO, x::JSXGRAPH) = print(io, "JSXGraph unavailable")

## Bootstrap things
abstract type Bootstrap <: OutputOnlyType end
Base.show(io::IO, ::MIME"text/html", x::Bootstrap) = print(io, """$(x.x)""")
Base.show(io::IO, ::MIME"text/latex", x::Bootstrap) = print(io, """XXX BOOTSTRAP $(markdown_to_latex(x.x))""")

mutable struct Alert <: Bootstrap
    x
    d::Dict
end

### An alert
function alert(txt; kwargs...)
    d = Dict()
    for (k,v) in kwargs
        d[k] = v
    end
    Alert(txt, d)
end

warning(txt; kwargs...) = alert(txt; class="warning", kwargs...)
note(txt; kwargs...) = alert(txt; class="info", kwargs...)


function Base.show(io::IO, ::MIME"text/html", x::Alert)
    cls = haskey(x.d,:class) ? x.d[:class] : "success"
    txt = sprint(io -> show(io, "text/html", Markdown.parse(x.x)))
    tpl = """<div class="alert alert-$cls" role="alert">$txt</div>"""

    print(io, tpl)
end

function Base.show(io::IO, ::MIME"text/latex", x::Alert)
    println(io, """
\\begin{mdframed}
$(markdown_to_latex(x.x))
\\end{mdframed}
""")
end




mutable struct Example <: Bootstrap
    x
    d::Dict
end

## use nm="name" to pass along name
function example(txt; kwargs...)
 d = Dict()
    for (k,v) in kwargs
        d[k] = v
    end
    Example(txt, d)
end


function Base.show(io::IO, ::MIME"text/html", x::Example)
    nm = haskey(x.d,:nm) ? " <small>$(x.d[:nm])</small>" : ""
    txt = sprint(io -> show(io, "text/html", Markdown.parse(x.x)))
    tpl = """
<div class="alert alert-danger" role="alert">

<i class="bi bi-snow"></i>

<span class="text-uppercase">example:</span>$nm$txt

</div>

"""

    print(io, tpl)
end

function Base.show(io::IO, ::MIME"text/latex", x::Example)
    println(io, """Example $(markdown_to_latex(x.x))""")
end


mutable struct Popup <: Bootstrap
    x
    title
    icon
    label
end

"""

Create a button to toggle the display of more detail.

Can modify text, title, icon and label (for the button)

The text, title, and label can use Markdown.

LaTeX markup does not work, as MathJax rendering is not supported in the popup.

"""
popup(x; title=" ", icon="star", label="click me") = Popup(x, title, icon, label)


popup_html_tpl = mt"""
<button type='button'
 class='btn btn btn-secondary'
 data-bs-toggle='popover'
 title='{{{title}}}'
 data-bs-placement='right'
 data-bs-content='{{{body}}}'
>
<i class='bi bi-{{icon}}'></i>
{{{button_label}}}
</button>
"""
# issue with formatted content
function Base.show(io::IO, ::MIME"text/html", x::Popup)
    d = Dict()
    d["title"] = x.title #sprint(io -> show(io, "text/html", Markdown.parse(x.title)))
    d["icon"] = x.icon
    label = x.label #sprint(io -> show(io, "text/html", Markdown.parse(x.label)))
    d["button_label"] = label
    d["body"] = x.x #sprint(io -> show(io, "text/html", Markdown.parse(x.x)))
    Mustache.render(io, popup_html_tpl, d)
end

function Base.show(io::IO, ::MIME"text/latex", x::Popup)
    println(io, """
\\begin{quotation}
$(markdown_to_latex(x.x))
\\end{quotation}
""")
end

"""

Way to convert rectangular gird of values into a table

"""
mutable struct Table <: Bootstrap
    x
end
table(x) = Table(x)

table_html_tpl=mt"""

<div class="table-responsive">
<table class="table table-hover">
{{{:nms}}}
{{{:body}}}
</table>
</div>

"""


function Base.show(io::IO, ::MIME"text/html", x::Table)
    vals = Base.invokelatest(names, x.x)
    d = Dict()
    d[:nms] = "<tr><th>$(join(map(string, vals), "</th><th>"))</th></tr>\n"
    bdy = ""
    m,n = Base.invokelatest(size, x.x)
    for i in 1:m
        bdy = bdy * "<tr>"
        for j in 1:n
            val = Base.invokelatest(getindex, x.x, i, j)
            if ismissing(val)
                val = "."
            end
            bdy = bdy * "<td>$(md(val))</td>"
        end
        bdy = bdy * "</tr>\n"
    end
    d[:body] = bdy
    Mustache.render(io, table_html_tpl, d)
end

function df_to_table(df, label="label", caption="caption")
    nc = size(df, 2)
    perc = string(round(1/nc, digits=2))
    fmt = "l" * repeat("p{$perc\\textwidth}", nc-1)
    header = join(string.(names(df)), " & ")
    row = join(["{{{:$x}}}" for x in map(string, names(df))], " & ")

tpl="""
\\begin{table}[!ht]
  \\centering
  \\begin{tabular}{$fmt}
  $header\\\\
  \\midrule\\\\
{{#:DF}}    $row\\\\
{{/:DF}}
  \\bottomrule
  \\end{tabular}
  \\label{tab:$label}

\\end{table}
"""

    Mustache.render(tpl, DF=df)
end

function Base.show(io::IO, ::MIME"text/latex", x::Table)
    d = markdown_to_latex.(x.x)
    println(io, df_to_table(d))
end



mutable struct NamedTable <: Bootstrap
data
rownames
colnames
end

function Base.show(io::IO, ::MIME"text/html", x::NamedTable)
    vals = x.data
    cnames = x.colnames
    rnames = x.rownames
    d = Dict()
    d[:nms] = "<tr><th></th><th>$(join(map(string, cnames), "</th><th>"))</th></tr>\n"
    m,n = Base.invokelatest(size, x.data)
    buf = IOBuffer()
    for i in 1:m
        print(buf, "<tr><td>", rnames[i],"</td>")
        for j in 1:n
            val = Base.invokelatest(getindex, x.data, i, j)
            print(buf, "<td>", md(val), "</td>")
        end
        println(buf, "</tr>")
    end
    d[:body] = String(take!(buf))
    Mustache.render(io, table_html_tpl, d)
end

function Base.show(io::IO, ::MIME"text/latex", x::NamedTable)
    d = markdown_to_latex.(x.x)
    println(io, df_to_table(d))
end


# show footer via
#=
```julia; echo=false
CalculusWithJulia.WeaveSupport.footer(@__FILE__, @__DIR__)
```
=#
struct Footer
    f
    d
end

# compute from URL
function previous_current_next(foot::Footer)
    f₀ = Symbol(last(split(foot.f, "/"))[1:end-4])
    d₀ = Symbol(split(foot.d, "/")[end])

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
    Mustache.render(io, footer_html_tpl, previous_current_next(x))
end

# add suggest edit
# <div class="container d-flex justify-content-end">
#==
==#
footer_html_tpl = """
<div class="card" style="">
  <div class="card-header float-end text-muted">
    <span class="text-muted  float-end align-middle">

<a href="{{{:prev_url}}}"
data-bs-toggle="tooltip"
data-bs-placement="top"
title="Previous section"
aria-label="Previous section"
class="bi bi-arrow-left-circle-fill">
</a>

&nbsp;

<a href="{{{:next_url}}}"
data-bs-toggle="tooltip"
data-bs-placement="top"
title="Next section"
aria-label="Next section"
class="bi bi-arrow-right-circle-fill">
</a>

&nbsp;

<a href="{{{:suggest_edit_url}}}"
data-bs-toggle="tooltip"
data-bs-placement="top"
title="Suggest an edit"
aria-label="Suggest an edit"
class="bi bi-pencil-square">
</a>

&nbsp;

<a href="{{{:toc_url}}}"
data-bs-toggle="tooltip"
data-bs-placement="top"
title="Table of contents"
aria-label="Table of contents"
class="bi bi-card-list">
</a>

    </span>
  </div>
</div>
"""
