confirm <- function(msg) {
  
  cat(paste0("\n", msg, " (Y/n)"))
  response <- readLines("stdin", n = 1)
  
  while (!response %in% c("Y", "n", "")) {
    cat(paste0(msg, " (Y/n)"))
    response <- readLines("stdin", n = 1)
  }

  pass <- case_when(response == "Y" ~ TRUE,
                    response == "n" ~ FALSE,
                    TRUE ~ TRUE)
  
  if (!pass) stop("n: exit")
  
}