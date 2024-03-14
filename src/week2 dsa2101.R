#install.packages('stringr')
library(stringr)

string2 = c('apple', 'banana', 'orange')
string2

str_c(string2, collapse = '! ') #joins together

str_sub(string2, -3,-1) #apple indices are -5 -4 -3 -2 -1

str_count(string2, c("a","b","c")) #Not the same result as below #Count a for first(apple), b for second(banana)
str_count(string2, "[abc]") #Same as below
str_count(string2, "a|b|c")


str_detect(string2, "an")
str_detect(string2, "an", negate = TRUE) #Absence of pattern
str_detect(string2, "^a") #Starting with a
str_detect(string2, "a$") #Ends with a

#Only replaces the FIRST pattern(letter) found
str_replace(string2, "a|e|i|o|u", "X")
str_replace(string2, "[aeiou]", "~") #Same but different rep
#to Replace all
str_replace_all(string2, '[aeiou]', "?")


#Detect pattern and outputs boolean
#str_detect

x1 = c("Dec", 'Apr', 'Jan', "Mar", "Apr")
x2 = factor(x1) #Sorted in alphabetical order
x2
month_levels = c("Jan","Mar","Apr","Dec")
x2 = factor(x1, ordered = TRUE, levels = month_levels)
#Alternative way;
levels(x2) = month_levels #Manually change levels but not in < order with priority


d1 = as.Date("2024/01/15")
class(d1)
d1

today = Sys.Date()
today
s1 = seq(today-100, today, by = "1 week")
weekdays(s1, abbreviate = TRUE) #Give name of the days
months(s1)

data(cars)
plot(cars$speed,cars$dist,col = 'red',cex = 1, pch = 1, xlab = 'speed', ylab = 'dist', main = 'r/s between speed and dist')
#cex change plot point size
abline(reg = lm(dist ~ speed, data = cars))


budget_cat <- c("Manpower", "Asset", "Other")
amount <- c(519.4, 38.0, 141.4)
op_budget <- data.frame(budget_cat, amount)
op_budget


barplot(op_budget$amount)
barplot(op_budget$amount, names.arg = op_budget$budget_cat)

install.packages(c("rmarkdown",'knitr'))
