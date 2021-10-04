install.packages("tidyverse")
library(tidyverse)
library(data.table)
library(visdat)
library(stringr)

#################### add and process IFC runs
IFC1 <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/IFC1.csv")
IFC2 <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/IFC2.csv")
IFC3 <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/IFC3.csv")
IFC4 <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/IFC4.csv")
IFC5 <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/IFC5.csv")

IFC <- bind_rows(IFC1, IFC2, IFC3, IFC4, IFC5)

#change the column EH_ID to Mouse_ID
colnames(IFC)[colnames(IFC)%in%"EH_ID"] <- "Mouse_ID"

#change the row names from AXXX to AA_XXXX
IFC$Mouse_ID <- gsub("A", "AA_", IFC$Mouse_ID)
IFC$Mouse_ID <- gsub("AA_AA_", "AA_", IFC$Mouse_ID)

#group everything by Mouse_ID and Target, create a Ct/Ct_mean variable from this
IFC <- IFC[IFC$Mouse_ID %like% "AA_", ]

# remove unsuccessful amplifications
IFC <- subset(IFC, IFC$Value != 999)
IFC %>%
  group_by(Mouse_ID, Target) %>%
  summarize(Ct_mean = mean(Value, na.rm = TRUE)) -> IFC

#keeping rows that are unique 
IFC <- distinct(IFC)

IFC.wide <- pivot_wider(IFC, names_from = Target, values_from = Ct_mean)

#change the column names of our beautiful markers to the same column names we have used in SOTA already
colnames(IFC.wide)[colnames(IFC.wide)%in%"IL6"] <- "IL.6"
colnames(IFC.wide)[colnames(IFC.wide)%in%"IL12A"] <- "IL.12"
colnames(IFC.wide)[colnames(IFC.wide)%in%"IFNG"] <- "IFNy"
colnames(IFC.wide)[colnames(IFC.wide)%in%"IL10"] <- "IL.10"
colnames(IFC.wide)[colnames(IFC.wide)%in%"IL13"] <- "IL.13"
colnames(IFC.wide)[colnames(IFC.wide)%in%"IL17A"] <- "IL.17"
colnames(IFC.wide)
Gene.Exp.cols

Ct_var = var(Value, na.rm = TRUE),
Ct_N = n())
IFC.wide <- data.frame(IFC.wide)