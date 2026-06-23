# epicrpexa

<!-- badges: start -->
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

`epicrpexa` is the **server-side** package that hosts the **EPIC** COPD policy
microsimulation on the [ModelsCloud](https://modelscloud.resp.core.ubc.ca/)
cloud modelling platform. It wraps the `epicR` package and exposes it through
the standard ModelsCloud API.

Unlike a quick prediction model, EPIC is a microsimulation whose runtime grows
with the number of simulated agents — so it can be run **synchronously** (small
runs) or **asynchronously** (large runs).


## Entry points

The functions the Pexa executor calls (the package's only exported surface):

| Function | `funcName` | Description |
|---|---|---|
| `get_default_input()` | `get_default_input` | A ready-to-use default `model_input` |
| `model_run()` | `model_run` (default) | Run the EPIC simulation → summary outcomes |

`model_input` is a **named list** whose elements are the arguments of the
underlying simulator — `input` (the EPIC parameter set), plus scalar controls
such as `n_agents`, `time_horizon`, and `seed`. They are expanded onto the
simulator via `do.call()`, so the single `model_input` argument is all the
client ever sends. `get_default_input()` returns a list with the `input`
element already populated; add scalar controls before running.

`model_run()` returns a list with a `$basic` summary (and `$extended` if you
set `extended_results = TRUE` in `model_input`).


## Using the model from R

End users interact with the hosted model through the
[`modelscloud`](https://github.com/resplab/modelscloud) client package. It
defaults to the ModelsCloud server
(`https://api.modelscloud.resp.core.ubc.ca/`), so you only need the model path
and an API key.

```r
# install.packages("remotes")
remotes::install_github("resplab/modelscloud")
library(modelscloud)

# Connect once per session (uses the default ModelsCloud server URL).
# Request an API key from the ModelsCloud team, or set MODELSCLOUD_ACCESS_KEY
# in your .Renviron instead of passing access_key here.
connect_to_model(
  model_path = "mohsenss/epicrpexa",
  access_key = "YOUR_API_KEY"
)

# 1. Fetch the default input, adjust it, run a small (synchronous) simulation.
mi <- get_default_input()
mi$n_agents <- 1000
result <- model_run(mi)
result$basic$total_qaly
```

### Large runs — asynchronous

For a realistic run (say ten million agents), submit the job with
`async = TRUE` and retrieve it when it finishes — `model_run()` returns
immediately with a job handle instead of blocking:

```r
mi <- get_default_input()
mi$n_agents <- 1e7

job    <- model_run(mi, async = TRUE)            # returns at once
result <- get_async_results(job, wait = TRUE,    # block & poll until done
                            timeout = 3600)
result$basic$total_qaly
```

To **check progress** without blocking, call `get_async_results(job)` on its
own: it returns the finished result if the run is done, or the job handle
unchanged if it is still running (test with
`inherits(x, "pexa_result_async")`).


## Reference

If you use the EPIC model, please cite:

> Sadatsafavi M, Ghanbarian S, Adibi A, Johnson K, FitzGerald JM, Flanagan W,
> Bryan S, Sin DD. Development and Validation of the Evaluation Platform in COPD
> (EPIC): A Population-Based Outcomes Model of COPD for Canada. *Medical
> Decision Making*. 2019;39(2):152–167.
> doi:[10.1177/0272989X18824098](https://doi.org/10.1177/0272989X18824098)


## License

GPL-3 © Mohsen Sadatsafavi
