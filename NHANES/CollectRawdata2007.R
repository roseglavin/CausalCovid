## Curate dataset to answer questions about thyroid function 
## and physical and mental health. 
## Written by R. Glavin March 2020 
## HS651 
## Data taken from NHANES 2007/2008 dataset. 
## Quantitative data for relationship between hormone levels
## taken from laboratory dataset 

## Used Tutorials on NHANES Website as starting point
## https://wwwn.cdc.gov/nchs/data/tutorials/module3_examples_R.r
## Downloaded Datafiles from the 20072008 dataset at
## https://wwwn.cdc.gov/nchs/nhanes/Search/DataPage.aspx?Component=Laboratory&CycleBeginYear=2007

setwd ('C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES')
# Include Foreign Package To Read SAS Transport Files
library(foreign)
library(dplyr)

# Create data frame from saved XPT file
# Start with the Thyroid Lab file 
ThyroidLabs <- read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\THYROD_E.xpt")

#TriglyLabs <- read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\THIGLY_E.xpt")
#Tchollabs <- read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\TCHOL_E.xpt")
#HDLLabs <- read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\HDL_E.xpt")
#Glucose <- read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\GlU_E.xpt")

#https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/CBC_E.htm
CBC <- read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\CBC_E.xpt")
#https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/UIO_E.htm
Iodine <- read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\UIO_E.xpt")
#https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/CBC_E.htm
GlucoHemoglobin <- read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\GHB_E.xpt")
#FattyAcids <-read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\FAS_E.xpt")

### Questionaires 
MedicalConditions <- read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\MCQ_E.xpt")
Prescriptions <- read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\RXQ_RX_E.xpt")
Drugsinfo <-read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\RXQ_DRUG.xpt")
ReproductiveHealth <-read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\RHQ_E.xpt")
DailyPhysical <-read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\DPQ_E.xpt")
MentalHealth <-read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\HSQ_E.xpt")
PhysicalFunction <- read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\PFQ_E.xpt")
SleepDisoder <- read.xport("C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\XPTFILES\\SLQ_E.xpt")


ThyroidLabsMinimal = data.frame(ThyroidLabs$SEQN,ThyroidLabs$LBXT3F ,  ThyroidLabs$LBXT4F ,ThyroidLabs$LBXTSH1  ,ThyroidLabs$LBXTPO, ThyroidLabs$LBXTT3, ThyroidLabs$LBXTT4)

names(ThyroidLabsMinimal)<- c("SEQN","FT3","FT4","TSH","TPO", "TT3","TT4")

