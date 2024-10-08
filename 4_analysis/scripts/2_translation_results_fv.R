#####################################
# Keep in local
#
# Javier Osorio
# 7/16/2023
# 
# Table of results - translation
#
#####################################


if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, glue, openxlsx, tidyverse, ggplot2, readxl, scales, dplyr, xtable, BSDA)


# TABLE III - TRANSLATION EVALUATON METRICS #####################################


## Get the data --------------------------------------------------

data.trans.google       <- read.csv("https://raw.githubusercontent.com/javierosorio/keep_it_local/main/2_quality_analysis/AR%26ES_to_EN/Ar%26Es_To_En_Quality%20Evaluation%20Analysis/Google/Translation_Statistics%20(5).csv",  header = TRUE)
data.trans.deepl        <- read.csv("https://raw.githubusercontent.com/javierosorio/keep_it_local/main/2_quality_analysis/AR%26ES_to_EN/Ar%26Es_To_En_Quality%20Evaluation%20Analysis/DeepL/DeepLTranslation_Statistics%20(1).csv",  header = TRUE)
data.trans.deep         <- read.csv("https://raw.githubusercontent.com/javierosorio/keep_it_local/main/2_quality_analysis/AR%26ES_to_EN/Ar%26Es_To_En_Quality%20Evaluation%20Analysis/Deep/DeepTranslation_Statistics%20(1).csv",  header = TRUE)
data.trans.transformers <- read.csv("https://raw.githubusercontent.com/javierosorio/keep_it_local/main/2_quality_analysis/AR%26ES_to_EN/Ar%26Es_To_En_Quality%20Evaluation%20Analysis/Transformers/Transformers_Translation_Statistics%20(1).csv",  header = TRUE)





## Clean up the data --------------------------------------------------

data.trans.google       <- data.trans.google %>% select(Language, Metric, Average.Score) %>% rename(Google = Average.Score)
data.trans.deepl        <- data.trans.deepl %>% select(Language, Metric, Average.Score) %>% rename(DeepL = Average.Score)
data.trans.deep         <- data.trans.deep %>% select(Language, Metric, Average.Score) %>% rename(Deep = Average.Score)
data.trans.transformers <- data.trans.transformers %>% select(Language, Metric, Average.Score) %>% rename(Trans = Average.Score)





## Merge data into single df --------------------------------------------------

data.trans <- left_join(data.trans.google,data.trans.deepl, by=c("Language","Metric"))
data.trans <- left_join(data.trans,data.trans.deep, by=c("Language","Metric"))
data.trans <- left_join(data.trans,data.trans.transformers, by=c("Language","Metric"))


# Clean Language variable 
data.trans  <-  data.trans %>% 
  mutate(Language = case_when(
    Language=="Arabic" ~ "AR-EN",
    Language=="Spanish" ~ "ES-EN"))







## Export to Latex --------------------------------------------------

data.trans.accuracy <- xtable(data.trans, include.rownames=FALSE , digits=c(0,0,0,4,4,4,4))
data.trans.accuracy
print(data.trans.accuracy, file = "tables/translation_accuracy.tex", include.rownames=FALSE)


#





















# TABLE IV - TRANSLATION RESULTS #####################################



## Get the data --------------------------------------------------


data.trans.bin.sp <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/DeepL_English/ES_EN_DEEPL_Binary_full_report.csv',  header = TRUE)
data.trans.bin.ar <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/DeepL_English/AR_EN_DEEPL_Binary_full_report.csv',  header = TRUE)
data.trans.mcc.sp <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/DeepL_English/ES_EN_DEEPL_MultiClass_full_report.csv',  header = TRUE)
data.trans.mcc.ar <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/DeepL_English/AR_EN_DEEPL_MultiClass_full_report.csv',  header = TRUE)


# data.trans.bin.sp <- read.csv(file = 'data/ConfliBERTresults/SP_EN_DEEPL_binary2_full_report.csv',  header = TRUE)
# data.trans.bin.ar <- read.csv(file = 'data/ConfliBERTresults/AR_EN_DEEPL_binary2_full_report.csv',  header = TRUE)
# data.trans.mcc.sp <- read.csv(file = 'data/ConfliBERTresults/SP_EN_DEEPL_MultiClass2_full_report.csv',  header = TRUE)
# data.trans.mcc.ar <- read.csv(file = 'data/ConfliBERTresults/AR_EN_DEEPL_MultiClass2_full_report.csv',  header = TRUE)



# check names
names(data.trans.bin.sp)
names(data.trans.bin.ar)
names(data.trans.mcc.sp)
names(data.trans.mcc.ar)




## Calculate average results --------------------------------------------------

# Spanish - Binary

mean <- data.trans.bin.sp %>%
  group_by(model_name) %>%
  dplyr::summarize(mean = mean(f1, na.rm=TRUE)) 

sd <- data.trans.bin.sp %>%
  group_by(model_name) %>%
  dplyr::summarize(sd = sd(f1))

