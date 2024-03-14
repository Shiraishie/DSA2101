#Week 4 DSA2101 Part 2

library(tidyverse)
data(starwars)

glimpse(starwars) #see as much data as possible
#str(starwars)
head(starwars)

class(starwars) #tbl refers to tibble

#mutate - creates new variables, select - select variables by name
#arrange - reorder rows
#summarize: collapse val into single val
# all same args -- filter(df, fucntion to df and variable names w/o quotes,)

filter(starwars, sex %in% c('female','none'))
df1 = filter(starwars, sex == 'female')

#dplyr method
filter(starwars, skin_color =='light' & (sex == 'female' | sex == 'male'))
filter(starwars, skin_color =='light' & sex %in% c('female','male'))
# %in% matches conditions in a vector constructed with c();

#base R function method we can use the which function as well but not really needed --> which function returns indexes
starwars[starwars$skin_color == 'light' & (starwars$sex == 'female' | starwars$sex == 'male'), ]
starwars[which(starwars$skin_color == 'light' & (starwars$sex == 'female' | starwars$sex == 'male')), ]
#Base r need to keep doing df$?? because it doesnt know wat u referring to

#select -- columns
select(starwars, hair_color, birth_year)
#base r 
starwars[, c('hair_color', 'birth_year')]
#select in BETWEEN
select(starwars, hair_color:eye_color)
#select EXCEPT
select(starwars, -(hair_color:eye_color))
select(starwars, ends_with('color'))
#starts_woth, contains, num_range(match columns with x1,x2,x3) eg num_range('x', 1:3)

#mutate adds new columns of data
df1 = select(starwars, name,height,mass,species)

df2 = mutate(df1, height_m = height/100, BMI = mass/(height_m)^2)
#if we want put it on the left side
df2 = mutate(df1, height_m = height/100, BMI = mass/(height_m)^2, .before = name)
#.after for after name
#need the dot .before -- to highlight its an function not a column to make!
df2 = mutate(df1, height_m = height/100, BMI = mass/(height_m)^2, .after = name)

mutate_if(df1, is.character, tolower) #if column is a character, change all values in the column to lowercase

#arrange function  changes order
arrange(df1, mass, desc(height)) #desc(height) breaks ties
arrange(df1, mass, desc(height), .by_group =TRUE) #desc(height) breaks ties
#base r
df1[order(df1$mass), ]

#summarize function and creates a tibble with the respective name test
summarize(starwars, test = mean(height, na.rm = TRUE)) #na.rm ignores NA
mean(starwars$height, na.rm = TRUE)

#group_by --> arrange() uses .by_group = TRUE
df3 <- tibble(Name = c("a", "b", "c", "c", "b"),
              x = c(1, 9, 4, 15, NA))
df3

arrange(df3, Name)
df4 = group_by(df3, Name) #Creates a additional tab called Groups:

#summarize will auto do it by group
summarize(df3, x_mean = mean(x, na.rm = TRUE))
summarize(df4, x_mean = mean(x, na.rm = TRUE), x_mean2 = mean(x)) #Summarizes by groups

#showing it does the function by group
filter(df4, x>= mean(x)) #x>=mean(x) according to group
filter(df3, x>= mean(x, na.rm = TRUE))
 
mutate(df4, sum_x = cumsum(replace_na(x,0))) 

arrange(df4, x)
arrange(df4, x, .by_group = TRUE)

df5 = ungroup(df4)
