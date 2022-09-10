## Deprecate this!!!
## This is in the wrong place. If anything, it belongs in the
## common_code.qmd part of quarto


module WeaveSupport

import Base64: base64encode
using Random

#using Weave

using Mustache
import Markdown
using JSON
using Reexport
@reexport using LaTeXStrings
@reexport using QuizQuestions

using Pkg

include("formatting.jl")
include("bootstrap.jl")
@reexport using QuizQuestions
#include("logo.jl")
#include("toc.jl")



macro q_str(x)
    "`$x`"
end

export mmd
export @q_str
export ImageFile, Verbatim, Invisible, Outputonly, HTMLonly, JSXGraph
export alert, warning, note
export example, popup, table
export gif_to_data
#export numericq, radioq, booleanq, yesnoq, shortq, longq, multiq


end # module
