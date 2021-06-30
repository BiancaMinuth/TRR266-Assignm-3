# -*- coding: utf-8 -*-
"""
Created on Wed Jun 23 11:32:40 2021

@author: bianca
"""


# +++ IMPLIED GROWTH RATES +++ #


import pandas as pd 
import os
import numpy as np
from datetime import datetime



## select Merge File US Equity and WRDS
df_assig3 = pd.read_csv("./data/external/assignment_3_sp500_constituents_with_daily_mdata.csv")
df_assig3['date']
df_assig3.head(29)
df_assig3.iloc[:]



# S&P 500 Index
SP500_avg = df_assig3.groupby(['date']).agg({
    'prc': 'mean'
    })

SP500_avg


SP500_index = pd.DataFrame(SP500_avg, columns= ['prc'])
SP500_index

SP500_index.to_csv("./data/external/assignment_3_SP500_index.csv")

# summarize data
df2 = df_assig3.groupby(['date', 'comnam', 'permno', 'hsiccd', 'ticker', 'gvkey']).agg({
    'prc': 'mean'
    })
df2

df2.to_csv("./data/external/assignment_3_sp500_summary.csv")


df_CAR_UE = pd.read_csv("./data/external/assign3_summary CAR UE.csv")
df_CAR_UE['hsiccd']


type(['month'])
df_CAR_UE['month'].astype(int)


## create 'month' and 'year' column
pd.Timestamp(df_CAR_UE['date'])


## define 'quarters'
def quartal(month): 
    if month <= 3: return(1)
    if month <= 6: return(2)
    if month <= 9: return(3)
    return (4)

## create 'quarter' column
df_CAR_UE['quarter'] = [quartal(m) for m in df_CAR_UE['month']]
print(df_CAR_UE['quarter'])



df_CAR_UE.to_csv("./data/external/assignment_3_sp500_output.csv")

## sum industry
df_ind = df_CAR_UE.groupby(['comnam', 'gvkey', 'hsiccd']).agg({'prc': 'mean'})
df_ind.to_csv("./data/external/assignment_3_sp500_ind.csv")



df_ind2 = df_CAR_UE.groupby(['comnam', 'gvkey']).agg({'hsiccd': 'count'})
df_ind2
df_ind.to_csv("./data/external/assignment_3_sp500_ind2.csv")


df_fund = pd.read_csv("./data/external/assignment_3_cmp_fundamentals.csv")
df_fund['gvkey']


## define 'quarters'
def quartal(month): 
    if month <= 3: return(1)
    if month <= 6: return(2)
    if month <= 9: return(3)
    return (4)

## create 'quarter' column
df_fund['quarter'] = [quartal(m) for m in df_fund['cmonth']]
df_fund['quarter'].head(25)

df_fund.to_csv("./data/external/assignment_3_sp500_fund.csv")




