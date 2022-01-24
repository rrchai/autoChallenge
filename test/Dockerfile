FROM r-base:4.0.2

RUN R -e "install.packages('data.table', repos = 'http://cran.us.r-project.org')"

COPY predict.R /predict.R

CMD ["Rscript", "/predict.R", "/data/input_data.csv", "/output/predictions.csv"]