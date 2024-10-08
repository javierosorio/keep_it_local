#####################################################################
# UN Multilingual Corpus
# Translation Assessment
# Javier Osorio 
# 6-26-2024
#####################################################################



# SETUP --------------------------------------------------

# Load all packages here

if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, glue, openxlsx, tidyverse, readxl, dplyr, stringr, stringi, 
               ggplot2, grid)







# GET THE DATA --------------------------------------------------


# Get data
data.text <- read_excel('data/raw_data/data_master_v2.xlsx')

data.ar.scores <- read.csv('https://raw.githubusercontent.com/javierosorio/keep_it_local/main/2_quality_analysis/AR%26ES_to_EN/Ar%26Es_To_En_Quality%20Evaluation%20Analysis/Deep/Arabic_Translation_Scores%20(2).csv',  header = TRUE)
data.es.scores <- read.csv('https://raw.githubusercontent.com/javierosorio/keep_it_local/main/2_quality_analysis/AR%26ES_to_EN/Ar%26Es_To_En_Quality%20Evaluation%20Analysis/Deep/Spanish_Translation_Scores%20(4).csv',  header = TRUE)


# Rename variables
names(data.ar.scores) <- c("BLEU.ar","SacreBLEU.ar","METEOR.ar","BERTScore.ar")
names(data.es.scores) <- c("BLEU.es","SacreBLEU.es","METEOR.es","BERTScore.es")


# Merge data
data <- cbind(data.text,data.ar.scores,data.es.scores)


# Clean up variables
data <- data %>% select(-c(MatConf,MatCoop,VerConf,VerCoop,Relevant,QuadClass))
names(data)


# Remove working data
rm(data.text,data.ar.scores,data.es.scores)








# CALCULATE LENGTH --------------------------------------------------


##  Count words  -------------------

data <- data %>%
  # Native text
  mutate(en.native.words = str_count(en, '\\w+')) %>%
  mutate(es.native.words = str_count(es, '\\w+')) %>%
  mutate(ar.native.words = str_count(ar, '\\w+')) %>%
  # DeepL translated text
  mutate(es.en.trans.words = str_count(es_en_DEEPL, '\\w+')) %>%
  mutate(ar.en.trans.words = str_count(ar_en_DEEPL, '\\w+')) 
  

## Difference words  -------------------

data <-  data %>%
  # Native text
  mutate(es.en.native.diff.words = es.native.words-en.native.words) %>%
  mutate(ar.en.native.diff.words = ar.native.words-en.native.words) %>%
  # DeepL translated text
  mutate(es.en.trans.diff.words = es.en.trans.words-en.native.words) %>%
  mutate(ar.en.trans.diff.words = ar.en.trans.words-en.native.words)








# DESCRIPTIVE STATISTICS --------------------------------------------------


# Mean
mean.en.native.words         <- round(mean(as.numeric(data$en.native.words), na.rm=TRUE),digits=1)
mean.es.native.words         <- round(mean(as.numeric(data$es.native.words), na.rm=TRUE),digits=1)
mean.ar.native.words         <- round(mean(as.numeric(data$ar.native.words), na.rm=TRUE),digits=1)
mean.es.en.native.diff.words <- round(mean(as.numeric(data$es.en.native.diff.words), na.rm=TRUE),digits=1)
mean.ar.en.native.diff.words <- round(mean(as.numeric(data$ar.en.native.diff.words), na.rm=TRUE),digits=1)
mean.es.en.trans.words       <- round(mean(as.numeric(data$es.en.trans.words), na.rm=TRUE),digits=1)
mean.ar.en.trans.words       <- round(mean(as.numeric(data$ar.en.trans.words), na.rm=TRUE),digits=1)
mean.es.en.trans.diff.words  <- round(mean(as.numeric(data$es.en.trans.diff.words), na.rm=TRUE),digits=1)
mean.ar.en.trans.diff.words  <- round(mean(as.numeric(data$ar.en.trans.diff.words), na.rm=TRUE),digits=1)


