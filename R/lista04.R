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

q1 <- data.frame(indicador='PIB_otimo', valor=0.0107/(2*0.000000245))
write.csv(q1, file.path(TABLES, 'R_lista04_q01.csv'), row.names=FALSE)
save_plot('R_lista04_q01_pib_quadratico', {
  pib_grid <- seq(0, 30000, length.out=400)
  y_pib <- 492.6 + 0.0107*pib_grid - 0.000000245*pib_grid^2
  plot(pib_grid, y_pib, type='l', xlab='PIB per capita, em US$', ylab='Pontuação prevista', main='Termo quadrático do PIB')
  abline(v=q1$valor, lty=2)
})

R2 <- 0.94363; n <- 27; k <- 2
q3 <- data.frame(indicador=c('F_conjunto','intercepto_Y_milhoes','intercepto_K_milhoes','IC_inf_2pct_K','IC_sup_2pct_K'),
                 valor=c((R2/k)/((1-R2)/(n-k-1)), 1.1755-log(1000), 1.1755+0.3756*log(1000), 0.02*(0.3756-2.064*0.0851), 0.02*(0.3756+2.064*0.0851)))
write.csv(q3, file.path(TABLES, 'R_lista04_q03.csv'), row.names=FALSE)
save_plot('R_lista04_q03_cobb_douglas_capital', {
  K_grid <- seq(1, 100, length.out=200)
  L_fix <- 50
  Y_grid <- exp(1.1755) * L_fix^0.6022 * K_grid^0.3756
  plot(K_grid, Y_grid, type='l', xlab='Capital K', ylab='Produto previsto Y', main='Cobb-Douglas com L fixo')
})

q4 <- data.frame(indicador=c('mpg_previsto','IC95_inf','IC95_sup'), valor=c(18.897,18.168,19.626))
write.csv(q4, file.path(TABLES, 'R_lista04_q04.csv'), row.names=FALSE)
save_plot('R_lista04_q04_mpg_peso_hp240', {
  w_grid <- seq(1800, 5000, length.out=200)
  mpg_pred <- 43.998 - 0.022*240 - 0.006*w_grid
  plot(w_grid, mpg_pred, type='l', xlab='Peso do veículo, em libras', ylab='mpg previsto', main='Previsão com hp fixo em 240')
  points(3500, 18.897)
})
cat('Lista 4 R concluída.\n')