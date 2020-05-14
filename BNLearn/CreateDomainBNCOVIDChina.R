# empty graph
library(bnlearn)

# Define DAG according to Chinese Data Domian knowledge

## We need to leave continous variables out for now 
## because in BN learn we can't have a node with mixed parents. 

dag <- empty.graph(nodes = c("Prevalence","COPD","Corona","InfectedCorona","ICU","RespD","NotCOPDInfected","Death"))
arc.set <- matrix(c( "Prevalence", "COPD", 
                    "COPD","InfectedCorona",
                    "Corona", "InfectedCorona", 
                    "InfectedCorona", "ICU",
                    "COPD", "ICU", 
                    "ICU","RespD",
                    "RespD", "Death",
                    "Corona","NotCOPDInfected",
                    "NotCOPDInfected","ICU"
                    ),
                  byrow = TRUE, ncol = 2,
                  dimnames = list(NULL, c("from", "to")))
arcs(dag) <- arc.set
nodes(dag)
arcs(dag)
graphviz.plot(dag)
modelstring(dag)
Prevalence.lv <- c("Y", "N")
COPD.lv <- c("Y", "N")
ICU.lv <- c("Y", "N")
InfectedCOPD.lv <- c("Y", "N")
RespD.lv <- c("Y", "N")
Death.lv <- c("Y", "N")
Diabetes.lv <-c("Y", "N")
NotCOPDInfected.lv <- c("Y", "N")

Prevalence.prob<- array(c(0.92,0.20),dim =2 , dimnames =list(Prevalence = Prevalence.lv)) 

COPD.prob <- array(c(0.92,0.08), dim = 2, dimnames = list(COPD = COPD.lv))

ICU.prob <- array(c(0.082,0.918), dim = 2, dimnames = list(Diabetes = Diabetes.lv))
RespD.prob <- array(c(0.169,0.831), dim = 2, dimnames = list(Death = Death.lv))
Death.prob <- array(c(0.037,0.963), dim = 2, dimnames = list(RespD = RespD.lv))
InfectedCOPD.prob <- array (c(0.037,0.963), dim = 2, dimnames = list(InfectedCOPD = InfectedCOPD.lv))
cpt <- list(COPD = COPD.prob, ICU = ICU.prob, InfectedCOPD = InfectedCOPD.prob, RespD = RespD.prob, Death = Death.prob)
#Death.prob<-array(c(0.031,0.969), dim = 3, dimnames = list(Death = ))
#Death.prob<-array(c())
#Death.prob <- array(c(.028,.972, ), dim = c(2,4), dimnames = list(Death = Death.lv, COPD = COPD.lv, Diabetes = Diabetes.lv, HT = HT.lv, CVD = CVD.lv ))
cpt

