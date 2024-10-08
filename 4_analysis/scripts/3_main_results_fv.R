
#####################################
# Keep in local
#
# Javier Osorio
# 7/16/2023
# 
# Table of results binary and mcc
#
#####################################



if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, glue, openxlsx, tidyverse, ggplot2, readxl, scales, dplyr, xtable, BSDA)




# MAIN RESULTS - BINARY #####################################



## Get the data --------------------------------------------------

data.bin.en <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/English/English_Binary_full_report.csv',  header = TRUE)
data.bin.es <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/Spanish/Spanish_Binary_full_report.csv',  header = TRUE)
data.bin.ar <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/Arabic/Arabic_Binary_full_report.csv',  header = TRUE)


# data.bin.en <- read.csv(file = 'data/ConfliBERTresults/English_Binary2_full_report.csv',  header = TRUE)
# data.bin.es <- read.csv(file = 'data/ConfliBERTresults/Spanish_Binary2_full_report.csv',  header = TRUE)
# data.bin.ar <- read.csv(file = 'data/ConfliBERTresults/Arabic_Binary2_full_report.csv',  header = TRUE)




## Calculate average results --------------------------------------------------


# English

mean <- data.bin.en %>%
  group_by(model_name) %>%
  dplyr::summarize(mean = mean(f1, na.rm=TRUE)) 

sd <- data.bin.en %>%
  group_by(model_name) %>%
  dplyr::summarize(sd = sd(f1))

results.bin.en.m.sd <- left_join(mean,sd, by="model_name")
results.bin.en.m.sd

rm(mean,sd)



# Spanish

mean <- data.bin.es %>%
  group_by(model_name) %>%
  dplyr::summarize(mean = mean(f1, na.rm=TRUE)) 

sd <- data.bin.es %>%
  group_by(model_name) %>%
  dplyr::summarize(sd = sd(f1))

results.bin.es.m.sd <- left_join(mean,sd, by="model_name") 
results.bin.es.m.sd

rm(mean,sd)


# Arabic

mean <- data.bin.ar %>%
  group_by(model_name) %>%
  dplyr::summarize(mean = mean(f1, na.rm=TRUE)) 

sd <- data.bin.ar %>%
  group_by(model_name) %>%
  dplyr::summarize(sd = sd(f1))

results.bin.ar.m.sd <- left_join(mean,sd, by="model_name") 
results.bin.ar.m.sd

rm(mean,sd)




## t test --------------------------------------------------

# English
# 	ConfliBERT-scr-uncased > bert-base-cased-finetune

ttest.bin.en <- tsum.test(mean.x=as.numeric(results.bin.en.m.sd[4,2]), s.x=as.numeric(results.bin.en.m.sd[4,3]), n.x=50,
                          mean.y=as.numeric(results.bin.en.m.sd[5,2]), s.y=as.numeric(results.bin.en.m.sd[5,3]), n.y=50)

ttest.bin.en    # Not statistically significant



# Spanish
# ConfliBERT-v1-Spanish-beto-cased > beto-cased-finetune

ttest.bin.es <- tsum.test(mean.x=as.numeric(results.bin.es.m.sd[2,2]), s.x=as.numeric(results.bin.es.m.sd[2,3]), n.x=50,
                          mean.y=as.numeric(results.bin.es.m.sd[7,2]), s.y=as.numeric(results.bin.es.m.sd[7,3]), n.y=50)

ttest.bin.es    # Not statistically significant



# Arabic
# ConfliBERT-v2-Arabic-arabertv2 > arabertv2-base-finetune

ttest.bin.ar <- tsum.test(mean.x=as.numeric(results.bin.ar.m.sd[4,2]), s.x=as.numeric(results.bin.ar.m.sd[4,3]), n.x=50,
                          mean.y=as.numeric(results.bin.ar.m.sd[6,2]), s.y=as.numeric(results.bin.ar.m.sd[6,3]), n.y=50)

ttest.bin.ar    # significant at 99%







