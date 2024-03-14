

## RDS Files
hawkers = readRDS("../data/hawker_ctr_raw.rds")
View(hawkers)

str(hawkers[[1]][[7]]) ##Acess the only list,aka first list: List of 117, then the 7th item

#Remove first sublist 
hawkers_116 = hawkers[[1]][-1] #[-i] removes the i'th sublist

hawkers_116[[1]]$ADDRESSSTREETNAME #or
hawkers_116[[1]][[4]]

#sapply to apply to ALL
street_name = sapply(hawkers_116, function(x) x$ADDRESSSTREETNAME)
head(street_name, n = 10)


postal_code = sapply(hawkers_116, function(x) x$ADDRESSPOSTALCODE)
name = sapply(hawkers_116, function(x) x$NAME)
coordinates = sapply(hawkers_116, function(x) x$XY)

hawkers_df = data.frame(street_name, postal_code,name,coordinates) #bind vector into df

##OR easier way to make df
hawkers_df = do.call(rbind, lapply(hawkers_116, as.data.frame)) #lapply makes every row in the list a data frame -- list of DF
#check = lapply(hawkers_116,as.data.frame)
#do.call executes rbind into the LIST of arguements(lapply func returns a LIST of DF) 
View(hawkers_df)



library(jsonlite)

txt = '[12,3,4]'
fromJSON(txt);

l = fromJSON('../data/read_json_01.txt') #fromJson only reads one line



all_lines = readLines('../data/read_json_02.txt') #Creates a vector
json_list = lapply(all_lines, fromJSON) #Applys fromJSON to each entry
str(json_list)

convert_2_df = function(x){ #%in% means included in -- check if string appears, == checks for equality
  lower = ifelse("lower" %in% x$shelf,1,0);
  middle = ifelse('middle' %in% x$shelf,1,0);
  upper = ifelse('upper' %in% x$shelf,1,0);
  
  data.frame(fruit = x$fruit, price = x$price, lower,middle,upper) #can write return also, returns same thing
}

df_row = lapply(json_list, convert_2_df)

#one way to combine if limited number of components in the list
df_fruit = rbind(df_row[[1]], df_row[[2]], df_row [[3]])

#or
df_fruit = do.call(rbind, df_row)


#
NYrest = readLines('../data/restaurants_dataset.json')
NYrest_json = lapply(NYrest, fromJSON)

NYrest_json[[1]]

all_borough = sapply(NYrest_json, function(x) x$borough)

table(all_borough) #shows missing data

#Remove missing
id = which(all_borough == 'Missing') #indexes with missing info
NYrest_json = NYrest_json[-id]

all_borough = sapply(NYrest_json, function(x) x$borough)

table(all_borough) #shows missing data


all_rest_ids = sapply(NYrest_json, function(x) x$restaurant_id)
length(unique(all_rest_ids)) == length(all_rest_ids) #True therefore it is unique


NYrest_json[[1]]$grades #nrows >= 1

n_scores = sapply(NYrest_json, function(x) nrow(x$grades)) #But it returns list rather than vector
#Implies that not are dataframes


##Another way to check 
score_count = function(x){
  if (class(x$grades) == 'data.frame'){
    scores = nrow(x$grades)
  }
  else{
    scores = 0
  }
  return (scores)
}
#Getting inspection scores!!
n_scores = sapply(NYrest_json, score_count)
sum(n_scores == 0) 

NYrest_json = NYrest_json[n_scores != 0] #Put False into list either this or -id

mean_score = sapply(NYrest_json, function(x) mean(x$grades$score))
sum(is.na(mean_score)) #Num of entries with NA mean_score

id = which(is.na(mean_score))
NYrest_json = NYrest_json[-id] #This or
#
lapply(NYrest_json[id],function(x) x$grades) #shows the grades of id with mean_score NA == shows 'Not Yet Graded'

id1 = which(mean_score < 0)
lapply(NYrest_json[id1], function(x) x$grades)
NYrest_json = NYrest_json[-id1]

borough = sapply(NYrest_json, function(x) x$borough)
