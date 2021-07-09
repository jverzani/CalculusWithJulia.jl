"""
This tries to add questions to the markdown files

The rendering of the questions depends on the output:

* html: make self-grading questions using JavaScript
* latex: hide the questions
"""
nothing

import Base: show

abstract type Question end


MaybeString = Union{String, AbstractString, Nothing}

mutable struct Numericq <: Question
    val::Real
    tol::Real
    reminder
    answer_text::MaybeString
    m::Real
    M::Real
    units
    hint
end

mutable struct Radioq <: Question
    choices::Vector
    answer::Int
    reminder
    answer_text::MaybeString
    values
    labels
    hint
    inline::Bool

end


mutable struct Multiq <: Question
    choices::Vector
    answer::Vector{Int}
    reminder::AbstractString
    answer_text::MaybeString
    values
    labels
    answers
    hint
    inline::Bool
end

mutable struct Shortq <: Question
    answer
    reminder::AbstractString
    answer_text::MaybeString
    hint
end

mutable struct Longq <: Question
    reminder::AbstractString
    answer_text::MaybeString
    hint
    rows::Int
    cols::Int
end

"""
A numeric question graded with a tolerance

Arguments:

* `val::Real` answer

* `tol::Real` tolerance. Answer is right if `|ans - val| <= tol`

* `reminder` a reminder as to what question is, student may see

* `answer_text`: reminder of what answer is, student does not see

* `hint`: a possible hint for the student

* `units`: a string holding the units, if specified.

Returns an object of type `Question`.

Example

```
numericq(10, 1e-3, "what is 5 + 5?", units="An integer")
```
"""
function numericq(val, tol=1e-3, reminder="", args...; hint::AbstractString="", units::AbstractString="")
    answer_text= "[$(round(val-tol,digits=5)), $(round(val+tol,digits=5))]"
    Numericq(val, tol, reminder, answer_text, val-tol, val+tol, units, hint)
end

numericq(val::Int; kwargs...) = numericq(val, 0; kwargs...)

"""
Multiple choice question

Arguments:

* `choices`: vector of choices.

* `answer`: index of correct choice

* `inline::Bool`: hint to render inline (or not) if supported

Example
```
radioq(["beta", L"\beta", "`beta`"], 2, "a reminder", hint="which is the Greek symbol")
```
"""
function radioq(choices, answer, reminder="", answer_text=nothing;  hint::AbstractString="", inline::Bool=(hint!=""),
                keep_order::Bool=false)
    inds = collect(1:length(choices))
    values = copy(inds)
    labels = choices # map(markdown_to_latex,choices) |> x -> map(chomp, x) ##|> x -> join(x, " | ")
    !keep_order && shuffle!(inds)

    Radioq(choices[inds], findfirst(isequal(answer), inds), reminder, answer_text, values, labels[inds], hint, inline)
end

"""
True of false questions:

Example:

```
booleanq(true, "Does it hurt...")
```

"""
function booleanq(ans::Bool, reminder="", answer_text=nothing;labels::Vector=["true", "false"], hint::AbstractString="", inline::Bool=true)
    choices = labels[1:2]
    ans = 2 - ans
    radioq(choices, ans, reminder, answer_text; hint=hint, inline=inline, keep_order=true)
end

"""

Boolean question with `yes` or `no` labels.

Examples: `yesnoq("yes")` or `yesnoq(true)`

"""
yesnoq(ans::AbstractString, args...; kwargs...) = radioq(["Yes", "No"], ans == "yes" ? 1 : 2, args...; keep_order=true, kwargs...)
yesnoq(ans::Bool, args...; kwargs...) = yesnoq(ans ? "yes" : "no", args...;kwargs...)

function multiq(choices, answer, reminder="", answer_text=nothing; hint::AbstractString="", inline::Bool=false)
    values = join(1:length(choices), " | ")
    labels =  map(markdown_to_latex, choices) |> x -> map(chomp, x) |> x -> join(x, " | ")
    answers = join(answer, " | ")
    Multiq(choices, answer, reminder, answer_text,
           values, labels, answers,
           hint,
           inline
           )
end

"""

Short question, has regular expression grading:

Example:

```
shortq("x^2", L"a expression using powers to compute x\\cdot x")
```

Do not use format in answer part. The reminder defaults to an empty string.
"""
function shortq(answer, reminder="", answer_text=nothing;hint::AbstractString="")
    Shortq(answer, reminder, answer_text, hint)
end

"""

Long questions, not graded

Example

```
longq("a reminder", "an answer for the grader to see")
```
"""
function longq(reminder="", answer_text=nothing;hint::AbstractString="", rows=3, cols=60)
    Longq(reminder, answer_text, hint, rows, cols)
end


export numericq, radioq, booleanq, yesnoq, shortq, longq, multiq



## we have different display mechanisms based on the output type

## text/html
html_templates=Dict()


