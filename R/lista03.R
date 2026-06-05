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

# Q4 ceosal1
data('ceosal1', package='wooldridge')
mod_ceo <- lm(log(salary) ~ log(sales) + roe + ros, data=ceosal1)
capture.output(summary(mod_ceo), file=file.path(TABLES, 'R_lista03_q04_ceosal1.txt'))
save_plot('R_lista03_q04_ceosal1_ros_lsalary', {
  plot(ceosal1$ros, log(ceosal1$salary), xlab='Retorno sobre vendas, ROS', ylab='log(salário)', main='ROS e salário dos CEOs')
  ros_grid <- seq(min(ceosal1$ros, na.rm=TRUE), max(ceosal1$ros, na.rm=TRUE), length.out=100)
  base_sales <- mean(ceosal1$sales, na.rm=TRUE); base_roe <- mean(ceosal1$roe, na.rm=TRUE)
  y_grid <- coef(mod_ceo)[1] + coef(mod_ceo)[2]*log(base_sales) + coef(mod_ceo)[3]*base_roe + coef(mod_ceo)[4]*ros_grid
  lines(ros_grid, y_grid)
})

# Q6 return
tryCatch({
  data(list='return', package='wooldridge')
  ret <- get('return')
  names(ret)[names(ret) == 'return'] <- 'ret'
  mod_ret1 <- lm(ret ~ dkr + eps + salary + netinc, data=ret)
  capture.output(summary(mod_ret1), file=file.path(TABLES, 'R_lista03_q06_return_nivel.txt'))
  ret$lnetinc <- log(ret$netinc)
  ret$lsalary <- log(ret$salary)
  mod_ret2 <- lm(ret ~ dkr + eps + lsalary + lnetinc, data=ret)
  capture.output(summary(mod_ret2), file=file.path(TABLES, 'R_lista03_q06_return_log.txt'))
  save_plot('R_lista03_q06_return_observado_ajustado', {
    plot(ret$ret, fitted(mod_ret2), xlab='Retorno observado', ylab='Retorno ajustado', main='Retorno observado versus ajustado')
    abline(0, 1)
  })
}, error=function(e) {
  writeLines(as.character(e), file.path(TABLES, 'R_lista03_q06_return_erro.txt'))
})
cat('Lista 3 R concluída.\n')