results.trans.bin.sp.m.sd <- left_join(mean,sd, by="model_name")
results.trans.bin.sp.m.sd

rm(mean,sd)


# Arabic - Binary

mean <- data.trans.bin.ar %>%
  group_by(model_name) %>%
  dplyr::summarize(mean = mean(f1, na.rm=TRUE)) 

sd <- data.trans.bin.ar %>%
  group_by(model_name) %>%
  dplyr::summarize(sd = sd(f1))

results.trans.bin.ar.m.sd <- left_join(mean,sd, by="model_name") 
results.trans.bin.ar.m.sd

rm(mean,sd)





# Spanish - MCC

mean <- data.trans.mcc.sp %>%
  group_by(model_name) %>%
  dplyr::summarize(mean = mean(f1_macro, na.rm=TRUE)) 

sd <- data.trans.mcc.sp %>%
  group_by(model_name) %>%
  dplyr::summarize(sd = sd(f1_macro))

results.trans.mcc.sp.m.sd <- left_join(mean,sd, by="model_name") 
results.trans.mcc.sp.m.sd

rm(mean,sd)




# Arabic - MCC

mean <- data.trans.mcc.ar %>%
  group_by(model_name) %>%
  dplyr::summarize(mean = mean(f1_macro, na.rm=TRUE)) 

sd <- data.trans.mcc.ar %>%
  group_by(model_name) %>%
  dplyr::summarize(sd = sd(f1_macro))

results.trans.mcc.ar.m.sd <- left_join(mean,sd, by="model_name") 
results.trans.mcc.ar.m.sd

rm(mean,sd)








## t test --------------------------------------------------

# Spanish - Binary
# ConfliBERT-scr-uncased > bert-base-uncased-finetune

ttest.trans.bin.sp <- tsum.test(mean.x=as.numeric(results.trans.bin.sp.m.sd[4,2]), s.x=as.numeric(results.trans.bin.sp.m.sd[4,3]), n.x=50,
                                mean.y=as.numeric(results.trans.bin.sp.m.sd[6,2]), s.y=as.numeric(results.trans.bin.sp.m.sd[6,3]), n.y=50)

ttest.trans.bin.sp    # significant at 95%



# Arabic - Binary
# ConfliBERT-scr-uncased > bert-base-uncased-finetune

ttest.trans.bin.ar <- tsum.test(mean.x=as.numeric(results.trans.bin.ar.m.sd[4,2]), s.x=as.numeric(results.trans.bin.ar.m.sd[4,3]), n.x=50,
                                mean.y=as.numeric(results.trans.bin.ar.m.sd[6,2]), s.y=as.numeric(results.trans.bin.ar.m.sd[6,3]), n.y=50)

ttest.trans.bin.ar    # significant at 99%



# Spanish - MCC
#  ConfliBERT-cont-cased > electra-base-discriminator-finetune

ttest.mcc.sp <- tsum.test(mean.x=as.numeric(results.trans.mcc.sp.m.sd[1,2]), s.x=as.numeric(results.trans.mcc.sp.m.sd[1,3]), n.x=50,
                          mean.y=as.numeric(results.trans.mcc.sp.m.sd[9,2]), s.y=as.numeric(results.trans.mcc.sp.m.sd[9,3]), n.y=50)

ttest.mcc.sp    # not statistically significant



# Arabic - MCC
# ConfliBERT-scr-uncased >  bert-base-uncased-finetune

ttest.mcc.ar <- tsum.test(mean.x=as.numeric(results.trans.mcc.ar.m.sd[4,2]), s.x=as.numeric(results.trans.mcc.ar.m.sd[4,3]), n.x=50,
                          mean.y=as.numeric(results.trans.mcc.ar.m.sd[6,2]), s.y=as.numeric(results.trans.mcc.ar.m.sd[6,3]), n.y=50)

ttest.mcc.ar    # not statistically significant






## Integrate results --------------------------------------------------

# Rename variables

results.trans.bin.sp <- results.trans.bin.sp.m.sd %>% select(-sd) %>% rename(bin.sp=mean)
results.trans.mcc.sp <- results.trans.mcc.sp.m.sd %>% select(-sd) %>% rename(mcc.sp=mean)
results.trans.bin.ar <- results.trans.bin.ar.m.sd %>% select(-sd) %>% rename(bin.ar=mean)
results.trans.mcc.ar <- results.trans.mcc.ar.m.sd %>% select(-sd) %>% rename(mcc.ar=mean)





# Integrate results in a single table

results.trans <- left_join(results.trans.bin.sp,results.trans.mcc.sp)
results.trans <- left_join(results.trans,results.trans.bin.ar)
results.trans <- left_join(results.trans,results.trans.mcc.ar)

results.trans



# Export to LaTeX

results.trans <- xtable(results.trans, include.rownames=FALSE , digits=c(0,0,4,4,4,4))
results.trans
print(results.trans, file = "tables/results_trans.tex", include.rownames=FALSE)





# End of script