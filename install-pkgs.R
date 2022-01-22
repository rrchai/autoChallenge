if (!suppressWarnings(require("pacman", character.only = TRUE))) {
  install.packages("pacman", repos = "https://cran.r-project.org/")
}

pkg_list <- c("reticulate", "dplyr", "glue", "argparse")

pacman::p_load(pkg_list, character.only = TRUE)
