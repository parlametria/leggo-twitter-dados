FROM rocker/tidyverse:3.6.2

WORKDIR /leggo-twitter-dados

RUN R -e "install.packages(c('here', 'optparse', 'RCurl'), repos='http://cran.rstudio.com/')"