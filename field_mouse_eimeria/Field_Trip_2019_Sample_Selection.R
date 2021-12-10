library(tidyverse)
library(dplyr)
library(ggplot2)

#reading our own field data
SOTA <- read_csv("https://raw.githubusercontent.com/derele/Mouse_Eimeria_Field/master/data_products/SOTA_Data_Product.csv")

Data <- read_csv("/localstorage/fay/Immuno_Fu/Immune_Data_FU.csv")

#cleaning
#removing empty columns
Data <- remove_empty(Data, which = c("cols"), quiet = TRUE)

#changing column names of worms to reflect SOTA
Data <- rename(Data, Aspiculuris_sp = ASP, Syphacia_sp = SYP, Mastophorus_muris = MM, 
                Trichuris_muris = TM) 

write.csv(Data, "data_input/FU_Immune_Worms.csv", row.names = FALSE)

#cell count columns from SOTA from MLN
#CellCount.cols <- c( "Treg", "CD4", "Treg17", "Th1", "Th17", "CD8",
                     #"Act_CD8", "IFNy_CD4", "IL17A_CD4", "IFNy_CD8")



colnames(Data)


Treg_Sota <- SOTA %>%
  select(Mouse_ID, Treg)

Treg_FU <- Data %>%
  select(Mouse_ID, `% Foxp3+ in CD4+ (Treg) mLN`) %>%
  left_join(Treg_Sota, by = "Mouse_ID") %>%
  mutate(Treg_Fu_Foxp3 = as.numeric(`% Foxp3+ in CD4+ (Treg) mLN`))

#see if there are any correlations between our data and fu data
cor(Treg_FU$Treg, Treg_FU$Treg_Fu_Foxp3, use = "pairwise.complete.obs")



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
