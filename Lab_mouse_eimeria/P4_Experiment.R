#load libraries
library(tidyr)
library(ggplot2)
library(dplyr)
library(stringr) #to manipulate strings
library(magrittr)


#read challenge infections
Challenge_Infections <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data_products/Challenge_infections.csv")
str(Challenge_Infections)
#show column names
colnames(Challenge_Infections)

#read facs tables 
#starting with p4 FACS
P4_FACS <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/P4_082020_Eim_FACS.csv")
P4_FACS$EH_ID <- str_replace_all(P4_FACS$EH_ID, "LM_", "LM") #replace string values in EH_ID Column so that table matches the challenge infections table
str(P4_FACS)
colnames(P4_FACS)

#read experimental design P4
P4_Design <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experimental_design/P4_082020_Eim_DESIGN.csv")
P4_Design$EH_ID <- str_replace_all(P4_Design$EH_ID, "LM_", "LM") #replace string values in EH_ID Column so that table matches the challenge infections table

#join P4_FACS and P4_Design
P4_Full <- P4_FACS %>%
  left_join(P4_Design, by = "EH_ID") %>%
  select(!X)
#%>%
# select(!experiment) %>%
# select(!challenge)
str(P4_Full)

#read Experimental design P4
P4_record <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/P4_082020_Eim_record.csv")
P4_record$EH_ID <- str_replace_all(P4_record$EH_ID, "LM_", "LM") #replace string values in EH_ID Column so that table matches the challenge infections table
P4_record <-P4_record %>% 
  rename(label = labels) %>%
  select(!X)
str(P4_record)

#join P4_full with record 
P4_Full <- P4_record %>%
  left_join(P4_Full, by = c("EH_ID", "experiment", "label", "dpi"))

#add the oocyst counts
P4_oocysts <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/P4_082020_Eim_oocyst.csv") %>% 
  rename(label = labels) %>%
  select(!X)

#join the oocyst counts to the P4_full
P4_Full <- P4_Full %>%
  left_join(P4_oocysts, by = c("label", "experiment")) %>%
  rename(labels = label)

str(P4_Full)

#which column names are matching
colnames(P4_Full) %in% colnames(Challenge_Infections) %>% table
colnames(Challenge_Infections)


#write the table 
write.csv(P4_Full, "/home/fay/Documents/GitHub/Eimeria-PhD-Project/Lab_mouse_eimeria/Products/P4_Experiment_joined", row.names = FALSE)


#use the code of Emanuel on challenge infections to add the infection history and infection type variable 

