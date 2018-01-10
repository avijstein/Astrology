setwd('~/Desktop/Real Life/Coding Projects/Astrology/')
library(tidyverse)

#### Initial Wikipedia Data Clean Up ####

# Read in data, find bad chars in it.
astronames = read_csv('justnames.csv')
nrow(astronames)
astronames$NCHAR = nchar(astronames$NameString, allowNA = T)

# eliminate bad chars.
astronames = astronames[!is.na(astronames$NCHAR),]
nrow(astronames)

# eliminate duplicates.
astronames = astronames[!duplicated(astronames),]
nrow(astronames)

astronames = data.frame(astronames$NameString)
names(astronames) = 'Names'
# write_csv(astronames, 'clean_names.csv')


#### Date Handling and Analysis ####

dates = read_csv('dates.csv', col_names = c('dates'))

dates = dates %>% 
  mutate('date1' = as.Date(dates$dates, format = '%d %B %Y'),
         'date2' = as.Date(dates$dates, format = '%B %d %Y')) %>%
  mutate('new_date' = paste0(date1, date2)) %>%
  mutate(new_date = gsub(new_date, pattern = 'NA', replacement = '')) %>%
  select(-c(date1, date2))




