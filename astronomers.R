setwd('~/Desktop/Real Life/Coding Projects/Astrology/')
library(tidyverse)
library(lubridate)

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


zodiac = data.frame('sign' = c('Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'),
                    'start_dates' = c('Mar 21', 'Apr 21', 'May 21', 'Jun 22', 'Jul 23', 'Aug 24', 'Sep 24', 'Oct 24', 'Nov 23', 'Dec 22', 'Jan 21', 'Feb 19'))

zodiac = zodiac %>%
  mutate(
    start_dates = as.Date(start_dates, format = '%b %d'),
    end_dates = start_dates - 1,
    end_dates = c(end_dates[-1], end_dates[1]),
    start = yday(start_dates),
    end = yday(end_dates)
  ) %>%
  mutate(
    count = table(cut(as.numeric(yday(dates$new_date)), breaks = end), useNA = 'ifany'),
    count = as.integer(count)
  ) %>%
  arrange(-count)


ggplot(data = zodiac) + 
  geom_bar(aes(x = factor(sign, levels = sign[order(count)]), y = count, fill = count), stat = 'identity') +
  scale_fill_continuous(guide = F) +
  coord_flip() +
  labs(x='Zodiac Sign', y='Count', title='Astrological Signs of Famous Astronomers') +
  theme_minimal()


# Statistics #
sigma = function(set, sds){
  x = mean(set); s = sd(set)
  lower = x - sds*s
  upper = x + sds*s
  return(c(lower, upper))
}