##Did the 1000 records to create a smaller dataset for casual fusion.
##saveRDS(ThyroidLabsMinimal[1:1000, ], file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007THYROIDLABS.rds")
saveRDS(ThyroidLabsMinimal, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007THYROIDLABS.rds")




# Ever told by professional that you have a thyroid conditon?
#https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/MCQ_E.htm#MCQ160m
# Code or Value	Value Description	Count	Cumulative	Skip to Item
#1	Yes	       511	511	
#2	No	       5033	5544	MCQ160k
#7	Refused	1	 5545	MCQ160k
#9	Don't know   14	5559	MCQ160k
#   .	Missing	  3805 9364	
#ThyroidCond=data.frame(MedicalConditions$SEQN,MedicalConditions$MCQ170M)
# Not including "ever" had a thyroid condition for now. 

#Still a thyroid condition MCQ170m  ( MAKE this field out label)
ThyroidCond=data.frame(MedicalConditions$SEQN, rep(0,nrow(MedicalConditions)))
names(ThyroidCond) <- c("SEQN","CurrentThyroidCon")
ThyroidCond$CurrentThyroidCon[MedicalConditions$MCQ170M ==1]=1 # code 1 is current thyroid condition

labelledlabs <-merge (ThyroidLabsMinimal,ThyroidCond,by = 'SEQN')
labelledlabs <- na.omit(labelledlabs)
saveRDS(labelledlabs, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007THYROIDLABSLABELLED.rds")




####Medicated for Thyroid Condition
patientmedications <- merge(labelledlabs, Prescriptions, by='SEQN')
patientmedications <- data.frame(patientmedications,rep(0,nrow(patientmedications)))
patientmedications <- data.frame(patientmedications,rep(0,nrow(patientmedications)))
patientmedications <- data.frame(patientmedications,rep(0,nrow(patientmedications)))
patientmedications <- data.frame(patientmedications,rep(0,nrow(patientmedications)))
names(patientmedications)[15]="Thyroidmed"
names(patientmedications)[16]="T3Med"
names(patientmedications)[17]="T4Med"
names(patientmedications)[18]="PsyMed"

### These following RXDDRGIDs are the drugs that are noted as "THYROID HORMONES" in RXDDCN1B of DrugsInfo taken from RXQ_DRUG.xpt

### "antithyroid hormones or the Iodine variations" included in Thyroidmed

patientmedications$Thyroidmed[patientmedications$RXDDRGID == "d00278"]=1 # LEVOTHYROXINE T4
patientmedications$T4Med[patientmedications$RXDDRGID == "d00278"]=1 # LEVOTHYROXINE T4

# NDT- T4, T3 and more  

patientmedications$Thyroidmed[patientmedications$RXDDRGID == "d00655"]=1 # NDT
patientmedications$T3Med[patientmedications$RXDDRGID == "d00655"]=1 # NDT
patientmedications$T4Med[patientmedications$RXDDRGID == "d00655"]=1 # NDT

# LIOTHYRONINE T3
patientmedications$Thyroidmed[patientmedications$RXDDRGID == "d00658"]=1 # LIOTHYRONINE T3
patientmedications$T3Med[patientmedications$RXDDRGID == "d00658"]=1 

# THYROID HORMONES - UNSPECIFIED ****assume T4*** , unlikely to be T3 
patientmedications$Thyroidmed[patientmedications$RXDDRGID == "c00103"]=1 # THYROID HORMONES - UNSPECIFIED

# LIOTRIX T3 
patientmedications$Thyroidmed[patientmedications$RXDDRGID == "d00659"]=1 # LIOTRIX T3 
patientmedications$T3Med[patientmedications$RXDDRGID == "d00659"]=1 

# LEVOTHYROXINE; LIOTHYRONINE Combined T3 and T4 
patientmedications$Thyroidmed[patientmedications$RXDDRGID == "h00019"]=1 # LEVOTHYROXINE; LIOTHYRONINE
patientmedications$T3Med[patientmedications$RXDDRGID == "h00019"]=1 # LEVOTHYROXINE; LIOTHYRONINE
patientmedications$T4Med[patientmedications$RXDDRGID == "h00019"]=1 # LEVOTHYROXINE; LIOTHYRONINE

### Now adding in antithyroid hormones , ** Categorize as Thyroid Med but not T3 or T4 ****
patientmedications$Thyroidmed[patientmedications$RXDDRGID == "d00290"]=1 # METHIMAZOLE 
patientmedications$Thyroidmed[patientmedications$RXDDRGID == "d00361"]=1 # PROPYLTHIOURACIL
patientmedications$Thyroidmed[patientmedications$RXDDRGID == "d00800"]=1 # POTASSIUM IODIDE
patientmedications$Thyroidmed[patientmedications$RXDDRGID == "d03277"]=1 # POTASSIUM IODIDE; THEOPHYLLINE
patientmedications$Thyroidmed[patientmedications$RXDDRGID == "d03287"]=1 # EPHEDRINE; PHENOBARBITAL; POTASSIUM IODIDE; THEOP
patientmedications$Thyroidmed[patientmedications$RXDDRGID == "d03399"]=1 # CHLORPHENIRAMINE; CODEINE; PHENYLEPHRINE; POTASSI
patientmedications$Thyroidmed[patientmedications$RXDDRGID == "d04828"]=1 # TERIPARATIDE
patientmedications$Thyroidmed[patientmedications$RXDDRGID == "h00019"]=1 # POTASSIUM IODIDE


patientmedications$Thyroidmed[patientmedications$Thyroidmed != 1]=0 # Everything else is not a thyroid med


### NOw include Psychotropic Medications 
patientmedications$PsyMed[patientmedications$RXDDRGID == "a70010"]=1 # SEROTONIN
patientmedications$PsyMed[patientmedications$RXDDRGID == "c00242"]=1 # PSYCHOTHERAPEUTIC AGENTS - UNSPECIFIED
patientmedications$PsyMed[patientmedications$RXDDRGID == "c00249"]=1 # ANTIDEPRESSANTS - UNSPECIFIED
patientmedications$PsyMed[patientmedications$RXDDRGID == "c00250"]=1 # MONOAMINE OXIDASE INHIBITORS - UNSPECIFIED
patientmedications$PsyMed[patientmedications$RXDDRGID == "c00251"]=1 # ANTIPSYCHOTICS - UNSPECIFIED
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00027"]=1 # HALOPERIDOL
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00061"]=1 # LITHIUM
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00064"]=1 # CHLORPROMAZINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00144"]=1 # NORTRIPTYLINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00145"]=1 # DESIPRAMINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00146"]=1 # AMITRIPTYLINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00181"]=1 # BUPROPION
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00199"]=1 # CLOZAPINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00217"]=1 # DOXEPIN
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00236"]=1 # FLUOXETINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00237"]=1 # FLUPHENAZINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00259"]=1 # IMIPRAMINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00355"]=1 # PROCHLORPERAZINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00389"]=1 # THIORIDAZINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00391"]=1 # THIOTHIXENE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00395"]=1 # TRAZODONE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00855"]=1 # PERPHENAZINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00873"]=1 # TRIMIPRAMINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00874"]=1 # AMOXAPINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00875"]=1 # PROTRIPTYLINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00876"]=1 # CLOMIPRAMINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00877"]=1 # MAPROTILINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00880"]=1 # SERTRALINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00882"]=1 # ISOCARBOXAZID
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00883"]=1 # PHENELZINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00884"]=1 # TRANYLCYPROMINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00889"]=1 # MESORIDAZINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00890"]=1 # TRIFLUOPERAZINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00896"]=1 # MOLINDONE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00897"]=1 # LOXAPINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00898"]=1 # PIMOZIDE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d00976"]=1 # SELEGILINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d03157"]=1 # PAROXETINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d03180"]=1 # RISPERIDONE 
patientmedications$PsyMed[patientmedications$RXDDRGID == "d03181"]=1 # VENLAFAXINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d03462"]=1 # AMITRIPTYLINE; CHLORDIAZEPOXIDE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d03463"]=1 # AMITRIPTYLINE; PERPHENAZINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d03804"]=1 # FLUVOXAMINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d03808"]=1 # NEFAZODONE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d04025"]=1 # MIRTAZAPINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d04050"]=1 # OLANZAPINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d04220"]=1 # QUETIAPINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d04332"]=1 # CITALOPRAM
patientmedications$PsyMed[patientmedications$RXDDRGID == "d04747"]=1 # ZIPRASIDONE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d04812"]=1 # ESCITALOPRAM
patientmedications$PsyMed[patientmedications$RXDDRGID == "d04825"]=1 # ARIPIPRAZOLE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d04917"]=1 # FLUOXETINE; OLANZAPINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d05355"]=1 # DULOXETINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d06297"]=1 # PALIPERIDONE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d06635"]=1 # MILNACIPRAN
patientmedications$PsyMed[patientmedications$RXDDRGID == "d07113"]=1 # DESVENLAFAXINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d07441"]=1 # ILOPERIDONE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d07473"]=1 # ASENAPINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d07705"]=1 # LURASIDONE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d07740"]=1 # VILAZODONE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d08114"]=1 # LEVOMILNACIPRAN
patientmedications$PsyMed[patientmedications$RXDDRGID == "d08125"]=1 # VORTIOXETINE
patientmedications$PsyMed[patientmedications$RXDDRGID == "d08288"]=1 # BUPROPION; NALTREXONE




