# test the doc-build

using CalculusWithJulia
CalculusWithJulia.WeaveSupport.weave_all(; build_list=(:html,), force=false)
