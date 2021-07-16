# keep up to date with misc/toc.jmd
table_of_contents = [
    :precalc		:calculator;
    :precalc		:variables;
    :precalc		:numbers_types;
    :precalc		:logical_expressions;
    :precalc		:vectors;
    :precalc		:ranges;
    :precalc		:functions;
    :precalc		:plotting;
    :precalc		:transformations;
    :precalc		:inversefunctions;
    :precalc		:polynomial;
    :precalc		:polynomial_roots;
    :precalc		:polynomials_package;
    :precalc		:rational_functions;
    :precalc		:exp_log_functions;
    :precalc		:trig_functions;
    :precalc            :julia_overview;

    :limits		:limits;
    :limits		:limits_extensions;
    :limits		:continuity;
    :limits		:intermediate_value_theorem;

    :derivatives		:derivatives;
    :derivatives		:numeric_derivatives;
    :derivatives		:mean_value_theorem;
    :derivatives		:optimization;
    :derivatives		:first_second_derivatives;
    :derivatives		:curve_sketching;
    :derivatives		:linearization;
    :derivatives		:newtons_method;
    :derivatives		:more_zeros;
    :derivatives		:lhospitals_rule;
    :derivatives		:implicit_differentiation;
    :derivatives		:related_rates;
    :derivatives		:taylor_series_polynomials;

    :integrals		:area;
    :integrals		:ftc;
    :integrals		:substitution;
    :integrals		:integration_by_parts;
    :integrals		:partial_fractions;
    :integrals		:improper_integrals;
    :integrals		:mean_value_theorem;
    :integrals		:area_between_curves;
    :integrals		:center_of_mass;
    :integrals		:volumes_slice;
    :integrals		:arc_length;
    :integrals		:surface_area;

    :ODEs		:odes;
    :ODEs		:euler;
    :ODEs		:solve;

    :differentiable_vector_calculus		:polar_coordinates;
    :differentiable_vector_calculus		:vectors;
    :differentiable_vector_calculus		:vector_valued_functions;
    :differentiable_vector_calculus		:scalar_functions;
    :differentiable_vector_calculus		:scalar_functions_applications;
    :differentiable_vector_calculus		:vector_fields;
    :differentiable_vector_calculus		:plots_plotting;
    :alternatives		:makie_plotting;

    :integral_vector_calculus		:double_triple_integrals;
    :integral_vector_calculus		:line_inegrals;
    :integral_vector_calculus		:div_grad_curl;
    :integral_vector_calculus		:stokes_theorem;
    :integral_vector_calculus		:review;

    :alternatives   :symbolics;
    :misc           :getting_started_with_juila
    :misc           :bibliography;
    :misc           :quick_notes;
    :misc           :julia_interfaces;
    :misc           :calculus_with_juila;
    :misc           :unicode
]
# return :d,:f for previous and next
function prev_next(d,f)
    vals = [df for df ∈ eachrow(table_of_contents)]
    val = [d,f]
    i = findfirst(Ref(val,) .== vals)
    i == nothing && error(val)
    i == 1 && return (prev=nothing, next=vals[2])
    i == length(vals) && return (prev=vals[end-1], next=nothing)
    return (prev=vals[i-1], next=vals[i+1])
end
