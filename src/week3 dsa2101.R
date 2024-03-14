library(readxl)

#df1 = read_excel('read_excel_01.xlsx')
#View(df1)
df1 = read_excel('read_excel_01.xlsx', skip = 5, col_names = FALSE)
View(df1)
#df1 = read_excel('read_excel_01.xlsx', range = 'C6:E8', col_names = FALSE)

#?read_excel to view documentation

female_04 = read_excel('UNESCAP_population_2010_2015.xlsx', sheet = 3)
View(female_04)

library(stringr)
file_name = 'UNESCAP_population_2010_2015.xlsx'
sheet_names = excel_sheets(file_name)
?excel_sheets

female_04$age = str_split(sheet_names[3],',', simplify = TRUE)[3]
female_04$age = str_trim(female_04$age)

?str_split
check = str_split(sheet_names[3],',', simplify = TRUE)
#w/o the simplify, returns a list rather than return matrix


###Read in data for 0-14
sheet_names = excel_sheets(file_name)[3:8]

all_data = NULL
for (names in sheet_names){
  temp_data = read_excel(file_name, sheet = names);
  age_group = str_split(names, ',' , simplify = TRUE)[3]
  gender = str_split(names, ",", simplify = TRUE)[2]
  temp_data$age = str_trim(age_group)
  temp_data$gender = str_trim(gender)
  all_data = rbind(all_data, temp_data)
}