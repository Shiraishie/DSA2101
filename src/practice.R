library(readr)

df = read_csv('../data/Shanghai.csv')
head(df,3)

avg_temp = round(mean(df$Temp),2)

df$yr_month = paste0(df$Year, sep = '-' ,df$Month)

library(lubridate)
df$yr_month = ym(df$yr_month)

df2012 = df[df$Year == 2012,] 

#y = tapply(df$Temp, df$Month, mean)
monthslabel = levels(factor(df$Month))

plot(monthslabel, df2012$Temp, type = 'b', pch = 16, xaxt = 'n')
axis(1, labels = c('Jan', 'April', 'July', 'Oct'), at = c(1,4,7,10) )







#Tutorial 5
library(readxl)
qn1_1 = read_excel('../data/tourist.xlsx', range = 'A10:G26')
qn1_1 = na.omit(qn1_1)
qn1_2 = qn1_1[-12, ]

ydata = qn1_2$'2022 Dec'[2:14] / qn1_2$'2022 Dec'[1]
xlabel = c(0:7, '8-10', '11-14', '15-29', '30-59', '60+')
barplot(ydata, names.arg = xlabel, las =  2, cex.axis = 0.9, cex.names = 0.80)


library(readr)
#library(dplyr)
yrbss = read_csv('../data/yrbss.csv')
yrbss = na.omit(yrbss)
yrbss = unique(yrbss) #distinct function with dplyrs
colnames(yrbss)[1] = 'id'
colnames(yrbss)[8] = 'weight_kg'

#gsub or string_replace
yrbss$grade = stringr:: str_replace_all(yrbss$grade, 'th', '')
#or use gsub to do it without stringr
yrbss$grade = as.numeric(gsub('th', '', yrbss$grade))


qns2_2 =  yrbss[yrbss$'bmi' < 15 & yrbss$'sex' == 'Female', ]
qns2_2 = qns2_2[-c(3,4,6)]
qns2_2$height = sqrt( qns2_2$weight_kg / qns2_2$bmi)


#Tut 6
library(dplyr)
library(readr)

qns1_1 = read_csv('../data/yrbss.csv')
qns1_1 = qns1_1 %>% na.omit() %>%
  distinct() %>% 
  rename(id = record, weight_kg = stweight)  %>%
  mutate(grade = as.numeric(stringr:: str_replace(grade, 'th', '')))

female = qns1_1 %>% filter(bmi < 15 & sex == 'Female')
female = female %>% select(-c(3,4,6))

qns1_2 = female %>% mutate(height_m = sqrt(weight_kg / bmi))


qns2_1 = read_excel('../data/MSPUS.xls', skip = 11, col_names = c('date', 'price'), col_types = c('date', 'numeric'))

dates = qns2_1$date
prices = qns2_1$price

dates1 = qns2_1 %>% select(date) %>% pull() #guves tibble not the actual vector of data  
#pull givse our data

plot(dates, prices, type = 'l', lwd = 3)

qns2_3 = qns2_1 %>% filter(date >= '2015-01-01' & date <= '2023-10-31')
qns2_3 = qns2_3 %>% mutate(year = year(date), quarter = quarters(date))

plot(qns2_3$date, qns2_3$price, type = 'o', pch = 16)



library(nycflights13)
data(flights)

#flights = na.omit(flights)

flights %>% filter(month == 6) %>%
  #summarize(total = n()) %>% slice_max(total, n=1)
  count(dest) %>% slice_max(n, n=1) #dont need to group_by, count is group_by + summarize

flights %>% count(carrier, wt = mean(distance)) %>% slice_max(n, n=1)
flights %>% group_by(carrier) %>% summarize(mean_distance = mean(distance)) %>% slice_max(mean_distance, n=1)

flights %>% mutate(avg_speed = distance / air_time) %>%
  slice_max(avg_speed, n=1) %>% select(carrier, flight)


library(lubridate)  
flights %>% mutate(l = weekdays(time_hour)) %>%
  count(l) %>% slice_max(n, n=1)


library(tidyverse)
#w7 tutorial
qn1_1 = read_excel('../data/tourist.xlsx', range = 'A10:G26')
qn1_1 = qn1_1[-c(1,12,16), ] %>% mutate(k = 1:13, .before = 'Data Series')
qn1_1 = qn1_1 %>% pivot_longer(3:8, names_to = c('year', 'month'), values_to = 'arrivals', names_sep = ' ') %>%
  rename('duration' = 'Data Series')

qn1_1 = qn1_1 %>% mutate(month = factor(month, levels = c('Jul','Aug','Sep','Oct','Nov','Dec'), ordered = TRUE)) %>%
  arrange(month) 
qn1_1 = qn1_1 %>% mutate(year = as.integer(year))

glimpse(qn1_1)
#variables, number of days, year, month, number of arrivals, set k
#first i should convert 2022 dec into its year,month


