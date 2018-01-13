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



dates %>%
  mutate(
    dayofyear = yday(new_date)
  )



# Statistics and Graphing #
sigma = function(set, sds){
  x = mean(set); s = sd(set)
  lower = x - sds*s
  upper = x + sds*s
  return(c(lower, upper))
}

s = sigma(zodiac$count, 2)
sigma(table(dates$animal), 3)

ggplot(data = zodiac, aes(x = factor(sign, levels = sign[order(-count)]), y = count)) + 
  geom_bar(aes(fill = count), stat = 'identity') +
  geom_hline(yintercept = sigma(zodiac$count, 2)[1]) + geom_hline(yintercept = sigma(zodiac$count, 2)[2]) +
  scale_fill_continuous(guide = F) +
  labs(x='Zodiac Sign', y='Count', title='Astrological Signs of Historical Astronomers') +
  theme_minimal()


ggplot(data = dates) +
  geom_bar(aes(x = animal, fill = animal)) +
  geom_hline(yintercept = sigma(table(dates$animal), 2)[1]) + geom_hline(yintercept = sigma(table(dates$animal), 2)[2]) +
  scale_fill_discrete(name = 'Animal', guide = F) +
  labs(x = 'Animal', y = 'Count', title = 'Chinese Zodiacs of Historical Astronomers') + 
  theme_minimal()
# ggsave('Images/chinese_zodiac.png')


setwd('zodiac_images/')
files = list.files()
pics = lapply(files, FUN = readPNG)
imgs = lapply(pics, FUN = function(x) rasterGrob(x, interpolate = T))
setwd('../')


ggplot(data = zodiac, aes(x = factor(sign, levels = sign[order(-count)]), y = count)) + 
  geom_bar(aes(fill = count), stat = 'identity') +
  # annotate('rect', xmin = .55, xmax = 1.45, ymin = 0, ymax = 10) +
  annotation_custom(imgs[[1]], xmin=.6, xmax=1.4, ymin= 0, ymax=10) +
  annotation_custom(imgs[[2]], xmin=1.5, xmax=2.5, ymin= 0, ymax=10) +
  annotation_custom(imgs[[3]], xmin=2.5, xmax=3.5, ymin= 0, ymax=10) +
  annotation_custom(imgs[[4]], xmin=3.5, xmax=4.5, ymin= 0, ymax=10) +
  annotation_custom(imgs[[5]], xmin=4.5, xmax=5.5, ymin= 0, ymax=10) +
  annotation_custom(imgs[[6]], xmin=5.5, xmax=6.5, ymin= 0, ymax=10) +
  annotation_custom(imgs[[7]], xmin=6.5, xmax=7.5, ymin= 0, ymax=10) +
  annotation_custom(imgs[[8]], xmin=7.5, xmax=8.5, ymin= 0, ymax=10) +
  annotation_custom(imgs[[9]], xmin=8.5, xmax=9.5, ymin= 0, ymax=10) +
  annotation_custom(imgs[[10]], xmin=9.5, xmax=10.5, ymin= 0, ymax=10) +
  annotation_custom(imgs[[11]], xmin=10.5, xmax=11.5, ymin= 0, ymax=10) +
  annotation_custom(imgs[[12]], xmin=11.5, xmax=12.5, ymin= 0, ymax=10) +
  # geom_hline(yintercept = sigma(zodiac$count, 2)[1]) + geom_hline(yintercept = sigma(zodiac$count, 2)[2]) +
  scale_fill_continuous(guide = F) +
  labs(x='Zodiac Sign', y='Count', title='Astrological Signs of Historical Astronomers') +
  lims(y = c(0, max(zodiac$count) + 10)) +
  theme_minimal()







