# fake prediction model to test infra

args        <- commandArgs(trailingOnly=TRUE)
infile      <- read.csv(args[1])

prediction  <- data.frame(test = infile$test, prediction = ifelse(infile$feature %% 2 == 0, 1, 0))

write.csv(prediction, file = args[2], quote = FALSE, row.names = FALSE)

rm(infile, prediction)
