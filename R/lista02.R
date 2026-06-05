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

educ_hat <- function(irms, educm, educp) 10.36 - 0.094*irms + 0.131*educm + 0.210*educp
q1 <- data.frame(caso=c('A_sem_irmaos_pais12','B_sem_irmaos_pais16'), educ_prevista=c(educ_hat(0,12,12), educ_hat(0,16,16)))
q1 <- rbind(q1, data.frame(caso='diferenca_B_menos_A', educ_prevista=q1$educ_prevista[2]-q1$educ_prevista[1]))
write.csv(q1, file.path(TABLES, 'R_lista02_q01.csv'), row.names=FALSE)
save_plot('R_lista02_q01_educacao_prevista', {
  barplot(q1$educ_prevista[1:2], names.arg=c('A','B'), ylab='Educação prevista, em anos', main='Educação prevista')
})

cars_path <- file.path(DATA, 'cars_lista02.csv')
if (file.exists(cars_path)) {
  cars <- read.csv(cars_path)
  write.csv(summary(cars), file.path(TABLES, 'R_lista02_q05_descritivas.csv'))
  mod_full <- lm(KPL ~ VM + HP + PV, data=cars)
  capture.output(summary(mod_full), file=file.path(TABLES, 'R_lista02_q05_modelo_completo.txt'))
  mod_vm <- lm(VM ~ HP + PV, data=cars)
  cars$r_vm <- resid(mod_vm)
  mod_fwl <- lm(KPL ~ r_vm, data=cars)
  capture.output(summary(mod_fwl), file=file.path(TABLES, 'R_lista02_q05_fwl.txt'))
  save_plot('R_lista02_q05_kpl_vm', {
    plot(cars$VM, cars$KPL, xlab='Velocidade máxima', ylab='Quilômetros por litro', main='KPL e velocidade máxima')
  })
  save_plot('R_lista02_q05_fwl', {
    plot(cars$r_vm, cars$KPL, xlab='Resíduo de VM', ylab='KPL', main='Teorema FWL')
    abline(mod_fwl)
  })
} else {
  writeLines('Arquivo cars_lista02.csv não encontrado.', file.path(TABLES, 'R_lista02_q05_aviso.txt'))
}
cat('Lista 2 R concluída.\n')