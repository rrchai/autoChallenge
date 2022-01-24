# fake prediction model to test infra

suppressMessages(library(data.table))

args        <- commandArgs(trailingOnly=TRUE)
infile      <- fread(args[1], data.table = FALSE)

prediction  <- data.frame(id = infile$test, prediction = ifelse(infile$feature %% 2 == 0, 1, 0))

write.csv(prediction, file = args[2], quote = FALSE, row.names = FALSE)

rm(infile, prediction)
