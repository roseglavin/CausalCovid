# CausalCovid

This repo contains the pieces to do Causal Inference on the Risk Factors for COVID.
The general outline is as follows. 
1. Collect Observational Data from the popualtion in general .
   We are using NHANES - Retreived,cleaned and stored in NHANES. 
2. Collect observational data from the ICU
   We are using MIMICIII - etreived, cleaned and stored in MIMIC. We will go back for more data rather than just Risk Factor Flags 
3. COllect Observational data from clinical experience of COVID 
   We are using tables from Research Data . Initially Guan, Grasselli and xie studies.
   
   https://jamanetwork.com/journals/jama/fullarticle/2764365?widget=personalizedcontent&previousarticle=2763401
   https://jamanetwork.com/journals/jama/fullarticle/2765184
4. COllect cause and effect statements from Research Paper .
   We will use Indra to do this https://indra.readthedocs.io/en/latest/
5. Build Knowledge graphs from the cause and effect statements, BEL statements generated
   Recreating Charlies Hoyts pipeine  -   https://bit.ly/bel4corona
   https://academic.oup.com/database/article/doi/10.1093/database/baz068/5521414
6. Attempt to falsify the graphs using the data.
7. The most difficult part of this project is the DATA FUSION problem, techniques to combine 
   data from different sources. 
   https://www.pnas.org/content/113/27/7345/tab-figures-data
