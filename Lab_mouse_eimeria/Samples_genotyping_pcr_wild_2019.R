#load the library readr
library(readr)

#load the library tidyverse
library("tidyverse")

#load the data from github. 
#make sure to load the raw data 
HZ19_CEWE_qPCR <- read_csv("https://raw.githubusercontent.com/derele/Mouse_Eimeria_Field/master/data_input/Eimeria_detection/HZ19_CEWE_qPCR.csv")

#view the table
View(HZ19_CEWE_qPCR)

#load dplyr
library(dplyr)

#filter the samples for which the melting curve is positive
?filter
df_selection_positive_melting_curve <- filter(HZ19_CEWE_qPCR, MC == "TRUE")


