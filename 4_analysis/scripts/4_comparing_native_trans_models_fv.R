
#####################################
# Keep in local
#
# Javier Osorio
# 7/16/2023
# 
# Comparing models in native and translated text
#
#####################################




if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, glue, openxlsx, tidyverse, ggplot2, readxl, scales, dplyr, xtable, BSDA)







# COMPARING NATIVE AND TRANSLATED #####################################


# ES-EN translated
# - Bin ConfliBERT-Scr-Unc 0.9256
# - MCC ConfliBERT-Cont-Case 0.6305
# 
# AR-EN translated
# - Bin ConfliBERT-Scr-Unc 0.9176
# - MCC ConfliBERT-Scr-Unc 0.6682
#
#
# ES
# - Bin ConfliBERT-BETO-Unc 0.9166
# - MCC ConfliBERT-BETO-Case 0.6409
#
# AR
# - Bin ConfliBERT-AraBERT 0.9075
# - MCC ConfliBERT-Cont-Unc 0.6291
#
#






## Get the data --------------------------------------------------

# Translation data
data.trans.bin.es <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/DeepL_English/ES_EN_DEEPL_Binary_full_report.csv',  header = TRUE)
data.trans.bin.ar <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/DeepL_English/AR_EN_DEEPL_Binary_full_report.csv',  header = TRUE)
data.trans.mcc.es <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/DeepL_English/ES_EN_DEEPL_MultiClass_full_report.csv',  header = TRUE)
data.trans.mcc.ar <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/DeepL_English/AR_EN_DEEPL_MultiClass_full_report.csv',  header = TRUE)


# Native data
data.bin.es <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/Spanish/Spanish_Binary_full_report.csv',  header = TRUE)
data.bin.ar <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/Arabic/Arabic_Binary_full_report.csv',  header = TRUE)
data.mcc.es <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/Spanish/Spanish_MultiClass_full_report.csv',  header = TRUE)
data.mcc.ar <- read.csv(file = 'https://raw.githubusercontent.com/javierosorio/keep_it_local/main/3_downstream_tasks/Arabic/Arabic_MultiClass_full_report.csv',  header = TRUE)




# List of df in order
# 
# data.trans.bin.es
# data.bin.es
# data.trans.bin.ar
# data.bin.ar
# 
# data.trans.mcc.es
# data.mcc.es
# data.trans.mcc.ar
# data.mcc.ar





## Subset data --------------------------------------------------

names(data.mcc.ar)
table(data.mcc.ar$model_name)


b.es.t.cb.scr.unc  <- data.trans.bin.es %>%
  filter(model_name=="ConfliBERT-scr-uncased") %>%
  select(model_name,f1) %>%
  rename(result=f1) %>%
  mutate(task="bin") %>% mutate(lang="sp") %>% mutate(text="trans")
mean(b.es.t.cb.scr.unc$result)

b.es.n.cb.beto.case  <- data.bin.es %>%
  filter(model_name=="ConfliBERT-v1-Spanish-beto-uncased") %>%
  select(model_name,f1) %>%
  rename(result=f1) %>%
  mutate(task="bin") %>% mutate(lang="sp") %>% mutate(text="native")
mean(b.es.n.cb.beto.case$result)

b.ar.t.cb.scr.case   <-  data.trans.bin.ar %>%
  filter(model_name=="ConfliBERT-scr-uncased") %>%
  select(model_name,f1) %>%
  rename(result=f1) %>%
  mutate(task="bin") %>% mutate(lang="ar") %>% mutate(text="trans")
mean(b.ar.t.cb.scr.case$result)

b.ar.n.cb.arabert  <-  data.bin.ar %>%
  filter(model_name=="ConfliBERT-v2-Arabic-arabertv2") %>%
  select(model_name,f1) %>%
  rename(result=f1) %>%
  mutate(task="bin") %>% mutate(lang="ar") %>% mutate(text="native")
mean(b.ar.n.cb.arabert$result)

m.es.t.cb.scr.case  <-  data.trans.mcc.es %>%
  filter(model_name=="ConfliBERT-cont-cased") %>%
  select(model_name,f1_macro)   %>%
  rename(result=f1_macro) %>%
  mutate(task="mcc") %>% mutate(lang="sp") %>% mutate(text="trans")
mean(m.es.t.cb.scr.case$result)

m.es.n.cb.cont.unc  <- data.mcc.es %>%
  filter(model_name=="ConfliBERT-v1-Spanish-beto-cased") %>%
  select(model_name,f1_macro)   %>%
  rename(result=f1_macro) %>%
  mutate(task="mcc") %>% mutate(lang="sp") %>% mutate(text="native")
mean(m.es.n.cb.cont.unc$result)

m.ar.t.cb.cont.unc   <-  data.trans.mcc.ar %>%
  filter(model_name=="ConfliBERT-scr-uncased") %>%
  select(model_name,f1_macro)   %>%
  rename(result=f1_macro) %>%
  mutate(task="mcc") %>% mutate(lang="ar") %>% mutate(text="trans")
mean(m.ar.t.cb.cont.unc$result)

m.ar.n.cb.cont.unc  <-  data.mcc.ar %>%
  filter(model_name=="ConfliBERT-v2-Arabic-multilingual-uncased") %>%
  select(model_name,f1_macro)   %>%
  rename(result=f1_macro) %>%
  mutate(task="mcc") %>% mutate(lang="ar") %>% mutate(text="native")
