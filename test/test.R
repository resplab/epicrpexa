setwd("C:/Users/msafavi/static/gitrepos/epicrpexa")
devtools::load_all()

# get_default_input()
inp <- get_default_input()
cat("get_default_input() names:", paste(names(inp), collapse=", "), "\n")
cat("age0:", inp$global_parameters$age0, "\n\n")

# model_run() with defaults (NULL input)
cat("--- model_run(NULL) ---\n")
res1 <- model_run(n_agents = 50, seed = 42)
cat("basic names:", paste(names(res1$basic), collapse=", "), "\n")
cat("total_qaly:", res1$basic$total_qaly, "\n\n")

# model_run() with get_default_input()
cat("--- model_run(get_default_input()) ---\n")
res2 <- model_run(model_input = inp, n_agents = 50, seed = 42)
cat("total_qaly:", res2$basic$total_qaly, "\n")
