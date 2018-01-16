setwd('~/Desktop/Real Life/Coding Projects/Astrology/')
library(tidyverse)
library(lubridate)
library(png)
library(grid)

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

dates = read_csv('uni_dates.csv', col_names = c('dates'))

dates = dates %>% 
  mutate('date1' = as.Date(dates$dates, format = '%d %B %Y'),
         'date2' = as.Date(dates$dates, format = '%B %d %Y')) %>%
  mutate('new_date' = paste0(date1, date2)) %>%
  mutate(new_date = gsub(new_date, pattern = 'NA', replacement = '')) %>%
  select(-c(date1, date2))


chinese = data.frame('cycle' = seq(0,11),
                     'animals' = c('Monkey', 'Rooster', 'Dog', 'Pig', 'Rat', 'Ox', 'Tiger', 'Rabbit', 'Dragon', 'Snake', 'Horse', 'Goat'),
                     stringsAsFactors = F)

dates = dates %>%
  mutate(
    century = ceiling(year(new_date)/100),
    leap = year(new_date)/4 == round(year(new_date)/4),
    dayofweek = weekdays(as.Date(new_date)),
    animal = year(new_date)%%12
  ) %>%
  rowwise() %>%
  mutate(
    animal = chinese[chinese$cycle == animal,]$animals
  )


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



#### Statistics and Graphing ####
sigma = function(set, sds){
  x = mean(set); s = sd(set)
  lower = x - sds*s
  upper = x + sds*s
  return(c(lower, upper))
}



# Chinese Zodiac #

chinese = chinese %>%
  inner_join(y = data.frame(table(dates %>% select(animal))) %>%
                 setNames(c('animals', 'count')) %>%
                 mutate(animals = as.character(animals)), 
             by = 'animals')

ggplot(data = chinese) +
  geom_bar(aes(x = factor(animals, levels = animals), y = count, fill = factor(animals, levels = animals)), stat = 'identity') +
  geom_hline(yintercept = sigma(chinese$count, 2)[1]) + geom_hline(yintercept = sigma(chinese$count, 2)[2]) +
  scale_fill_discrete(name = 'Animal', guide = F) +
  labs(x = 'Animal', y = 'Count', title = 'Chinese Zodiacs of Historical Astronomers') + 
  theme_minimal() + theme(axis.title.x = element_text(margin = margin(t = 10)))
# ggsave('Images/chinese_zodiac.png')


# Day of Week #

week_df = data.frame(table(dates %>% select(dayofweek))) %>%
  setNames(c('day', 'count')) %>%
  slice(match(day[c(4,2,6,7,5,1,3)], day))

ggplot(data = week_df) +
  geom_bar(aes(x = factor(day, levels = day), y = count, fill = factor(day, levels = day)), stat = 'identity') +
  geom_hline(yintercept = sigma(week_df$count, 2)[1]) + geom_hline(yintercept = sigma(week_df$count, 2)[2]) +
  scale_fill_discrete(name = 'Day of Week', guide = F) +
  labs(x = 'Day of Week', y = 'Count', title = 'Birth Day of Historical Astronomers') + 
  theme_minimal() + theme(axis.title.x = element_text(margin = margin(t = 10)))
# ggsave('Images/dayofweek.png')


# Astrological Zodiac #

setwd('zodiac_images/')
files = list.files()
files = files[c(8,11,6,1,5,12,7,10,9,2,4,3)]
pics = lapply(files, FUN = readPNG)
imgs = lapply(pics, FUN = function(x) rasterGrob(x, interpolate = T))
setwd('../')
notes = lapply(seq(1,12), FUN = function(x) annotation_custom(imgs[[x]], xmin = x-.45, xmax = x+.45, ymin = 0, ymax = 10))


ggplot(data = zodiac, aes(x = factor(sign, levels = sign), y = count)) + 
  geom_bar(aes(fill = count), stat = 'identity') +
  notes + geom_hline(yintercept = sigma(zodiac$count, 2)[1]) + geom_hline(yintercept = sigma(zodiac$count, 2)[2]) +
  scale_fill_continuous(guide = F) +
  labs(x='Zodiac Sign', y='Count', title='Astrological Signs of Historical Astronomers') +
  lims(y = c(0, max(zodiac$count) + 5)) +
  theme_minimal() + theme(axis.title.x = element_text(margin = margin(t = 10)))
# ggsave('Images/zodiacs.png')




