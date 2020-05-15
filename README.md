# CausalCovid

This repo contains the pieces to do Causal Inference on the Risk Factors for COVID.
The general outline is as follows. 
1. Collect Observational Data from the popualtion in general .
   We are using NHANES - Retreived,cleaned and stored in NHANES. 
2. Collect observational data from the ICU
   We are using MIMICIII - retreived, cleaned and stored in MIMIC. We will go back for more data rather than just Risk Factor Flags 
3. COllect Observational data from clinical experience of COVID 
   We are using tables from Research Data . Initially Guan, Grasselli and xie studies.
   https://erj.ersjournals.com/content/early/2020/03/17/13993003.00547-2020
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
8. Try to establish root causes or at least identify latent factors contributing to the poor health of high comorbid patients
# BELSTATEMENTS and BELCORONA 
Contains  clone of Charlie Hoyts examples for CoronaWhy. Right now (at CoronaWhy) we are focused on building the pipeline for
Jeremy Zucker's molecular causal project.  This is mainly infrastructure focused for now. Once the infrastructure (INDRA,PyBEl,BioDati curation) is in place, we can deploy the same process for the Risk Factors project. 
# BNLEARN
Contains some initial simple models with conditional probablity tables from pieces of early data. Purely PoC, idea generation.
# Causal Fusion 
COntains the output of very basic directed graphs created using Causal Fusion and tested against first round of MIMIC data
# Documents 
COntains initial project proposal and a presentation talking about the motivation. 
In case more motivation is needed this study we just published, highlighting the issues we have with corona risk factors. 
https://www.medrxiv.org/content/10.1101/2020.05.04.20090506v2.full.pdf