# SD
sd.en.native.words         <- round(sd(as.numeric(data$en.native.words), na.rm=TRUE),digits=1)
sd.es.native.words         <- round(sd(as.numeric(data$es.native.words), na.rm=TRUE),digits=1)
sd.ar.native.words         <- round(sd(as.numeric(data$ar.native.words), na.rm=TRUE),digits=1)
sd.es.en.native.diff.words <- round(sd(as.numeric(data$es.en.native.diff.words), na.rm=TRUE),digits=1)
sd.ar.en.native.diff.words <- round(sd(as.numeric(data$ar.en.native.diff.words), na.rm=TRUE),digits=1)
sd.es.en.trans.words       <- round(sd(as.numeric(data$es.en.trans.words), na.rm=TRUE),digits=1)
sd.ar.en.trans.words       <- round(sd(as.numeric(data$ar.en.trans.words), na.rm=TRUE),digits=1)
sd.es.en.trans.diff.words  <- round(sd(as.numeric(data$es.en.trans.diff.words), na.rm=TRUE),digits=1)
sd.ar.en.trans.diff.words  <- round(sd(as.numeric(data$ar.en.trans.diff.words), na.rm=TRUE),digits=1)
sd.ar.en.trans.diff.words  <- round(sd(data$ar.en.trans.diff.words),digits=1)



# Total number of words by language



# Identify the column numbers 
names(data)


# Select variables and eliminate nas
total.en.native.words   <- data %>% select(en.native.words) %>% drop_na(.) 
total.es.native.words   <- data %>% select(es.native.words) %>% drop_na(.) 
total.ar.native.words   <- data %>% select(ar.native.words) %>% drop_na(.) 
total.es.en.trans.words <- data %>% select(es.en.trans.words) %>% drop_na(.) 
total.ar.en.trans.words <- data %>% select(ar.en.trans.words) %>% drop_na(.) 


# Calculate totals by column
total.en.native.words <- colSums(total.en.native.words[ , 1, drop = FALSE])
total.es.native.words <- colSums(total.es.native.words[ , 1, drop = FALSE])
total.ar.native.words <- colSums(total.ar.native.words[ , 1, drop = FALSE])
total.es.en.trans.words <- colSums(total.es.en.trans.words[ , 1, drop = FALSE])
total.ar.en.trans.words <- colSums(total.ar.en.trans.words[ , 1, drop = FALSE])


# Format as numeric
total.en.native.words <- as.numeric(total.en.native.words)
total.es.native.words <- as.numeric(total.es.native.words)
total.es.en.trans.words <- as.numeric(total.es.en.trans.words)
total.ar.native.words <- as.numeric(total.ar.native.words)
total.ar.en.trans.words <- as.numeric(total.ar.en.trans.words)


# Report totals
total.en.native.words
total.es.native.words
total.es.en.trans.words
total.ar.native.words
total.ar.en.trans.words




mean.en.native.words
sd.en.native.words

mean.es.native.words
sd.es.native.words

mean.ar.native.words
sd.ar.native.words





# Calculate overall translation effect

ar.trans.effect <- total.ar.en.trans.words-total.ar.native.words
ar.trans.effect <-formatC(ar.trans.effect, format="f", big.mark=",", digits=0)
ar.trans.effect

es.trans.effect <- total.es.en.trans.words-total.es.native.words
es.trans.effect <-formatC(es.trans.effect, format="f", big.mark=",", digits=0)
es.trans.effect


# Percentage change

ar.trans.effect.pct <- (total.ar.en.trans.words/total.ar.native.words)-1
ar.trans.effect.pct <- round(ar.trans.effect.pct, digits=4)*100
ar.trans.effect.pct

es.trans.effect.pct <- (total.es.en.trans.words/total.es.native.words)-1
es.trans.effect.pct <- round(es.trans.effect.pct, digits=4)*100
es.trans.effect.pct







# PIVOT DATA --------------------------------------------------


## Subset data frames  -----------------

