# Setup robusto para o pacote de replicação em R
# Funciona quando o usuário roda:
#   source("R/run_all.R")
#   source("c:/.../R/run_all.R")
#   source("R/lista01.R")
# ou quando a pasta de trabalho já é a raiz do pacote.

options(repos = c(CRAN = "https://cloud.r-project.org"))

.locate_r_dir <- function() {
  opt <- getOption("econ_r_dir")
  if (!is.null(opt) && length(opt) == 1 && is.character(opt) && nzchar(opt)) {
    return(normalizePath(opt, winslash = "/", mustWork = FALSE))
  }

  of <- tryCatch(sys.frame(1)$ofile, error = function(e) NA_character_)
  if (!is.null(of) && length(of) == 1 && is.character(of) && !is.na(of) && nzchar(of)) {
    return(dirname(normalizePath(of, winslash = "/", mustWork = FALSE)))
  }

  cwd <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
  if (basename(cwd) == "R" && file.exists(file.path(cwd, "00_setup.R"))) {
    return(cwd)
  }
  if (file.exists(file.path(cwd, "R", "00_setup.R"))) {
    return(file.path(cwd, "R"))
  }

  stop("Não foi possível localizar a pasta R do pacote. Rode a partir da raiz do pacote ou use source('caminho/para/R/run_all.R').")
}

R_DIR <- .locate_r_dir()
ROOT_OPT <- getOption("econ_root")
if (!is.null(ROOT_OPT) && length(ROOT_OPT) == 1 && is.character(ROOT_OPT) && nzchar(ROOT_OPT)) {
  ROOT <- normalizePath(ROOT_OPT, winslash = "/", mustWork = FALSE)
} else {
  ROOT <- normalizePath(file.path(R_DIR, ".."), winslash = "/", mustWork = FALSE)
}

options(econ_root = ROOT, econ_r_dir = R_DIR)

DATA <- file.path(ROOT, "data", "manual")
TABLES <- file.path(ROOT, "outputs", "tables")
FIGS <- file.path(ROOT, "outputs", "figures")
FIGS_R <- file.path(FIGS, "R")
LOGS <- file.path(ROOT, "logs")

dir.create(TABLES, recursive = TRUE, showWarnings = FALSE)
dir.create(FIGS_R, recursive = TRUE, showWarnings = FALSE)
dir.create(LOGS, recursive = TRUE, showWarnings = FALSE)

ensure_pkg <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}

ensure_pkg("sandwich")
ensure_pkg("lmtest")
ensure_pkg("wooldridge")

save_plot <- function(name, expr, width = 7, height = 4) {
  code <- substitute(expr)
  env <- parent.frame()

  png(file.path(FIGS_R, paste0(name, ".png")), width = width, height = height, units = "in", res = 300)
  tryCatch(eval(code, envir = env), finally = dev.off())

  pdf(file.path(FIGS_R, paste0(name, ".pdf")), width = width, height = height)
  tryCatch(eval(code, envir = env), finally = dev.off())
}
