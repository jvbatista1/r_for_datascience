#Tidy data
##Introduction
### Prerequisites
library(tidyverse)

##Tidy data
table1
table2
table3
table4a
table4b

table1 %>% 
  mutate(rate = cases/population*1000)
table1 %>% 
  count(year, wt = cases)
library(ggplot2)
ggplot(table1, aes(year, cases))+
  geom_line(aes(group = country), colour = "grey50")+
  geom_point(aes(colour = country))

### Exercises
#Using prose, describe how the variables and observations are organised in each of the sample tables.
# The first one uses one column per variable, online per observation and one cell per value
# The second uses one column just for counting values, doubling the number of rows
# The third uses one column for rate, presenting the data in a fraction form
# The last divide the dataframe in two, one for each variable.

#Compute the rate for table2, and table4a + table4b. You will need to perform four operations:
# Extract the number of TB cases per country per year.
table2.1 <- table2 %>% 
  filter(type == "cases") %>% 
  rename(cases = count) %>% 
  arrange(country, year)

table4a

# Extract the matching population per country per year.
table2.2 <- table2 %>% 
  filter(type == "population") %>% 
  rename(population = count) %>% 
  arrange(country, year)

table4b

# Divide cases by population, and multiply by 10000.
table2.3 <- tibble(
  country = table2.1$country,
  year = table2.1$year,
  cases = table2.1$cases,
  population = table2.2$population
) %>% 
  mutate(rate = (cases/population)*1000) %>%
  select(country, year, rate)

table4c <- tibble(
  country = table4a$country,
  `1999` = (table4a$`1999`/table4b$`1999`)*1000,
  `2000` = (table4a$`2000`/table4b$`2000`)*1000
)
  
# Store back in the appropriate place.
table2.3 <- table2.3 %>% 
  mutate(type = "rate") %>% 
  rename(count = rate)

bind_rows(table2, table2.3) %>% 
  arrange(country, year, type, count)

table4c

# Which representation is easiest to work with? Which is hardest? Why?
# Second is a bit easier, but none is easier as tidy
  
#Recreate the plot showing change in cases over time using table2 instead of table1. What do you need to do first?

## Pivoting
### Longer