data.ar <- data %>% 
  select(c(BLEU.ar,SacreBLEU.ar,METEOR.ar,BERTScore.ar,
           en.native.words,ar.native.words,
           ar.en.trans.words,
           ar.en.native.diff.words,
           ar.en.trans.diff.words)) %>%
  mutate(language="(2) AR") %>% 
  relocate(language)

data.es <- data %>% 
  select(c(BLEU.es,SacreBLEU.es,METEOR.es,BERTScore.es,
           en.native.words,es.native.words,
           es.en.trans.words,
           es.en.native.diff.words,
           es.en.trans.diff.words)) %>%
  mutate(language="(1) ES") %>% 
  relocate(language)


# Rename variables

data.ar <- data.ar %>%
  rename(BLEU=BLEU.ar) %>% 
  rename(SacreBLEU=SacreBLEU.ar ) %>% 
  rename(METEOR=METEOR.ar ) %>% 
  rename(BERTScore=BERTScore.ar ) %>% 
  rename(en.words= en.native.words) %>%
  rename(native.words=ar.native.words ) %>% 
  rename(trans.words=ar.en.trans.words ) %>% 
  rename(native.diff.words=ar.en.native.diff.words) %>%  
  rename(trans.diff.words=ar.en.trans.diff.words )

data.es <- data.es %>%
  rename(BLEU=BLEU.es) %>% 
  rename(SacreBLEU=SacreBLEU.es ) %>% 
  rename(METEOR=METEOR.es ) %>% 
  rename(BERTScore=BERTScore.es ) %>% 
  rename(en.words= en.native.words) %>%
  rename(native.words=es.native.words ) %>% 
  rename(trans.words=es.en.trans.words ) %>% 
  rename(native.diff.words=es.en.native.diff.words) %>%  
  rename(trans.diff.words=es.en.trans.diff.words )

names(data.ar)
names(data.es)


# Append data frames

data.long <- rbind(data.es,data.ar)

# Delete working data
rm(data.es,data.ar)


# Calculate logs and label augment summarize

data.long <- data.long %>%
  # differentiate augmentation (+) and summarization (-)
  mutate(trans.diff.augment=case_when(trans.diff.words>0 ~trans.diff.words, TRUE ~ NA_real_)) %>%
  mutate(trans.diff.summarize=case_when(trans.diff.words<0 ~trans.diff.words, TRUE ~ NA_real_)) %>%
  # log transformation
  mutate(trans.diff.augment.log = log(trans.diff.augment)) %>%
  mutate(trans.diff.summarize.log = (log(trans.diff.summarize*(-1)))*(-1)) %>% 
  # integrate augment and summarize
  mutate(trans.diff.pos.neg.log=case_when(
    !is.na(trans.diff.augment.log) ~ trans.diff.augment.log,
    !is.na(trans.diff.summarize.log) ~ trans.diff.summarize.log)) %>%
  mutate(trans.diff.pos.neg.label = case_when(
    trans.diff.pos.neg.log>0 ~ "Increase",
    trans.diff.pos.neg.log<0 ~ "Decrease")) %>%
  mutate(trans.diff.pos.neg.log=case_when(
    trans.diff.pos.neg.log==0 ~ NA,
    TRUE ~trans.diff.pos.neg.log))








# PLOT TRENDS --------------------------------------------------


## Reshape data for scores ----------------------


# Reshape data 

data.long.scores <- data.long %>% 
  select(BLEU,SacreBLEU,METEOR,BERTScore,language,native.words,trans.words,trans.diff.words,trans.diff.pos.neg.log,trans.diff.pos.neg.label) %>%
  pivot_longer(., cols = 1:4, 
               names_to ="scores",
               values_to = "values") %>%
  relocate(language, scores, values, native.words, trans.diff.words,trans.diff.pos.neg.log,trans.diff.pos.neg.label)

