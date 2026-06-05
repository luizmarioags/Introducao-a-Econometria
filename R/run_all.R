# Orquestrador da replicação em R
# Pode ser executado de qualquer diretório com:
# source("c:/.../Introducao a Econometria 2022/R/run_all.R")

.locate_this_file <- function() {
  of <- tryCatch(sys.frame(1)$ofile, error = function(e) NA_character_)
  if (!is.null(of) && length(of) == 1 && is.character(of) && !is.na(of) && nzchar(of)) {
    return(normalizePath(of, winslash = "/", mustWork = FALSE))
  }

  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg) > 0) {
    return(normalizePath(sub("^--file=", "", file_arg[1]), winslash = "/", mustWork = FALSE))
  }

  return(NA_character_)
}

THIS_FILE <- .locate_this_file()
if (!is.na(THIS_FILE) && nzchar(THIS_FILE)) {
  R_DIR <- dirname(THIS_FILE)
  ROOT <- normalizePath(file.path(R_DIR, ".."), winslash = "/", mustWork = FALSE)
} else {
  cwd <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
  if (basename(cwd) == "R" && file.exists(file.path(cwd, "00_setup.R"))) {
    R_DIR <- cwd
    ROOT <- normalizePath(file.path(cwd, ".."), winslash = "/", mustWork = FALSE)
  } else if (file.exists(file.path(cwd, "R", "00_setup.R"))) {
    ROOT <- cwd
    R_DIR <- file.path(cwd, "R")
  } else {
    stop("Não foi possível localizar a raiz do pacote. Rode source('caminho/para/R/run_all.R') ou execute a partir da raiz.")
  }
}

options(econ_root = ROOT, econ_r_dir = R_DIR)
source(file.path(R_DIR, "00_setup.R"), chdir = TRUE)

scripts <- c("lista01.R", "lista02.R", "lista03.R", "lista04.R", "lista05.R")
for (s in scripts) {
  message("\n>>> Executando ", s)
  source(file.path(R_DIR, s), chdir = TRUE)
}
cat("Replicação R concluída.\n")
