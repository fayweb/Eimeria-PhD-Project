library(tidyverse)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(stringr)
library(janitor)

## Cleaning and preparing the data from our collaboration with FU 

#starting with reading our own field data to have an example for our structure
SOTA <- read.csv("https://raw.githubusercontent.com/derele/Mouse_Eimeria_Field/master/data_products/SOTA_Data_Product.csv")

Data <- read.csv("https://raw.githubusercontent.com/fayweb/Eimeria-PhD-Project/gh-pages/field_mouse_eimeria/Field%20trip%202019%20data%20sheet_Hongwei%2020211122_edit_Fay%20-%20Sheet2.csv")

#removing empty columns
Data <- remove_empty(Data, which = c("cols"), quiet = TRUE)

#changing column names of worms to reflect SOTA
Data <- rename(Data, Aspiculuris_sp = ASP, Syphacia_sp = SYP, Mastophorus_muris = MM, 
                Trichuris_muris = TM) 


#apparently some values in observations contain the number and a *
#what does the * even mean?
#for analysis it has to be removed 
#removed it in the excel files as r was not recognizing *

write.csv(Data, "data_input/FU_Immune_Worms.csv", row.names = FALSE)

#cell count columns from SOTA from MLN
CellCount.cols <- c("CD8", "Treg", "CD4", "Treg17", "Th1", "Th17", 
                     "Act_CD8", "IFNy_CD4", "IL17A_CD4", "IFNy_CD8")
#what is treg17, it doesn't exist in the fu data

#select only mouse id from Data
Data_Mouse_id <- Data %>%
  select(Mouse_ID)

#extract our immune data from sota
SOTA_Immune <- SOTA %>%
  select(Mouse_ID, all_of(CellCount.cols)) %>%
  right_join(Data_Mouse_id, by = "Mouse_ID")

SOTA_Immune <- SOTA_Immune %>%
  rename(CD4_mLN = CD4, CD8_mLN = CD8, Foxp3_in_CD4_Treg_mLN = Treg, 
         CD4_mLN = CD4, Tbet_in_CD4_Foxp3_Th1_mLN = Th1)

cor(SOTA_Immune, Data, use = "pairwise.complete.obs")

Data_selection <- Data %>%
  select(Mouse_ID, CD4_mLN, CD8_mLN, Foxp3_in_CD4_Treg_mLN, )
         #"Treg17"
         # "Th17", #what is this
         #"Act_CD8", 
         #"IFNy_CD4", #three possibilities in the data of fu
         #"IL17A_CD4", 
         #"IFNy_CD8"))


#comparing Treg counts from spleen
Treg_Sota <- SOTA %>%
  select(Mouse_ID, Treg)

Treg_FU <- Data %>%
  select(Mouse_ID, Foxp3..in.CD4...Treg..mLN) %>%
  left_join(Treg_Sota, by = "Mouse_ID")

#see if there are any correlations between our data and fu data
cor(Treg_FU$Treg, Treg_FU$Foxp3..in.CD4...Treg..mLN, use = "pairwise.complete.obs")

#now for CD8

CD8_Sota <- SOTA %>%
  select(Mouse_ID, CD8)

CD8_FU <- Data %>%
  select(Mouse_ID, CD8..mLN) %>%
  left_join(CD8_Sota, by = "Mouse_ID")

CD8_FU <- CD8_FU[complete.cases(CD8_FU), ]

CD8_FU <- CD8_FU %>%
  mutate(CD8..mLN = as.numeric(CD8..mLN))

cor(CD8_FU$CD8, CD8_FU$CD8..mLN, use = "pairwise.complete.obs")

#now for cd4

CD4_Sota <- SOTA %>%
  select(Mouse_ID, CD4)

CD4_FU <- Data %>%
  select(Mouse_ID, CD4..mLN) %>%
  left_join(CD4_Sota, by = "Mouse_ID")

CD4_FU <- CD4_FU[complete.cases(CD4_FU), ]

CD4_FU <- CD4_FU %>%
  mutate(CD4..mLN = as.numeric(CD4..mLN))

cor(CD4_FU$CD4, CD4_FU$CD4..mLN, use = "pairwise.complete.obs")



  





Data_Worms <- Data %>%
  select(c(Mouse_ID, Aspiculuris_sp, Syphacia_sp, Mastophorus_muris, Trichuris_muris))

Data_Worms2 <- Data_Worms %>%
  mutate(ASP = case_when(Aspiculuris_sp == 0 ~ FALSE,
                         TRUE ~ TRUE),
         SYP = case_when(Syphacia_sp == 0 ~ FALSE,
                         TRUE ~ TRUE), 
         MM = case_when(Mastophorus_muris == 0 ~ FALSE,
                         TRUE ~ TRUE),
         TM = case_when(Trichuris_muris == 0 ~ FALSE,
                         TRUE ~ TRUE)) 
 
DWORMS <- Data_Worms2 %>%
  select(Mouse_ID, ASP, SYP, MM, TM)

ggplot(DWORMS,                         # Apply geom_venn function
       aes(A = ASP, B = SYP, C = MM, D = TM)) +
  geom_venn()
?geom_venn



venn(list(ASP = Data_Worms2$ASP, B = $SYP))

ASP <- Data_Worms2 %>%
  summarize(sum(ASP == TRUE)) 

SYP <- Data_Worms2 %>%
  summarize(sum(SYP == TRUE)) 

MM <- Data_Worms2 %>%
  summarize(sum(MM == TRUE)) 

TM <- Data_Worms2 %>%
  summarize(sum(TM == TRUE)) 



Data_Worms %>%
  summarize(sum(Aspiculuris_sp)) 
Data_Worms %>%
  summarize(sum(Syphacia_sp)) 
Data_Worms %>%
  summarize(sum(Mastophorus_muris)) 
Data_Worms %>%
  summarize(sum(Trichuris_muris)) 



                            
#plotting the venn diagram or figure B
#first make lists out of the worm columns
ASP <- data.frame(Data$Mouse_ID, Data$Aspiculuris_sp)
SYP <- data.frame(Data$Mouse_ID, Data$Syphacia_sp)
MM <- data.frame(Data$Mouse_ID, Data$Mastophorus_muris)
TM <- data.frame(Data$Mouse_ID, Data$Trichuris_muris)

list_worms <- list(ASP, SYP, MM, TM)

#plot the venn diagram
draw.quintuple.venn()
             
            glimpse(Data)
colnames(Data)
