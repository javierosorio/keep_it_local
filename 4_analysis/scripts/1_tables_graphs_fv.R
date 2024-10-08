#####################################
# Keep in local
#
# Javier Osorio
# 7/16/2023
# 
# Plot annotations
#
#####################################



# Load all packages here #####################################

if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, glue, openxlsx, tidyverse, ggplot2, readxl, scales, dplyr, BSDA, xtable)





# ANNOTATIONS #####################################


## Get the data --------------------------------------------------


# Get data
data <- read_excel('data/raw_data/data_master.xlsx')
#data <- read.csv(file = 'data/raw_data/data_master.csv',  header = TRUE)
#data <- read.csv('https://raw.githubusercontent.com/javierosorio/keep_it_local/main/1_data/data_master.csv', header = TRUE)


# Eliminate errors in the data 
data <- data  %>%  
  dplyr::filter(Relevant=="0" | Relevant=="1")  %>%
  mutate(Relevant=as.numeric(Relevant))


# Generate binary data
data.binary <- data


# Generate quadclass data
data.quadclass <- data %>% 
  mutate(QuadClass=as.numeric(QuadClass)) %>% 
  dplyr::filter(QuadClass>=1)  




## Reshape data --------------------------------------------------


# Reshape binary data with percentages
data.binary.pct <- data.binary %>%
  dplyr::select(Relevant) %>% 
  count(Relevant) %>%
  mutate(Relevant = as.factor(Relevant)) %>%
  mutate(pct = n / sum(n) * 100) %>%
  mutate(pct=round(pct,digits=1)) %>%
  mutate(pct = as.character(pct)) %>%
  mutate(pct = paste0(pct,"%"))


# Reshape quadclass data with percentages
data.quadclass.pct <- data.quadclass %>% 
  count(QuadClass) %>%
  mutate(QuadClass = as.factor(QuadClass)) %>%
  mutate(pct = n / sum(n) * 100) %>%
  mutate(pct=round(pct,digits=1)) %>%
  mutate(pct = as.character(pct)) %>%
  mutate(pct = paste0(pct,"%")) 







## Plot --------------------------------------------------


# Binary

ggplot(data=data.binary.pct, aes(x=Relevant, y=n)) +
  geom_bar(stat="identity")+ 
  xlab("") + ylab("Number of sentences") +
  scale_x_discrete(labels=c("0"="Not relevant", "1"="Relevant")) +
  geom_text(aes(label=pct), vjust=1.6, color="white", size=3.5) +
  theme_minimal()

ggsave("graphs/binary_freqs_3.pdf", width = 2.7, height = 2, units = "in")



# QuadClass

ggplot(data=data.quadclass.pct, aes(x=QuadClass, y=n)) +
  geom_bar(stat="identity")+ 
  xlab("") + ylab("Number of sentences") +
  scale_x_discrete(labels=c("Mat\nConf", "Mat\nCoop","Verb\nConf", "Verb\nCoop")) +
  geom_text(aes(label=pct), vjust=1.6, color="white", size=3.5)+
  theme_minimal()

ggsave("graphs/quadclass_freqs_3.pdf", width = 3.5, height = 2, units = "in")











# End of script