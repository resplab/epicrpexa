#' Run the EPIC-R COPD policy simulation
#'
#' Wraps `epicR::simulate()` behind the universal single-`model_input`
#' interface. `model_input` is a named list whose elements are the arguments of
#' `epicR::simulate()` (e.g. `input`, `n_agents`, `seed`, `time_horizon`); it is
#' expanded onto those parameters via `do.call()`. This keeps one standard
#' interface while still letting callers set scalar controls such as `n_agents`.
#'
#' Start from [get_default_input()] and add whatever you need:
#' `x <- get_default_input(); x$n_agents <- 1e6; model_run(x)`.
#'
#' Defaults to basic (summary) results only; include `extended_results = TRUE`
#' in `model_input` to also compute the detailed `$extended` table.
#'
#' @param model_input Named list of `epicR::simulate()` arguments. If `NULL`,
#'   epicR's built-in defaults are used.
#'
#' @return A list with `$basic` (summary) and, when requested, `$extended`.
#' @export
model_run <- function(model_input = NULL) {
  if (is.null(model_input)) model_input <- list()

  # Basic-only by default (epicR's own default is extended = TRUE, which is
  # wasteful when only the summary is needed). Callers can opt back in.
  if (is.null(model_input$extended_results)) {
    model_input$extended_results <- FALSE
  }

  # model_input carries simulate()'s arguments as named elements; expand them.
  do.call(epicR::simulate, model_input)
}


#' Get the default input for the EPIC-R model
#'
#' Returns a ready-to-use `model_input` for [model_run()]: a named list with an
#' `input` element holding epicR's default parameter set (from
#' `epicR::get_input()`, metadata stripped). Add scalar `epicR::simulate()`
#' controls as needed before calling [model_run()], e.g.
#' `x <- get_default_input(); x$n_agents <- 1e6; model_run(x)`.
#'
#' @return A named list suitable for passing directly to [model_run()] as
#'   `model_input`.
#' @export
get_default_input <- function() {
  list(input = epicR::get_input()$values)
}
