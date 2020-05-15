# CausalCovid

This repo contains the pieces to do Causal Inference on the Risk Factors for COVID.
The general outline is as follows.  We are seeing chronic diseases get lots of attention as risk factors for covid, but 
this patient population is the same population that typically becomes ill and faces the highest risk of mortality in the ICU. 
There is significant research showing the risks to these patients with any infactious disease. We want to try to quantify 
the additional risk of Covid. Is it just that more patients become ill because of the reproductive ability of covid, or are there
other factors (like medications, as has been hypothesized) causing these patients to have a higher risk?
We will start by establishing baselines for these patients in the population and in the ICU. Then try to come up with Joint Probability Distributions to estimate the current impact. 
These are the high level steps.

1. Collect Observational Data from the population in general .
   We are using the public NHANES dataset  - Retreived,cleaned and stored in NHANES. Right now we just have patient and condition, 
   but we are primed to get medications, socio economic, food security, health insurance, psycho social issues, physical activity. 
2. Collect observational data from the ICU
   We are using MIMICIII - retreived, cleaned and stored in MIMIC. We will go back for more data rather than just Risk Factor Flags 
3. COllect Observational data from clinical experience of COVID 
   We are using tables from Research Data . Initially Guan, Grasselli and xie studies.
   
   https://erj.ersjournals.com/content/early/2020/03/17/13993003.00547-2020
   https://jamanetwork.com/journals/jama/fullarticle/2764365?widget=personalizedcontent&previousarticle=2763401
   https://jamanetwork.com/journals/jama/fullarticle/2765184
4. Collect cause and effect statements from Research Papers.
   We will initially use Indra to do this https://indra.readthedocs.io/en/latest/
5. We will use a curation process to validate the NLP and rules based causal output. It is looking like
   biodati will be the curation platform, but we might end up using hypothes.is. TBD 
6. Build Knowledge graphs from the cause and effect statements, BEL statements generated
   Recreating Charlies Hoyts pipeine  -   https://bit.ly/bel4corona
   https://academic.oup.com/database/article/doi/10.1093/database/baz068/5521414
   Charlie Hoyt is actively helping and working on this pipeline with us. 
7. Attempt to falsify the graphs using the data.
8. The most difficult part of this project is the Data Fusion problem, techniques to combine 
   data from different sources. 
   https://www.pnas.org/content/113/27/7345/tab-figures-data Elias Boreinbaum, the author of this study has agreed to help us 
   apply his techniques to this pipeline. ( Thank you Jeremy Zucker!) 
9. Try to establish root causes or at least identify latent factors contributing to the poor health of highly comorbid patients
# BELSTATEMENTS and BELCORONA 
Contains  clone of Charlie Hoyts examples for CoronaWhy. Right now (at CoronaWhy) we are focused on building the pipeline for
Jeremy Zucker's molecular causal project.  This is mainly infrastructure focused for now. Once the infrastructure (INDRA,PyBEl,BioDati curation) is in place, we can deploy the same process for the Risk Factors project. 
# BNLEARN
Contains some initial simple models with conditional probablity tables from pieces of early data. Purely PoC, idea generation.
# Causal Fusion 
Contains the output of very basic directed graphs created using Causal Fusion and tested against first round of MIMIC data
# Documents 
Contains initial project proposal and a presentation talking about the motivation. 
In case more motivation is needed this study we just published, highlighting the issues we have with corona risk factors. 
https://www.medrxiv.org/content/10.1101/2020.05.04.20090506v2.full.pdf


