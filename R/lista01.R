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

# Q1
desp_df <- read.csv(file.path(DATA, 'lista01_q01_habitacao.csv'))
desp <- desp_df$despesas_habitacao
q1 <- data.frame(medida=c('media','mediana','media_centenas','mediana_centenas'),
                 valor=c(mean(desp), median(desp), mean(desp)/100, median(desp)/100))
desp_novo <- desp; desp_novo[8] <- 900
q1 <- rbind(q1, data.frame(medida=c('nova_media','nova_mediana'), valor=c(mean(desp_novo), median(desp_novo))))
write.csv(q1, file.path(TABLES, 'R_lista01_q01.csv'), row.names=FALSE)

save_plot('R_lista01_q01_despesas_habitacao', {
  barplot(desp, names.arg=desp_df$familia, xlab='Família', ylab='Despesas mensais com habitação, em US$', main='Lista 1 - Questão 1')
  abline(h=mean(desp), lty=2)
  abline(h=median(desp), lty=3)
  legend('topright', legend=c('Média','Mediana'), lty=c(2,3), bty='n')
})

save_plot('R_lista01_q01_media_mediana_comparacao', {
  mat <- rbind(c(mean(desp), median(desp)), c(mean(desp_novo), median(desp_novo)))
  barplot(mat, beside=TRUE, names.arg=c('Média','Mediana'), ylab='US$ por mês', main='Média e mediana', legend.text=c('Original','Família 8 = 900'))
})

# Q3
q3 <- data.frame(SAT=c(800,1400,1100))
q3$E_IRA <- 0.70 + 0.002*q3$SAT
write.csv(q3, file.path(TABLES, 'R_lista01_q03.csv'), row.names=FALSE)
save_plot('R_lista01_q03_esperanca_condicional_ira_sat', {
  sat_grid <- seq(400, 1600, length.out=200)
  plot(sat_grid, 0.70 + 0.002*sat_grid, type='l', xlab='SAT', ylab='E(IRA | SAT)', main='Esperança condicional')
  points(q3$SAT, q3$E_IRA)
})

# Q6
renda <- seq(2000, 32000, length.out=200)
pmgc <- rep(0.853, length(renda))
pmec <- -124.84/renda + 0.853
write.csv(data.frame(renda, PMgC=pmgc, PMeC=pmec), file.path(TABLES, 'R_lista01_q06_propensoes.csv'), row.names=FALSE)
save_plot('R_lista01_q06_pmgc_pmec', {
  plot(renda, pmgc, type='l', ylim=range(c(pmgc, pmec)), xlab='Renda anual', ylab='Propensão', main='PMgC e PMeC')
  lines(renda, pmec, lty=2)
  legend('bottomright', legend=c('PMgC','PMeC'), lty=c(1,2), bty='n')
})

# Q7
gpa <- read.csv(file.path(DATA, 'lista01_q07_gpa_act.csv'))
mod_gpa <- lm(GPA ~ ACT, data=gpa)
capture.output(summary(mod_gpa), file=file.path(TABLES, 'R_lista01_q07_regressao.txt'))
save_plot('R_lista01_q07_gpa_act_mqo', {
  plot(gpa$ACT, gpa$GPA, xlab='ACT', ylab='GPA', main='GPA em função de ACT')
  abline(mod_gpa)
  segments(gpa$ACT, gpa$GPA, gpa$ACT, fitted(mod_gpa), lty=3)
})

# Q11
save_plot('R_lista01_q11_peso_cigarros', {
  cigs <- seq(0, 30, length.out=100)
  plot(cigs, 119.77 - 0.514*cigs, type='l', xlab='Cigarros por dia', ylab='Peso previsto, em onças', main='Peso ao nascer e cigarros')
  points(c(0,20), c(119.77, 119.77 - 0.514*20))
})

# Q15
xy <- read.csv(file.path(DATA, 'lista01_q15_xy.csv'))
mod15 <- lm(y ~ x, data=xy)
capture.output(summary(mod15), file=file.path(TABLES, 'R_lista01_q15_regressao.txt'))
save_plot('R_lista01_q15_observado_ajustado', {
  plot(xy$x, xy$y, xlab='x', ylab='y', main='Observado e ajustado')
  lines(xy$x, fitted(mod15), type='b')
})
cat('Lista 1 R concluída.\n')