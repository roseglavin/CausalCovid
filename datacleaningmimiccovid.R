
setwd("/Users/roseg/hs614/MIMICCOVID/data")



#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("corrplot")
#install.packages("rgl")
#install.packages("pwr")
#install.packages("pscl")
#library(tidyverse)
library(dplyr)
library(ggplot2)
library(pscl)

icd1  <- read.csv( file="C:\\Users\\roseg\\HS614\\MIMICCOVID\\data\\MIMICFLAGGEDDISEASE.csv")
patientadmissions <- distinct(data.frame(icd1$subject_id,icd1$hadm_id,icd1$icustay_id))

colnames(patientadmissions)<-c("subject_id","hadm_id","icustay_id")

diabY <- icd1 %>% 
         distinct(subject_id,hadm_id,icustay_id,DIAB_FLAG)  %>%
         filter (DIAB_FLAG == "Y") 
COPDY <- icd1 %>% 
  distinct(subject_id,hadm_id,icustay_id,COPD_FLAG)  %>%
  filter (COPD_FLAG == "Y") 

HTY <- icd1 %>% 
  distinct(subject_id,hadm_id,icustay_id,HT_FLAG)  %>%
  filter (HT_FLAG == "Y") 

INFDY <- icd1 %>% 
  distinct(subject_id,hadm_id,icustay_id,INFD_FLAG)  %>%
  filter (INFD_FLAG == "Y") 

EXPFLAG <- icd1 %>% 
  distinct(subject_id,hadm_id,icustay_id,ICUSTAY_EXPIRE_FLAG,ICUSTAY_AGE_GROUP)

patientdisease <- left_join(patientadmissions,diabY,by = c('subject_id','hadm_id','icustay_id') )
patientdisease <- left_join(patientdisease,COPDY,by = c('subject_id','hadm_id','icustay_id'))
patientdisease <- left_join(patientdisease,HTY,by = c('subject_id','hadm_id','icustay_id'))
patientdisease <- left_join(patientdisease,INFDY, by = c('subject_id','hadm_id','icustay_id'))
patientdisease <- left_join(patientdisease,EXPFLAG,by = c('subject_id','hadm_id','icustay_id'))

patientdisease$DIAB_FLAG[is.na(patientdisease$DIAB_FLAG)  ]= "N"
patientdisease$COPD_FLAG[is.na(patientdisease$COPD_FLAG)  ]= "N"
patientdisease$HT_FLAG[is.na(patientdisease$HT_FLAG)  ]= "N"
patientdisease$INFD_FLAG[is.na(patientdisease$INFD_FLAG)  ]= "N"

write.csv(patientdisease,"labelleddisease.csv")

