#' Run the EPIC-R COPD policy simulation
#'
#' Wraps `epicR::simulate()`. Pass the list returned by [get_default_input()]
#' as `model_input` and optionally override agent count and seed.
#'
#' @param model_input Named list of input parameters, as returned by
#'   [get_default_input()]. If `NULL`, epicR uses its built-in defaults.
#' @param n_agents Integer. Number of simulated agents. Higher values give more
#'   precise estimates at the cost of runtime. If `NULL`, uses the epicR default.
#' @param seed Integer. Random seed for reproducibility. `NULL` means no seed.
#' @param extended Logical. If `FALSE` (default), returns only the basic
#'   summary data frame. If `TRUE`, returns the full list with both `$basic`
#'   and `$extended` results.
#'
#' @return If `extended = FALSE`: the basic summary data frame. If
#'   `extended = TRUE`: a list with `$basic` and `$extended`.
#' @export
model_run <- function(
  model_input = NULL,
  n_agents    = NULL,
  seed        = NULL,
  extended    = FALSE
) {
  res <- epicR::simulate(
    input            = model_input,
    n_agents         = n_agents,
    seed             = seed,
    extended_results = extended
  )
  if (extended) res else res$basic
}


#' Get the default input for the EPIC-R model
#'
#' Returns the default input parameter set from `epicR::get_input()`, with the
#' metadata (`help`, `ref`, `config`) stripped — only the `$values` list is
#' returned, which is what [model_run()] and `epicR::simulate()` expect.
#'
#' @return A named list of input parameter values, suitable for passing
#'   directly to [model_run()] as `model_input`.
#' @export
get_default_input <- function() {
  epicR::get_input()$values
}