# MAIN RESULTS - MULTI-CLASS CLASSIFICATION #####################################


## Get the data --------------------------------------------------


data.mcc.en <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/English/English_MultiClass_full_report.csv',  header = TRUE)
data.mcc.es <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/Spanish/Spanish_MultiClass_full_report.csv',  header = TRUE)
data.mcc.ar <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/Arabic/Arabic_MultiClass_full_report.csv',  header = TRUE)



## Calculate average results --------------------------------------------------


# English

mean.macro <- data.mcc.en %>%
  group_by(model_name) %>%
  dplyr::summarize(mean = mean(f1_macro, na.rm=TRUE)) 

sd.macro <- data.mcc.en %>%
  group_by(model_name) %>%
  dplyr::summarize(sd = sd(f1_macro))

results.mcc.en.m.sd.macro <- left_join(mean.macro,sd.macro, by="model_name") 
results.mcc.en.m.sd.macro

rm(mean.macro,sd.macro)


# Spanish

mean.macro <- data.mcc.es %>%
  group_by(model_name) %>%
  dplyr::summarize(mean = mean(f1_macro, na.rm=TRUE)) 

sd.macro <- data.mcc.es %>%
  group_by(model_name) %>%
  dplyr::summarize(sd = sd(f1_macro))

results.mcc.es.m.sd.macro <- left_join(mean.macro,sd.macro, by="model_name")  
results.mcc.es.m.sd.macro

rm(mean.macro,sd.macro)




# Arabic

mean.macro <- data.mcc.ar %>%
  group_by(model_name) %>%
  dplyr::summarize(mean = mean(f1_macro, na.rm=TRUE)) 

sd.macro <- data.mcc.ar %>%
  group_by(model_name) %>%
  dplyr::summarize(sd = sd(f1_macro))

results.mcc.ar.m.sd.macro <- left_join(mean.macro,sd.macro, by="model_name")  
results.mcc.ar.m.sd.macro

rm(mean.macro,sd.macro)






## t test --------------------------------------------------

# English
# ConfliBERT-scr-cased > bert-base-uncased-finetune

ttest.mcc.en <- tsum.test(mean.x=as.numeric(results.mcc.en.m.sd.macro[3,2]), s.x=as.numeric(results.mcc.en.m.sd.macro[3,3]), n.x=50,
                          mean.y=as.numeric(results.mcc.en.m.sd.macro[10,2]), s.y=as.numeric(results.mcc.en.m.sd.macro[10,3]), n.y=50)

ttest.mcc.en    # significant at 99%



# Spanish
# ConfliBERT-v1-Spanish-beto-cased > 	beto-cased-finetune

ttest.mcc.es <- tsum.test(mean.x=as.numeric(results.mcc.es.m.sd.macro[1,2]), s.x=as.numeric(results.mcc.es.m.sd.macro[1,3]), n.x=50,
                          mean.y=as.numeric(results.mcc.es.m.sd.macro[7,2]), s.y=as.numeric(results.mcc.es.m.sd.macro[7,3]), n.y=50)

ttest.mcc.es    # Not statistically significant




# Arabic
# ConfliBERT-v2-Arabic-multilingual-uncased > arabertv2-base-finetune

ttest.mcc.ar <- tsum.test(mean.x=as.numeric(results.mcc.ar.m.sd.macro[5,2]), s.x=as.numeric(results.mcc.ar.m.sd.macro[5,3]), n.x=50,
                          mean.y=as.numeric(results.mcc.ar.m.sd.macro[7,2]), s.y=as.numeric(results.mcc.ar.m.sd.macro[7,3]), n.y=50)

ttest.mcc.ar    # significant at 99%







# Putting results together --------------------------------------------------


# Select columns 

