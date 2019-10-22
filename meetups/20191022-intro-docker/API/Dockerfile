FROM rocker/tidyverse
RUN sudo apt-get update && \
    sudo apt-get install unixodbc odbc-postgresql  -y && \
    install2.r --error \
    --deps TRUE \
    odbc \
    DBI \
    plumber \
    RPostgreSQL \
    Lahman
COPY . /usr/local/src/myscripts
WORKDIR /usr/local/src/myscripts
EXPOSE 80
CMD ["Rscript", "loadData.R"]
CMD ["Rscript", "api.R"]
