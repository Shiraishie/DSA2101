library(dplyr)
library(tidyverse)
library(stringr)
library(readxl)
library(readr)
library(lubridate)

data(airquality)

airquality %>% distinct(Month)
which(is.na(airquality))

df = airquality %>% na.omit()

df_summer = df %>% filter(Month %in% c(5,6))
df_fall = df %>% filter(Month %in% c(7:9))

df = df %>% mutate(season = ifelse(Month %in% c(5,6), 'Summer', 'Fall'))

summary(df$Temp)

tapply(df$Temp, df$season, function(x) summary(x))

boxplot(df$Temp ~ df$Month, xlab = 'Month', ylab = 'Temperature',  xaxt = 'n')
axis(1, at = c(1:5), labels = c('May', 'Jun','Jul', 'Aug', 'Sep'))



#tutorial 2
df = read_csv('../data/Shanghai.csv')
head(df,3)

avg_temp = df %>% count(Month, wt = mean(Temp)) %>%
  mutate(n = round(n,2))

tapply(df$Temp, df$Month, mean)

df = df %>% mutate(yr_month = str_c(Year,Month, sep = '-'))
head(df,5)

df = df %>% mutate(yr_month = ym(yr_month))
glimpse(df)

df1 = df %>% filter(Year == 2012)
plot(df1$Month, df1$Temp, type = 'b', pch = 16, xaxt = 'n')
axis(1, at = c(1,4,7,10), label = c('Jan', 'Apr', 'Jul', 'Oct'))


#tutorial 3
qn1_1 = read_excel('../data/tourist.xlsx', range = 'A10:G26')
qn1_2 = qn1_1[-c(12,16), ] %>% rename(days = 'Data Series')

qn1_3 = qn1_2 %>% select(days, '2022 Dec') %>% rename(arrivals = '2022 Dec') %>%
  mutate(percentage = arrivals / arrivals[1])
qn1_3 = qn1_3[-1,]

qn1_3 = qn1_3 %>% mutate(days = c(0:7, '8-10','11-14','15-29','30-59','60+'))

barplot(qn1_3$percentage, names.arg = qn1_3$days, las = 2)


#tutorial 4
qn2_1 = read_excel('../data/MSPUS.xls', skip = 11, col_names = c('date','price'), col_types = c('date', 'numeric'))
options(scipen=999)
plot(qn2_1$date, qn2_1$price, type = 'l', lwd = 2, las = 1)


qn2_3 = qn2_1 %>% filter('2015-01-01' <= date & date <= '2023-10-31')
plot(qn2_3$date, qn2_3$price, type ='o', pch = 16)
qn2_3 %>% mutate(year = year(date), quarter = quarters(date))


library(nycflights13)
data(flights)

flights %>% filter(month == 6) %>% count(dest) %>% slice_max(n, n=1)

flights %>% group_by(carrier) %>% count(wt = mean(distance)) %>% ungroup() %>% slice_max(n, n=1)

flights %>% mutate(speed = distance / air_time) %>% slice_max(speed, n=1) %>%
  select(carrier, flight)

flights %>% count(weekdays(time_hour))

#wrong because 1st can be wednesday or monday depends honesetly so use weekday
flights %>% mutate(day = day%%7) %>% count(day)

