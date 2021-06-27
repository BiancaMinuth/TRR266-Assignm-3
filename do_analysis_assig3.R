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


library(dplyr)
library(tidyr)
library(ggplot2)
library(ExPanDaR)
library(kableExtra)
library(tidyverse)

#open data
df <- read.csv("data/generated/assignment_3_sp500_output.csv", header=TRUE)
head(df)


#########################################################################################################


# SELECT DATA & SUBSETS

# select data
smp_da <- df %>%
  select(
    gvkey, year, quarter, qyear, hsiccd, ticker, CAR3d, CAR4d, UE, fund_at, fund_ceq,	fund_dt,	fund_gdwl,	fund_ni,	fund_mkvalt
  ) 


smp_da <- smp_da[smp_da$year %in% c("2020"),]   



# data sector 


smp_da_ind <- smp_da[smp_da$hsiccd %in% c("6798", "7370", "2834",  "4911", "3674", "7372", "1311"),]   


smp_da_ind_q4 <- smp_da_ind[smp_da_ind$qyear %in% c("42020"),]   


summary(smp_da$CAR4d)

# DESCRIPTIVE STATISTICS & REGRESSION

# descriptive statistics

tab_desc_stat <- prepare_descriptive_table(smp_da %>% select(-qyear))


tab_desc_stat_1 <- df %>%
  summarise(
    count = n(),
    mean_CAR3d = mean(CAR3d, na.rm = TRUE),
    mean_CAR4d = mean(CAR4d, na.rm = TRUE),
    mean_UE = mean(UE, na.rm = TRUE),
)


tab_desc_stat_2 <- df %>%
  summarise(
    median_CAR3d = median(CAR3d, na.rm = TRUE),
    median_CAR4d = median(CAR4d, na.rm = TRUE),
    median_UE = median(UE, na.rm = TRUE),
  )

tab_desc_stat_3 <- df %>%
  summarise(
    sd_CAR3d = sd(CAR3d, na.rm = TRUE),
    sd_CAR4d = sd(CAR4d, na.rm = TRUE),
    sd_UE = sd(UE, na.rm = TRUE),
  )


tab_CAR3d_q <- by(smp_da$CAR3d, smp_da$qyear, summary)
tab_CAR4d_q <- by(smp_da$CAR4d, smp_da$qyear, summary)


# regression

tab_reg_simple <- lm(formula = smp_da$CAR4d ~ smp_da$UE)
summary(tab_reg_simple)


tab_reg_1 <- lm(formula = smp_da$CAR4d ~ smp_da$UE + smp_da$qyear)
summary(tab_reg_1)



#########################################################################################################


# FIGURES  

fig_1 <- plot(smp_da$CAR4d,smp_da$UE)
abline(fig_1, col = "black")


fig_2 <- ggplot(smp_da, aes(UE)) + 
  geom_point(aes(y = CAR3d, colour = "CAR3d")) + 
  geom_point(aes(y = CAR4d, colour = "CAR4d"))


fig_3 <- qplot(CAR4d, UE, data = smp_da_ind_q4, color = factor(hsiccd),
               geom=c("point", "abline"))

fig_4 <- qplot(CAR4d, UE, data = smp_da, color = quarter,
               geom=c("point", "abline"))

fig_5 <- plot(smp_da$quarter, smp_da$CAR4d)

fig_6 <- smp_da_ind %>% 
  ggplot(aes(CAR4d, UE, group = hsiccd)) +
  geom_line(alpha = 1 / 3) + 
  facet_wrap(~qyear)


#########################################################################################################

# SAVE OUTPUT

save(
  list = c("smp_da", "smp_da_ind", "smp_da_ind_q4", "tab_CAR4d_q", "tab_CAR4d_q", "tab_desc_stat", "tab_reg_simple", "tab_reg_1", "tab_desc_stat", "tab_desc_stat_1", "tab_desc_stat_2", "tab_desc_stat_3",ls(pattern = "fig_*"), ls(pattern = "tab_*")),
  file = "output/results.rda"
)

