set.seed(1234)

# create a fake goldstandard file
gs <- data.frame(test = 1:10, prediction = sample(c(0, 1), 10, replace = TRUE))
write.csv(gs, "goldstandard.csv", row.names = FALSE)

# create a fake input data
input_data <- data.frame(test = 1:10, feature = sample(1:100, 10, replace = TRUE))
write.csv(input_data, "input_data.csv", row.names = FALSE)