html_templates["Numericq"] = mt"""
<form class="mx-2 my-3" name='WeaveQuestion' data-id='{{ID}}' data-controltype='{{TYPE}}'>
<div class='form-group {{status}}'>
<div class='controls'>
{{{form}}}
{{#hint}}
<span class='help-inline'><i id='{{ID}}_hint' class='icon-gift'></i></span>
<script>$('#{{ID}}_hint').tooltip({title:'{{{hint}}}', html:true, placement:'right'});</script>
{{/hint}}

<div class="form-floating input-group">
<input id="{{ID}}" type="number" class="form-control" placeholder="Numeric answer">
<label for="{{ID}}">Numeric answer</label>
{{#units}}<span class="input-group-addon mx-2">{{{units}}}</span>{{/units}}
</div>

<div id='{{ID}}_message'></div>
</div>
</div>
</form>
<script text='text/javascript'>
$('{{{selector}}}').on('change', function() {
  correct = {{{correct}}};

  if(correct) {
     $('#{{ID}}_message').html('<div class="alert alert-success"><i class="bi bi-hand-thumbs-up-fill"></i>&nbsp;Correct</span></div>');
  } else {
     $('#{{ID}}_message').html('<div class="alert alert-danger"><i class="bi bi-hand-thumbs-down-fill"></i>&nbsp;Incorrect</span></div>');
  }
});
</script>
"""

function show(io::IO, m::MIME"text/html", x::Numericq)
    d = Dict()
    d["ID"] = randstring()
    d["TYPE"] = "numeric"
    d["selector"] = "#" * d["ID"]
    d["status"] = ""
    d["hint"] = ""# x.hint
    d["units"] = x.units
    d["correct"] = "Math.abs(this.value - $(x.val)) <= $(x.tol)"
    out =  Mustache.render(html_templates["Numericq"], d)
    Mustache.render(io, html_templates["Numericq"], d)
end

function show(io::IO, m::MIME"text/latex", x::Numericq)
    println(io, "")
end

html_templates["Radioq"] = mt"""
{{#items}}
<div class="form-check">
  <input class="form-check-input" type="radio" name="radio_{{ID}}" id="radio_{{ID}}_{{value}}" value="{{value}}">
  <label class="form-check-label" for="radio_{{ID}}_{{value}}">
    {{{label}}}
  </label>
</div>
{{/items}}
"""

html_templates["3Radioq"] = mt"""
{{#items}}
<div class="radio">
<label class='radio{{inline}}'>
<input type='radio' name='radio_{{ID}}' value='{{value}}'>
<label class="form-check-label" for="radio_{{ID}}_{{value}}"><span>&nbsp;{{{label}}}</span></label>
</label>
</div>
{{/items}}

"""

html_templates["question_tpl"] = mt"""
<form  class="mx-2 my-3" name="WeaveQuestion" data-id="{{ID}}" data-controltype="{{TYPE}}">
<div class="form-group {{status}}">
{{{form}}}
{{#hint}}
<i class="bi bi-gift-fill"></i>

<!--<script>$("#{{ID}}_hint").tooltip({title:"{{{hint}}}", html:true, placement:"right"});</script>-->
{{/hint}}
<div id="{{ID}}_message"></div>
</div>
</form>
<script text="text/javascript">
{{{script}}}
</script>
"""


html_templates["script_tpl"] = mt"""
$("{{{selector}}}").on("change", function() {
  correct = {{{correct}}};

  if(correct) {
     $("#{{ID}}_message").html("<div class='alert alert-success'><i class='bi bi-hand-thumbs-up-fill'></i>&nbsp;Correct</span></div>");
  } else {
     $("#{{ID}}_message").html("<div class='alert alert-warning'><i class='bi bi-hand-thumbs-down-fill'></i>&nbsp;Incorrect</span></div>");
  }
});
"""

function bestmime(val)
  for mime in ("text/html",  "text/latex", "application/x-latex", "image/svg+xml", "image/png", "text/plain")
    showable(mime, val) && return MIME(Symbol(mime))
  end
  error("Cannot render $val to Markdown.")
end

tohtml(io::IO, x) = show(io, bestmime(x), x)


function markdown(x)
    length(x) == 0 && return("")
    x = Markdown.parse(x)
#    x = sprint(io -> tohtml(io, x))
    x = sprint(io -> Markdown.html(io, x))
    if x[1:3] == "<p>"
        x =x[4:end-5]                  # strip out <p></p>
    end
    x
end


function show(io::IO, m::MIME"text/html", x::Radioq)
    ID = randstring()

    tpl = html_templates["Radioq"]


choices = string.(x.choices)


    items = Dict[]
    ## make items
    for i in 1:length(choices)
        item = Dict("no"=>i,
                "label"=>markdown(choices[i]),#[vcat(1:22,26:end-4)],
                "value"=>i
                )
        push!(items, item)
    end

    script = Mustache.render(html_templates["script_tpl"],
                             Dict("ID"=>ID,
                              "selector"=>"input:radio[name='radio_$ID']",
                              "correct"=>"this.value == $(x.answer)"))

    form = Mustache.render(tpl, Dict("ID"=>ID, "items"=>items,
                                 "inline" => x.inline ? " inline" : ""
                                 ))

    Mustache.render(io, html_templates["question_tpl"],
    Dict("form"=>form, "script"=>script,
         "TYPE"=>"radio",
         "ID"=>ID, "hint"=>markdown(x.hint)))

end

function show(io::IO, m::MIME"text/latex", x::Radioq)
    println(io, "\\begin{enumerate}")
    for choice in x.choices
        print(io, "\\item ")
        print(io, markdown_to_latex(choice))
    end

    println(io, "\\end{enumerate}")
end


function show(io::IO, m::MIME"text/html", x::Question)
     println(io, "<p>Question type $(typeof(x)) is not supported in this format</p>")
end


##
## text/markdown
md_templates=Dict()


md_templates["Radioq"] = mt"""
{{#:items}}
{{{.}}}
{{/:items}}

"""
