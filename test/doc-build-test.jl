# test the doc-build

using CalculusWithJulia
using Pluto

CalculusWithJulia.WeaveSupport.weave_all(; build_list=(:html,), force=false)