patientmedications$PsyMed[patientmedications$RXDDRGID == "d08373"]=1 # BREXPIPRAZOLE
patientmedications$PsyMed[patientmedications$RXDDRGID == "h00035"]=1 # AGOMELATINE


PatientThyroidMed <- data.frame(SEQN =sort(unique(patientmedications$SEQN)),ThyroidMed= tapply(patientmedications$Thyroidmed,patientmedications$SEQN,max), T3Med = tapply(patientmedications$T3Med,patientmedications$SEQN,max), T4Med = tapply(patientmedications$T4Med,patientmedications$SEQN,max), PsyMed = tapply(patientmedications$PsyMed,patientmedications$SEQN,max))

labelledLabsMeds <- merge (labelledlabs, PatientThyroidMed, by = 'SEQN' )

#merge (labelledlabs, PatientThyroidMed, by = 'SEQN')
labelledLabsTSHHigh <- na.omit(labelledLabsMeds[(labelledLabsMeds$TSH > 2.5 ), ])
labelledLabsTSHHighIod <- merge (labelledLabsTSHHigh,Iodine,by = 'SEQN')
labelledLabsTMed <- na.omit(labelledLabsMeds[(labelledLabsMeds$ThyroidMed == 1), ])
labelledLabsNoTMed <- na.omit(labelledLabsMeds[(labelledLabsMeds$ThyroidMed != 1), ])
labelledLabsNoTOrPsyMed <-na.omit(labelledLabsMeds[((labelledLabsMeds$ThyroidMed != 1) &(labelledLabsMeds$PsyMed != 1)) , ])
saveRDS(labelledLabsMeds, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007THYROIDLABSLABELLEDMeds.rds")
saveRDS(labelledLabsTMed, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007labelledLabsTMed.rds")
write.csv(labelledLabsTMed, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007labelledLabsTMed.csv") 
write.csv(labelledLabsTSHHigh, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007labelledLabsTSHHigh2pt5.csv") 
saveRDS(labelledLabsNoTMed, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007labelledLabsNoTMed.rds")
saveRDS(labelledLabsNoTOrPsyMed, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007labelledLabsNoTOrPsyMed.rds")

#limited in any way in any activity because of a physical, mental or emotional problem?
## https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/PFQ_I.htm#PFQ059

#Code or Value	Value Description	Count	Cumulative	Skip to Item
#1	Yes	       116	116	
#2	No	      4015	4131	
#7	Refused	      0	4131	
#9	Don't know	  3	4134	
#.	Missing	   4857	8991	
PhysicalCapacity = data.frame(PhysicalFunction$SEQN,PhysicalFunction$PFQ059)
names(PhysicalCapacity)<- c("SEQN","Wellbeing")
labelledPhysicalHealth <- merge(labelledLabsMeds,PhysicalCapacity , by = 'SEQN')
labelledPhysicalHealthNoTMeds <- na.omit(merge(labelledLabsNoTMed,PhysicalCapacity , by = 'SEQN'))
labelledPhysicalHealthNoTOrPsyMeds <- na.omit(merge(labelledLabsNoTOrPsyMed,PhysicalCapacity , by = 'SEQN'))
labelledPhysicalHealth$Wellbeing[labelledPhysicalHealth$Wellbeing == "1"]=0  # They report limitation so not well 
labelledPhysicalHealth$Wellbeing[labelledPhysicalHealth$Wellbeing == "2"]=1  # They report no limitation, so they are well
labelledPhysicalHealth$Wellbeing[labelledPhysicalHealth$Wellbeing =="9"]= 0  # They are unsure, so **assume** not well
#labelledPhysicalHealth$Wellbeing[labelledPhysicalHealth$Wellbeing =="."]="na"  # They are unsure, so **assume**  not well
labelledPhysicalHealthNoTMeds$Wellbeing[labelledPhysicalHealthNoTMeds$Wellbeing == "1"]=0  # They report limitation so not well 
labelledPhysicalHealthNoTMeds$Wellbeing[labelledPhysicalHealthNoTMeds$Wellbeing == "2"]=1  # They report no limitation, so they are well
labelledPhysicalHealthNoTMeds$Wellbeing[labelledPhysicalHealthNoTMeds$Wellbeing =="9"]= 0  # They are unsure, so assume not well

labelledPhysicalHealthNoTOrPsyMeds$Wellbeing[labelledPhysicalHealthNoTOrPsyMeds$Wellbeing == "1"]=0  # They report limitation so not well 
labelledPhysicalHealthNoTOrPsyMeds$Wellbeing[labelledPhysicalHealthNoTOrPsyMeds$Wellbeing == "2"]=1  # They report no limitation, so they are well
labelledPhysicalHealthNoTOrPsyMeds$Wellbeing[labelledPhysicalHealthNoTOrPsyMeds$Wellbeing =="9"]= 0  # They are unsure, so assume not well


#labelledPhysicalHealthNoTMeds$Wellbeing[labelledPhysicalHealthNoTMeds$Wellbeing =="."]=   # They are unsure, so assume not well


saveRDS(labelledPhysicalHealth, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007PhysicalHealthMeds.rds")
saveRDS(labelledPhysicalHealthNoTMeds, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007PhysicalHealthNoTMeds.rds")
saveRDS(labelledPhysicalHealthNoTOrPsyMeds, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007PhysicalHealthNoTorPsyMeds.rds")




### Reproductive Health 

#https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/RHQ_E.htm
OCP = data.frame(ReproductiveHealth$SEQN, ReproductiveHealth$RHD042, ReproductiveHealth$RHD442, ReproductiveHealth$RHQ420,ReproductiveHealth$RHQ460Q, ReproductiveHealth$RHQ540)

names(OCP)[1] <-"SEQN"

saveRDS(OCP, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007OCP.rds")





###### NOTE : Interesting mismatch between people reporting they are 
###### well but they have depression and anxiety . So maybe they just get on?
###### ALso notice patients with anxiety , taking T4, not feeling well. TSH suppressed 
###### 43877 is an example 

# Num days mental health not good in last 30 days
#https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/HSQ_E.htm#HSQ480

## Code or Value	Value Description	Count	Cumulative	Skip to Item
## 0 to 30	Range of Values	5884	5884	
## 77	Refused	                 0	5884	
## 99	Don't know              	7	5891	
## Missing	                 3065	8956	
Depression =data.frame(MentalHealth$SEQN,MentalHealth$HSQ480)
names(Depression)<- c("SEQN","CountDepression")
#### Fix NAs later 
Depression$CountDepression[ Depression$CountDepression=="99"]= 0# They are unsure, so **assume** not well
Depression$CountDepression[ Depression$CountDepression=="77"]= 0
Depression$CountDepression[ Depression$CountDepression=="."]= 0
labelledMentalHealth <- merge(labelledPhysicalHealth, Depression, by = 'SEQN')
labelledMentalHealthNoTMeds <- merge(labelledPhysicalHealthNoTMeds, Depression, by = 'SEQN')
labelledMentalHealthNoTOrPsyMeds <- merge(labelledPhysicalHealthNoTOrPsyMeds, Depression, by = 'SEQN')

# Num days Anxious in last 30 days 
# https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/HSQ_E.htm#HSQ496
#
##Code or Value	Value Description	Count	Cumulative	Skip to Item
##  0 to 30	Range of Values	5883	5883	
##  77	Refused	               1	5884	
##  99	Don't know	           5	5889	
##   .	Missing	             3067	8956	
Anxiety = data.frame(MentalHealth$SEQN,MentalHealth$HSQ496)
names(Anxiety)<- c("SEQN","CountAnxiety")
Anxiety$CountAnxiety[ Anxiety$CountAnxiety=="99"]= 0
Anxiety$CountAnxiety[ Anxiety$CountAnxiety=="77"]= 0
Anxiety$CountAnxiety[ Anxiety$CountAnxiety=="."]= 0
labelledMentalHealth <- na.omit(merge(labelledMentalHealth, Anxiety, by = 'SEQN'))
labelledMentalHealthNoTMeds <- na.omit(merge(labelledMentalHealthNoTMeds, Anxiety, by = 'SEQN'))
labelledMentalHealthNoTOrPsyMeds <- na.omit(merge(labelledMentalHealthNoTOrPsyMeds, Anxiety, by = 'SEQN'))

saveRDS(labelledMentalHealth, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007LABELLEDMentalHealth.rds")

write.csv(labelledMentalHealth, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007LABELLEDMentalHealth.csv") 
write.csv(labelledMentalHealthNoTMeds, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007LABELLEDMentalHealthNoTMeds.csv") 
write.csv(labelledMentalHealthNoTOrPsyMeds, file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007LABELLEDMentalHealthNoTOrPsyMeds.csv") 

write.csv(labelledMentalHealth[1:1000, ], file="C:\\Users\\roseg\\HS651\\NHANES\\data\\20072008\\CreatedRDSFiles\\2007smallLABELLEDMentalHealth.csv") 