mean(m.ar.n.cb.cont.unc$result)




## Append all the data --------------------------------------------------

# Combine data
data.compare <- rbind(b.es.t.cb.scr.unc,b.es.n.cb.beto.case)
data.compare <- rbind(data.compare,b.ar.t.cb.scr.case)
data.compare <- rbind(data.compare, b.ar.n.cb.arabert)     
data.compare <- rbind(data.compare, m.es.t.cb.scr.case)   
data.compare <- rbind(data.compare,m.es.n.cb.cont.unc)    
data.compare <- rbind(data.compare,m.ar.t.cb.cont.unc)   
data.compare <- rbind(data.compare,m.ar.n.cb.cont.unc)

names(data.compare)




# Concatenate variable names into a single model name
data.compare.concat <- data.compare %>% 
  unite(model_concat, c("task", "lang", "text", "model_name"))



summary(data.compare.concat)
names(data.compare.concat)
table(data.compare.concat$model_concat)




# Generate descriptive statistics by group

desc.stats <- data.compare.concat %>% 
  group_by(c(model_concat)) %>% 
  summarize(mean = mean(result),
            sd = sd(result),
            n = n()) %>%
  rename(model_concat='c(model_concat)')


names(desc.stats)
table(desc.stats$model_concat)


# Split model name into variables
desc.stats <- desc.stats %>% 
  separate(model_concat, sep="_", c("task", "lang", "text", "model_name"))


# Pivot wider by text
desc.stats.wide <- desc.stats %>% 
  pivot_wider(names_from = text, values_from = c(mean, sd, n))








## T test  --------------------------------------------------


bin.es.ttest <-tsum.test(# x = native
  mean.x=as.numeric(desc.stats.wide[3,4]),
  s.x   =as.numeric(desc.stats.wide[3,6]),n.x=50,
  # y = trans
  mean.y=as.numeric(desc.stats.wide[4,5]),
  s.y   =as.numeric(desc.stats.wide[4,7]),n.y=50)

bin.es.ttest



bin.ar.ttest <-tsum.test(# x = native
  mean.x=as.numeric(desc.stats.wide[1,4]),
  s.x   =as.numeric(desc.stats.wide[1,6]),n.x=50,
  # y = trans
  mean.y=as.numeric(desc.stats.wide[2,5]),
  s.y   =as.numeric(desc.stats.wide[2,7]),n.y=50)

bin.ar.ttest



mcc.es.ttest <-tsum.test(# x = native
  mean.x=as.numeric(desc.stats.wide[7,4]),
  s.x   =as.numeric(desc.stats.wide[7,6]),n.x=50,
  # y = trans
  mean.y=as.numeric(desc.stats.wide[8,5]),
  s.y   =as.numeric(desc.stats.wide[8,7]),n.y=50)

mcc.es.ttest



mcc.ar.ttest <-tsum.test(# x = native
  mean.x=as.numeric(desc.stats.wide[5,4]),
  s.x   =as.numeric(desc.stats.wide[5,6]),n.x=50,
  # y = trans
  mean.y=as.numeric(desc.stats.wide[6,5]),
  s.y   =as.numeric(desc.stats.wide[6,7]),n.y=50)

mcc.ar.ttest  




bin.es.ttest
bin.ar.ttest
mcc.es.ttest
mcc.ar.ttest  



# Extract results
round(as.numeric(bin.es.ttest$estimate[1])-as.numeric(bin.es.ttest$estimate[2]),digits=6)
round(as.numeric(bin.ar.ttest$estimate[1])-as.numeric(bin.ar.ttest$estimate[2]),digits=6)
round(as.numeric(mcc.es.ttest$estimate[1])-as.numeric(mcc.es.ttest$estimate[2]),digits=6)
round(as.numeric(mcc.ar.ttest$estimate[1])-as.numeric(mcc.ar.ttest$estimate[2]),digits=6)







## Export to LaTeX  --------------------------------------------------



# Eliminate irrelevant variables

trans.native.compare <- desc.stats %>%
  select(-c(sd,n)) %>%
  arrange(task,lang,desc(text))

trans.native.compare


# Calculate differences between translated and native
diff.bin.ar <- as.numeric(trans.native.compare[1,5]-trans.native.compare[2,5])
diff.bin.es <- as.numeric(trans.native.compare[3,5]-trans.native.compare[4,5])
diff.mcc.ar <- as.numeric(trans.native.compare[5,5]-trans.native.compare[6,5])
diff.mcc.es <- as.numeric(trans.native.compare[7,5]-trans.native.compare[8,5])


# Add differences to comparison table
diff.trans.native <- c(diff.bin.ar,0,diff.bin.es,0,diff.mcc.ar,0,diff.mcc.es,0)
diff.trans.native

trans.native.compare <- cbind(trans.native.compare,diff.trans.native)
trans.native.compare






# Export to LaTeX

trans.native.compare <- xtable(trans.native.compare, include.rownames=FALSE , digits=c(0,0,0,0,0,4,4))
trans.native.compare
print(trans.native.compare, file = "tables/trans_native_compare.tex", include.rownames=FALSE)





# End of script