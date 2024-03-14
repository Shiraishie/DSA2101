library(readxl)
library(stringr)

file = read_excel('../data/UNESCAP_population_2010_2015.xlsx', sheet = 3)
file_name = '../data/UNESCAP_population_2010_2015.xlsx'
sheet_names = excel_sheets(file_name)

str_split(sheet_names[3], ',')[[1]][3]
#or
str_trim(str_split(sheet_names[3], ',', simplify = TRUE)[3]) #trim removes spaces
#true returns a matrix instead of a list

View(file)

library(jsonlite)
library(dplyr)

one = fromJSON('../data/read_json_01.txt') #reads only one line
two = read_lines('../data/read_json_02.txt') #reads each line into vector
l = lapply(two, fromJSON) 

#convert to df we can use lapply
convert_to_df_function = function(x) {
  lower = ifelse("lower" %in% x$shelf,1,0);
  middle = ifelse('middle' %in% x$shelf,1,0);
  upper = ifelse('upper' %in% x$shelf,1,0);
  
  return (data.frame(fruit = x$fruit, price = x$price, lower,middle,upper)) #replaces it as a df instead in the list
}
df_row = lapply(l, convert_to_df_function)

#convert all to DF instead through
df_row2 = do.call(rbind, df_row) #do.callcan help to combine list
#or
df_row1 = rbind(df_row[[1]], df_row[[2]], df_row[[3]])





#convert to json
rest = readLines('../data/restaurants_dataset.json')
rest_json = lapply(rest, fromJSON)

x = rest_json[[1]]

all_borough = sapply(rest_json, function(x) x$borough)
table(all_borough) #gives unique obs

rest_json = rest_json[-c(which(all_borough == 'Missing'))]

all_borough = sapply(rest_json, function(x) x$borough)

table(all_borough) #Missing data is gone

all_id = sapply(rest_json, function(x) x$restaurant_id)
all_id = unique(all_id)

n_scores = sapply(rest_json, function(x) mean(x$grades$score))
z = which(is.na(n_scores))
rest_json1 = rest_json[-z]
n_scores1 = sapply(rest_json1, function(x) mean(x$grades$score))
