####################
# Bianca Minuth 
# Research on Corporate Transparency
# Assignment 3 

# DATA PREPARATION

# install packages
install.packages("ggplot2")
install.packages('gplots')
install.packages("stargazer")
install.packages("kableExtra")

#open data
df <- read.csv("C:\\Dokumente\\1 PhD Programm\\Courses\\External\\HU\\Assignment 3\\data\\generated\\assignment_3_sp500_output.csv", header=TRUE)
head(df)


#########################################################################################################


# SELECT DATA & SUBSETS

# select data
smp_da <- df %>%
  select(
    gvkey, year, quarter, qyear, hsiccd, ticker, CAR3d, CAR4d, UE, fund_at, fund_ceq,	fund_dt,	fund_gdwl,	fund_ni,	fund_mkvalt
  ) 

library(dplyr)
library(tidyr)
library(ggplot2)
library(ExPanDaR)
library(kableExtra)
library(tidyverse)


# data sector 

smp_da_ind <- smp_da[smp_da$hsiccd %in% c("6798", "7370", "2834",  "4911", "3674", "7372", "1311"),]   
smp_da_ind

smp_da_ind_q4 <- smp_da_ind[smp_da_ind$qyear %in% c("42020"),]   
smp_da_ind_q4


#########################################################################################################


# DESCRIPTIVE STATISTICS & REGRESSION

# descriptive statistics

tab_desc_stat <- prepare_descriptive_table(smp_da %>% select(-qyear))
tab_desc_stat

tab_desc_stat_1 <- df %>%
  summarise(
    count = n(),
    mean_CAR3d = mean(CAR3d, na.rm = TRUE),
    mean_CAR4d = mean(CAR4d, na.rm = TRUE),
    mean_UE = mean(UE, na.rm = TRUE),
)
tab_desc_stat_1

tab_desc_stat_2 <- df %>%
  summarise(
    median_CAR3d = median(CAR3d, na.rm = TRUE),
    median_CAR4d = median(CAR4d, na.rm = TRUE),
    median_UE = median(UE, na.rm = TRUE),
  )
tab_desc_stat_2


tab_desc_stat_3 <- df %>%
  summarise(
    sd_CAR3d = sd(CAR3d, na.rm = TRUE),
    sd_CAR4d = sd(CAR4d, na.rm = TRUE),
    sd_UE = sd(UE, na.rm = TRUE),
  )
tab_desc_stat_3

tab_CAR4d_q <- by(df$CAR4d, df$qyear, summary)
tab_CAR4d_q


# regression

reg_simple <- lm(formula = df$CAR4d ~ df$UE)
summary(reg_simple)
plot(reg_simple)

tab_reg1 <- lm(formula = df$CAR4d ~ df$UE + df$qyear + df$hsiccd)
summary(tab_reg1)


#########################################################################################################


# FIGURES  

fig_1 <- plot(df$CAR4d,df$UE)
abline(tab_reg2, col = "black")


fig_2 <- ggplot(df, aes(UE)) + 
  geom_point(aes(y = CAR3d, colour = "CAR3d")) + 
  geom_point(aes(y = CAR4d, colour = "CAR4d"))



fig_3 <- qplot(CAR4d, UE, data = smp_da_q4_ind, color = factor(hsiccd),
               geom=c("point", "abline"))
fig_3

fig_4 <- qplot(CAR4d, UE, data = df, color = quarter,
               geom=c("point", "abline"))

fig_5 <- plot(df$quarter, df$CAR4d)

fig_6 <- smp_da_ind %>% 
  ggplot(aes(CAR4d, UE, group = hsiccd)) +
  geom_line(alpha = 1 / 3) + 
  facet_wrap(~qyear)



#########################################################################################################

# SAVE OUTPUT

save(
  list = c("tab_desc_stat", "CAR3d_sum", "CAR4d_sum", "tab_reg1", "tab_reg2",ls(pattern = "fig_*"), ls(pattern = "tab_*")),
  file = "output/results.rda"
)

