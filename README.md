# R shiny Dashboard for COVID-19 
Data source: https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv
![image](https://github.com/Sudipanpaul/Shiny_covid/assets/86123960/db89536b-cbd4-49a8-96df-0dceda466fbf)


### Motivation
This project dives into an interactive version of COVID -19 data analysis where the use get the dynamic availability to prepare questions and get the desired answers

### code for runing the applictaion locally

```R 
runGithub("Shiny_covid","Sudipanpaul")
```

It may happend that one maynot have all the required libraries installed hence install the following libraries
#### Libraries needed
```R
install.packages(c(
  "shiny",
  "httr",
  "jsonlite",
  "dplyr",
  "ggplot2",
  "leaflet",
  "tidyr",
  "shinythemes",
  "maps",
  "bslib",
  "DT",
  "plotly"
))

```

