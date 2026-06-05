# Carrega o setup de forma robusta, com ou sem run_all.R
if (is.null(getOption("econ_r_dir")) || is.null(getOption("econ_root"))) {
  .locate_r_dir_local <- function() {
    of <- tryCatch(sys.frame(1)$ofile, error = function(e) NA_character_)
    if (!is.null(of) && length(of) == 1 && is.character(of) && !is.na(of) && nzchar(of)) {
      return(dirname(normalizePath(of, winslash = "/", mustWork = FALSE)))
    }
    cwd <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
    if (basename(cwd) == "R" && file.exists(file.path(cwd, "00_setup.R"))) return(cwd)
    if (file.exists(file.path(cwd, "R", "00_setup.R"))) return(file.path(cwd, "R"))
    stop("Não foi possível localizar a pasta R do pacote.")
  }
  source(file.path(.locate_r_dir_local(), "00_setup.R"), chdir = TRUE)
} else {
  source(file.path(getOption("econ_r_dir"), "00_setup.R"), chdir = TRUE)
}

library(lmtest)
library(sandwich)

# Q2, se a base municipal for fornecida
mun_path <- file.path(DATA, 'municipios_lista05.csv')
if (file.exists(mun_path)) {
  mun <- read.csv(mun_path)
  mod <- lm(pobreza ~ no + ne + su + co + pibpc + escol + escol:no + escol:ne + escol:su + escol:co, data=mun)
  capture.output(summary(mod), file=file.path(TABLES, 'R_lista05_q02_ols.txt'))
  capture.output(coeftest(mod, vcov.=vcovHC(mod, type='HC1')), file=file.path(TABLES, 'R_lista05_q02_robusto.txt'))
  save_plot('R_lista05_q02_pobreza_observado_ajustado', {
    plot(mun$pobreza, fitted(mod), xlab='Pobreza observada', ylab='Pobreza ajustada', main='Pobreza observada versus ajustada')
    abline(0, 1)
  })
} else {
  writeLines('Arquivo municipios_lista05.csv não encontrado.', file.path(TABLES, 'R_lista05_q02_aviso.txt'))
}

# Q3
het <- read.csv(file.path(DATA, 'lista05_q03_hetero.csv'))
mod_het <- lm(y ~ x, data=het)
capture.output(summary(mod_het), file=file.path(TABLES, 'R_lista05_q03_ols.txt'))
capture.output(bptest(mod_het, ~ x + I(x^2), data=het), file=file.path(TABLES, 'R_lista05_q03_white.txt'))
capture.output(coeftest(mod_het, vcov.=vcovHC(mod_het, type='HC1')), file=file.path(TABLES, 'R_lista05_q03_robusto.txt'))
mod_wls <- lm(y ~ x, data=het, weights=1/(x^2))
capture.output(summary(mod_wls), file=file.path(TABLES, 'R_lista05_q03_wls.txt'))
save_plot('R_lista05_q03_hetero_scatter_mqo', {
  plot(het$x, het$y, xlab='Número médio de empregados', ylab='Salário médio por trabalhador', main='MQO e heterocedasticidade')
  abline(mod_het)
})
save_plot('R_lista05_q03_residuos_quadrados', {
  plot(het$x, resid(mod_het)^2, xlab='Número médio de empregados', ylab='Resíduo ao quadrado', main='Resíduos ao quadrado')
})

# Q5
X <- matrix(1, nrow=5, ncol=1)
y <- matrix(c(0,7,5,0,0), ncol=1)
beta <- solve(t(X) %*% X) %*% t(X) %*% y
write.csv(data.frame(parametro='beta_hat', valor=as.numeric(beta)), file.path(TABLES, 'R_lista05_q05.csv'), row.names=FALSE)
save_plot('R_lista05_q05_variancias_condicionais', {
  barplot(c(1,3,4,6,8), names.arg=1:5, xlab='Observação', ylab='Var(u_i | X)', main='Variância condicional do erro')
})
cat('Lista 5 R concluída.\n')