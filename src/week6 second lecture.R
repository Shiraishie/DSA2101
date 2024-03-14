#Week 6 Second lecture
library(tidyverse)
library(dplyr)
data(billboard)
#contains or wk1:wk76 and can use gather function
billboard %>% pivot_longer(contains('wk'), names_to = 'week', values_to = 'rank', values_drop_na =  TRUE) %>%
  mutate(week = as.numeric(str_remove(week, 'wk'))) -> df

#Convert the date entered into the actual date 
df = df %>% mutate(date_rank = date.entered +  7 * (week -1)) %>%
  select(-date.entered)

#just count my track because when it drops out of the billboard -- we ommited those entries
df %>% count(track, sort = TRUE)
billboard %>% count(track) #to crosscheck

#for unique artist and track since one song duplicated by two artist
df %>% count(artist, track, sort = TRUE)

#to check distinct combinations(no song with same name)
df %>% distinct(track) #one song sang my two singers
df %>% distinct(artist,track)
#to find the song -- check billboard instead of df
billboard %>% count(track, sort = TRUE)

df %>% filter(rank == 1 ) %>%
  count(artist, track, sort = TRUE)



df1 = df %>% count(artist, sort= TRUE) %>% slice_max(n, n=10)
par(mar = c(5,6,2,2))


data(who2)
#or pivot_longer(spm014 : relm5564) #or -c(country,year) or !(country:year)
who2 %>% pivot_longer(3:58,
                      names_to = c('method', 'gender', 'age'),
                      names_sep = '_',
                      values_to = 'cases')
                      
#splits sp_m_014 to sp m 014

data(cms_patient_experience)

df = cms_patient_experience %>% pivot_wider(id_cols = starts_with('org'),
                                            names_from = measure_cd, values_from = prf_rate)
#starts_with removes redundant info -- collapses the data but we lost info of measure title
