setwd('~/Desktop/Real Life/Coding Projects/Astronomy Astrology/')
library(tidyverse)

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
