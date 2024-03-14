library(tidyverse)
data(who2)

who2 %>% #-c(1,2) or !c(country:year) or !c(1,2)
  pivot_longer(cols = -c(1,2), 
               names_to = c('diagnosis','gender','age'),
               names_sep = '_',
               values_to = 'count')

library(nycflights13)
data(flights)
data(airlines)
data(planes)
flights2 = flights %>% select(time_hour, origin, dest, tailnum, carrier)

#check if carrier is primary key in airlines
airlines %>% count(carrier) %>% filter(n>1)

flights2 %>% left_join(airlines, by = 'carrier')

flights2 %>% left_join(planes %>% select(tailnum,engines,seats), by = 'tailnum') %>%
  filter(tailnum == 'N3ALAA') #shows there is no match so n3alaaa doesnt exist in planes

flights2 %>% left_join(weather)

flights2 %>% left_join(airports, by = c('dest' = 'faa'))
data(airports)

top_dest = flights %>% count(dest, sort = TRUE) %>%
  slice_max(n, n=10)

flights2 %>% semi_join(top_dest)
flights2 %>% inner_join(top_dest) #has frequency N on the RHS
flights2 %>% anti_join(top_dest)

#Gets the top tailnum with no matches
flights2 %>% anti_join(planes, by = 'tailnum') %>%
  count(tailnum, sort = TRUE)
#HAS NA Tailnum

#which has the MOST match
flights2 %>% semi_join(planes, by = 'tailnum') %>%
  count(tailnum, sort = TRUE)

flights %>% filter(is.na(tailnum)) %>%
  select(tailnum, ends_with('time'))

flights %>% filter(is.na(tailnum))

df1 = tibble(x = c(1,2),
             y = c(1,1))
df2 = tibble(x = c(1,1),
             y = c(1,2))

intersect(df1, df2)
union(df1,df2) #Gives the union of unique observations
setdiff(df1,df2) #Returns observation that do not appear in DF1
setdiff(df2,df1) #observatinos that do not apeear in df2


#Case Study
#Which airlines has highest number of delayed departure. Find name of 
flights %>% filter(dep_delay > 0) %>%
  left_join(airlines) %>%
  count(name) %>% slice_max(n, n = 1)
#Prof  solution
flights %>% filter(dep_delay > 0) %>%
  count(carrier, sort = TRUE)

#To calculate proportions, we need to remove na values
flights %>% group_by(carrier) %>%
  summarize(pct = mean(dep_delay>0, na.rm = TRUE))

#mean(dep_delay > 0) returns

View(flights %>% left_join(airports, by = c('dest' = 'faa')))

#On average which airport do flights arrive most early?
#actually this code below answers the lowest average arr_Delay
flights %>% left_join(airports, by = c('dest' = 'faa')) %>%
  count(dest,name, wt = mean(arr_delay, na.rm = TRUE)) %>% arrange(n)
#if want to calculate proportions then use arr_delay < 0 which returns a boolean 0 or 1 for each entry, see the table is diff
flights %>% left_join(airports, by = c('dest' = 'faa')) %>%
  count(dest,name, wt = mean(arr_delay < 0, na.rm = TRUE))  %>% arrange(desc(n))

df = flights %>% filter(!is.na(arr_delay)) %>%
  count(month, wt = mean(arr_delay))

barplot(df$n, names.arg = df$month, ylab = 'arr_delay',border =  NA)