results.bin.en.m.sd        <- results.bin.en.m.sd %>% select(-sd) %>% rename(bin.en = mean)
results.bin.es.m.sd        <- results.bin.es.m.sd %>% select(-sd) %>% rename(bin.es = mean)
results.bin.ar.m.sd        <- results.bin.ar.m.sd %>% select(-sd) %>% rename(bin.ar = mean)
results.mcc.en.m.sd.macro  <- results.mcc.en.m.sd.macro %>% select(-sd) %>% rename(mcc.en = mean)
results.mcc.es.m.sd.macro  <- results.mcc.es.m.sd.macro %>% select(-sd) %>% rename(mcc.es = mean)
results.mcc.ar.m.sd.macro  <- results.mcc.ar.m.sd.macro %>% select(-sd) %>% rename(mcc.ar = mean)


# Rename models

results.bin.en.m.sd        <- results.bin.en.m.sd %>% 
  mutate(model_name=case_when(
    model_name=="bert-base-cased-finetune" ~ "BERT-Case-fine",
    model_name=="bert-base-uncased-finetune" ~ "BERT-Unc-fine",
    model_name=="bert-multilingual-cased-finetune" ~ "mBERT-Case-fine",
    model_name=="bert-multilingual-uncased-finetune" ~ "mBERT-Unc-fine",
    model_name=="ConfliBERT-cont-cased" ~ "ConfliBERT-Cont-Case",
    model_name=="ConfliBERT-cont-uncased" ~ "ConfliBERT-Cont-Unc",
    model_name=="ConfliBERT-scr-cased" ~ "ConfliBERT-Scr-Case",
    model_name=="ConfliBERT-scr-uncased" ~ "ConfliBERT-Scr-Unc",
    model_name=="electra-base-discriminator-finetune" ~ "Electra-dis-fine",
    model_name=="roberta-base-finetune" ~ "RoBERTa-fine",
    TRUE ~ model_name ))

results.bin.es.m.sd        <- results.bin.es.m.sd %>% 
  mutate(model_name=case_when(
    model_name=="beto-cased-finetune" ~ "BETO-Case-fine",
    model_name=="beto-uncased-finetune" ~ "BETO-Unc-fine",
    model_name=="bert-multilingual-cased-finetune" ~ "mBERT-Case-fine",
    model_name=="bert-multilingual-uncased-finetune" ~ "mBERT-Unc-fine",
    model_name=="ConfliBERT-v1-Spanish-beto-cased" ~ "ConfliBERT-BETO-Case",
    model_name=="ConfliBERT-v1-Spanish-beto-uncased" ~ "ConfliBERT-BETO-Unc",
    model_name=="ConfliBERT-v2-Spanish-multilingual-cased" ~ "ConfliBERT-Cont-Case",
    model_name=="ConfliBERT-v2-Spanish-multilingual-uncased" ~ "ConfliBERT-Cont-Unc",
    TRUE ~ model_name ))

results.bin.ar.m.sd        <- results.bin.ar.m.sd %>%   
  mutate(model_name=case_when(
    model_name=="bert-multilingual-cased-finetune" ~ "mBERT-Case-fine",
    model_name=="bert-multilingual-uncased-finetune" ~ "mBERT-Unc-fine",
    model_name=="arabertv2-base-finetune" ~ "AraBERT",
    model_name=="ConfliBERT-v1-Arabic-multilingual-cased" ~ "ConfliBERT-Cont-Case",
    model_name=="ConfliBERT-v2-Arabic-multilingual-uncased" ~ "ConfliBERT-Cont-Unc",
    model_name=="ConfliBERT-v2-Arabic-arabertv2" ~ "ConfliBERT-AraBERT",
    model_name=="ConfliBERT-v2-Arabic-Scratch-60K" ~ "ConfliBERT-Scr-Unc",
    model_name=="ConfliBERT-v2-Arabic-Scratch-65K" ~ "ConfliBERT-Scr-Unc-2",
    TRUE ~ model_name ))