# Recode values for facet grid
data.long.scores <- data.long.scores %>%
  mutate(scores = case_when(
    scores=="BLEU" ~ "(1) BLEU",
    scores=="SacreBLEU" ~ "(2) SacreBLEU",
    scores=="METEOR" ~ "(3) METEOR",
    scores=="BERTScore" ~ "(4) BERTScore " ))



## Plot words  ----------------------


## Plot number of Words - Native and translated
#ggplot(data.long.scores, aes(native.words, trans.diff.pos.neg.log )) + 
#  geom_point(shape=1, colour = "darkgray") +
#  geom_smooth() +
#  facet_grid(cols = vars(language), scales = "free_x") +
#  xlab("Num. native words") + ylab("Difference in translated words (log)") +
#  theme_bw()

#ggsave("graphs/words_native_diff.pdf", width = 4, height = 2, units = "in")




# Plot positive and negative changes 

data.long.scores.no.na <- data.long.scores %>%
  filter(!is.na(trans.diff.pos.neg.label))


#ggplot(data.long.scores.no.na, aes(native.words, trans.diff.pos.neg.log, color=trans.diff.pos.neg.label)) + 
#  geom_point(shape=1, colour = "darkgray") +
#  geom_smooth() +
#  geom_hline(yintercept=0, linetype="dashed", color = "black") +
#  facet_wrap(~language,nrow=1, scales = "free_x") +
#  xlab("Num. native words") + ylab("Difference in translated words (log)") + 
#  labs(color = "Translation Change") + 
#  theme_light()+ 
#  theme(strip.text.x = element_text(color = "black"))+ 
#  theme(legend.position = "bottom")

#ggsave("graphs/words_diff_pos_neg.pdf", width = 4, height = 4, units = "in")






# Generate graph as an object
p <- ggplot(data.long.scores.no.na, aes(native.words, trans.diff.pos.neg.log, color=trans.diff.pos.neg.label)) + 
  geom_point(shape=1, colour = "darkgray") +
  geom_smooth() +
  geom_hline(yintercept=0, linetype="dashed", color = "black") +
  facet_wrap(~language,nrow=1, scales = "free_x") +
  xlab("Num. native words") + ylab("Difference in translated words (log)") + 
  labs(color = "Word Count Change") + 
  theme_light()+ 
  theme(strip.text.x = element_text(color = "black"))+ 
  theme(legend.position = "bottom")

print(p)


# Define labels per panel
df_labels <- data.frame(
  language = c("(1) ES","(2) AR"),
  label = c(glue("Net effect:\n{es.trans.effect}\n words"), glue("Net effect:\n+{ar.trans.effect}\n words")), 
  color = c("Increase","Decrease"),
  native.words = c(400,550),
  trans.diff.pos.neg.log = c(-2, 2))

# Add labels to graph
p + geom_text(
  data    = df_labels,
  mapping = aes(x = native.words, y = trans.diff.pos.neg.log, color= color, label = label),
  colour="black"
) 


ggsave("graphs/words_diff_pos_neg.pdf", width = 4, height = 4, units = "in")










## Plot translation scores  ----------------------


# Plot LOWES scores - Native

ggplot(data.long.scores, aes(native.words, values )) + 
  geom_smooth() +
  facet_grid(vars(scores),vars(language)) +
  xlab("Native language number of words") + ylab("Score value")+ ylim(0,1.25) +
  theme_light() + 
  theme(strip.text.x = element_text(color = "black"),
        strip.text.y = element_text(color = "black" ))

ggsave("graphs/scores_diff_trans.pdf", width = 5, height = 5, units = "in")




# Plot LOWES scores - Native

ggplot(data.long.scores, aes(trans.words, values )) + 
  geom_smooth() +
  facet_grid(vars(scores),vars(language), scales = "free_x") +
  xlab("Number of translated words") + ylab("Score value")+ ylim(0,1.25) +
  theme_light() + 
  theme(strip.text.x = element_text(color = "black"),
        strip.text.y = element_text(color = "black" ))

ggsave("graphs/scores_trans.pdf", width = 5, height = 5, units = "in")




# END OF SCRIPT