FROM rhub/r-minimal

COPY predict.R /predict.R

CMD ["Rscript", "/predict.R", "/data/input_data.csv", "/output/predictions.csv"]