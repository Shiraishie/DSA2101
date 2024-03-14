netflix = readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-04-20/netflix_titles.csv')
head(netflix,5)

table(netflix$type) #shows summmary
summary(netflix)

#netflix$type = factor(netflix$type) # or
netflix$type = as.factor(netflix$type)

barplot(table(netflix$type), main = 'Distribution of types')

library(stringr)
library(jsonlite)

#histogram
movies = netflix[netflix$type == 'Movie', ]
movies$minute = as.numeric(stringr::str_replace(movies$duration, " min", ""))
##Creates new col called minutes as numeric while replace min as ''

hist(movies$minute, breaks = 30, xlab ='duration in mins', main = 'distribution of movie duration')

#Read data via API
url <- paste0("https://data.gov.sg",
              "/api/action/datastore_search?",
              "resource_id=d_1a88e269bf1d629b93fb5cafa189f9fb") #only queries 100 lines but total of 210 data
results_json <- fromJSON(url)
# results_json = results_json[-1] to remove manually


# Current number of rows
results_data <- results_json[["result"]][["records"]]
# Total expected number of rows
total_records <- results_json[["result"]][["total"]]
# Queries
while(nrow(results_data) < total_records) {
  url1 <- paste0("https://data.gov.sg",
                 results_json[["result"]][["_links"]][["next"]])
  results_json <- fromJSON(url1)
  results_data <- rbind(results_data, results_json[["result"]][["records"]])
}

str(results_data)

library(dplyr)
library(tidyverse)

young <- filter(results_data, age == "20-29", year == 2015) %>%
  mutate(pct = as.numeric(ever_used)) %>%
  arrange(desc(pct))
head(young, n = 2)

par(mar = c(5,7,2,2)) ##adjust the margins

barplot(young$pct, names.arg = young$media_activity, horiz= TRUE, las = 1, border = FALSE, cex.names = 0.7)
#las changes to horizontal

ggplot(data = young, aes(x = media_activity, y = pct)) +
  geom_bar(stat = "identity") + coord_flip()

#DIY
url <- paste0("https://data.gov.sg",
              "/api/action/datastore_search?",
              "resource_id=d_3c55210de27fcccda2ed0c63fdd2b352")

diy = fromJSON(url)
total = diy[['result']][['total']]
results_data = diy[['result']][['records']]

while (nrow(results_data) < total){
    next_url = diy$result$`_links`$`next`;
    url = paste0('https://data.gov.sg', next_url);
    diy = fromJSON(url)
    results_data = rbind(results_data, diy$result$records);
}


starwars %>% slice_min(n = 1 , height)
starwars %>% summarize_at(vars(birth_year),mean, na.rm = TRUE)
#?summarize

#distinct() to find unique rows
starwars %>% distinct()
starwars %>% unique() #same

starwars %>% distinct(gender, hair_color) #doesnt keep the other columns, keeps only the first distinct observation
starwars %>% distinct(gender, hair_color, .keep_all = TRUE) #Keeps all columns

starwars %>% count(gender, hair_color, sort = TRUE)


starwars %>% rename(character_name = name)#
#or
starwars %>% rename(character_name = 1)

#slice_head, slice_tail - takes first of last row of each group
#slice_sample - random row from a group
#slice does according to groups - if ungrouped than 1 obs

#relocate by default is to the left, we can specifcy using .before = or .after =
starwars %>% na.omit()
starwars %>% filter(!is.na(gender))

View(starwars %>% mutate_if(is.character, na_if, "none"))#mutate if column is a character type, apply na_if, if element in the column is none

     