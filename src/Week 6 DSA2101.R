library(tidyverse)
library(nycflights13)
data(flights)

flights %>% group_by(carrier) %>%
  summarize(mean_delay = mean(arr_delay, na.rm = TRUE)) %>%
  slice_max(mean_delay, n=1)

flights %>% filter(dest == 'BWI') %>%
  group_by(hour) %>%
  summarize(dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  slice_min(dep_delay, n=1)

View(table4a)

#This function makes columns into our observations
#gather('data", key = our new column called year and value = new col called cases that contains the data from 1999/2000)
table4a %>% gather(`1999`:`2000`, key = 'year', value = 'cases')

#This function makes our observations(containing variables) into columns
#spread(type, count), type that contains 2 variables(our new columns) is the key, and count is its valuie
table2 %>% spread(type,count) #or key = type, value = count

#Better more updated functions 
#Gather as it makes data frame LONGER(not in width)
table4a %>% pivot_longer(`1999`:`2000`, names_to = 'year', values_to = 'cases')
#spread
table2 %>% pivot_wider(names_from= type, values_from = count)
#table2 %>% pivot_wider(type, count) DOESNT WORK! Need to specify

#Example from lecture, we delete
table2[-1,] %>% spread(key = type, value = count)
#Shows NA in case 

#seperate values in a col into multiple cols
table3 %>% separate(rate, into = c('cases','population'), convert = TRUE) #IF convert false, stays as character
#optional sep = '/'

#table5
table5 %>% unite(col = 'year', century:year, sep = '') %>%#or we can direct 'year' dont have to do col 
  separate(rate, into = c('cases', 'population'), convert = TRUE) %>%
#Year is still not numeric because seperate only works into c() so we have to mutate to turn it into year
  mutate(year = as.numeric(year))