results.mcc.en.m.sd.macro  <- results.mcc.en.m.sd.macro %>%
  mutate(model_name=case_when(
    model_name=="bert-base-cased-finetune" ~ "BERT-Case-fine",
    model_name=="bert-base-uncased-finetune" ~ "BERT-Unc-fine",
    model_name=="bert-multilingual-cased-finetune" ~ "mBERT-Case-fine",
    model_name=="bert-multilingual-uncased-finetune" ~ "mBERT-Unc-fine",
    model_name=="ConfliBERT-cont-cased" ~ "ConfliBERT-Cont-Case",
    model_name=="ConfliBERT-cont-uncased" ~ "ConfliBERT-Cont-Unc",
    model_name=="ConfliBERT-scr-cased" ~ "ConfliBERT-Scr-Case",
    model_name=="ConfliBERT-scr-uncased" ~ "ConfliBERT-Scr-Unc",
    model_name=="electra-base-discriminator-finetune" ~ "Electra-dis-fine",
    model_name=="roberta-base-finetune" ~ "RoBERTa-fine",
    TRUE ~ model_name ))

results.mcc.es.m.sd.macro  <- results.mcc.es.m.sd.macro %>% 
  mutate(model_name=case_when(
    model_name=="beto-cased-finetune" ~ "BETO-Case-fine",
    model_name=="beto-uncased-finetune" ~ "BETO-Unc-fine",
    model_name=="bert-multilingual-cased-finetune" ~ "mBERT-Case-fine",
    model_name=="bert-multilingual-uncased-finetune" ~ "mBERT-Unc-fine",
    model_name=="ConfliBERT-v1-Spanish-beto-cased" ~ "ConfliBERT-BETO-Case",
    model_name=="ConfliBERT-v1-Spanish-beto-uncased" ~ "ConfliBERT-BETO-Unc",
    model_name=="ConfliBERT-v2-Spanish-multilingual-cased" ~ "ConfliBERT-Cont-Case",
    model_name=="ConfliBERT-v2-Spanish-multilingual-uncased" ~ "ConfliBERT-Cont-Unc",
    TRUE ~ model_name ))

results.mcc.ar.m.sd.macro  <- results.mcc.ar.m.sd.macro %>% 
  mutate(model_name=case_when(
    model_name=="bert-multilingual-cased-finetune" ~ "mBERT-Case-fine",
    model_name=="bert-multilingual-uncased-finetune" ~ "mBERT-Unc-fine",
    model_name=="arabertv2-base-finetune" ~ "AraBERT",
    model_name=="ConfliBERT-v1-Arabic-multilingual-cased" ~ "ConfliBERT-Cont-Case",
    model_name=="ConfliBERT-v2-Arabic-multilingual-uncased" ~ "ConfliBERT-Cont-Unc",
    model_name=="ConfliBERT-v2-Arabic-arabertv2" ~ "ConfliBERT-AraBERT",
    model_name=="ConfliBERT-v2-Arabic-Scratch-60K" ~ "ConfliBERT-Scr-Unc",
    model_name=="ConfliBERT-v2-Arabic-Scratch-65K" ~ "ConfliBERT-Scr-Unc-2",
    TRUE ~ model_name ))






# Integrating results

# Binary
results.main.bin <- full_join(results.bin.en.m.sd,results.bin.es.m.sd)
results.main.bin <- full_join(results.main.bin,results.bin.ar.m.sd)
results.main.bin

# MCC
results.main.mcc <- full_join(results.mcc.en.m.sd.macro,results.mcc.es.m.sd.macro)
results.main.mcc <- full_join(results.main.mcc,results.mcc.ar.m.sd.macro)
results.main.mcc



# Export to LaTeX

# Binary
results.main.bin <- xtable(results.main.bin, include.rownames=FALSE , digits=c(0,0,4,4,4))
results.main.bin
print(results.main.bin, file = "tables/results_main_bin.tex", include.rownames=FALSE)

# MCC
results.main.mcc <- xtable(results.main.mcc, include.rownames=FALSE , digits=c(0,0,4,4,4))
results.main.mcc
print(results.main.mcc, file = "tables/results_main_mcc.tex", include.rownames=FALSE)





# End of script