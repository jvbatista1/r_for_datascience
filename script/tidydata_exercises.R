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
tidy4a <- table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

tidy4b <- table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")

left_join(tidy4a, tidy4b)

### Wide
table2 %>% 
  pivot_wider(names_from = "type", values_from = "count")

### Exercises
# Why are pivot_longer() and pivot_wider() not perfectly symmetrical?
# Carefully consider the following example:
  
stocks <- tibble(
    year   = c(2015, 2015, 2016, 2016),
    half  = c(   1,    2,     1,    2),
    return = c(1.88, 0.59, 0.92, 0.17)
  )

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")

# (Hint: look at the variable types and think about column names.)
# pivot_longer() has a names_ptypes argument, e.g.  names_ptypes = list(year = double()). What does it do?
  
# Why does this code fail?
  
  table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

# What would happen if you widen this table? Why? How could you add a new column to uniquely identify each value?
  
  people <- tribble(
    ~name,             ~names,  ~values,
    #-----------------|--------|------
    "Phillip Woods",   "age",       45,
    "Phillip Woods",   "height",   186,
    "Phillip Woods",   "age",       50,
    "Jessica Cordero", "age",       37,
    "Jessica Cordero", "height",   156
  )

people %>% 
  pivot_wider(names_from = names, values_from = values)

people2 <- people %>%
  group_by(name, names) %>%
  mutate(obs = row_number())

people2 %>% 
  pivot_wider(names_from = names, values_from = values)
  
# Tidy the simple tibble below. Do you need to make it wider or longer? What are the variables?
  
  preg <- tribble(
    ~pregnant, ~male, ~female,
    "yes",     NA,    10,
    "no",      20,    12
  )
  
preg_tidy <- preg %>%
  pivot_longer(c(male, female), names_to = "sex", values_to = "count")
preg_tidy
preg_tidy2<- preg %>%
  pivot_longer(c(male, female), names_to = "sex", values_to = "count", values_drop_na = TRUE)
preg_tidy2

## Separating and uniting
### Separating
table3 %>% 
  separate(rate, into = c("cases", "population"))

table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")

table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)

table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)

### Unite
table5 %>% 
  unite(new, century, year)

table5 %>% 
  unite(new, century, year, sep = "")

### Exercises
# What do the extra and fill arguments do in separate()? Experiment with the various options for the following two toy datasets.

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = "merge")

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill = "left")
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill = "right")

# Both unite() and separate() have a remove argument. What does it do? Why would you set it to FALSE?
table3 %>% 
  separate(rate, into = c("cases", "population"), remove = FALSE)

table5 %>% 
  unite(new, century, year, sep = "", remove = FALSE)

# Compare and contrast separate() and extract(). Why are there three variations of separation (by position, by separator, and with groups), but only one unite?
tibble(x = c("X_1", "X_2", "AA_1", "AA_2")) %>%
  separate(x, c("variable", "into"), sep = "_")

tibble(x = c("X1", "X2", "Y1", "Y2")) %>%
  separate(x, c("variable", "into"), sep = c(1))

tibble(x = c("X_1", "X_2", "AA_1", "AA_2")) %>%
  extract(x, c("variable", "id"), regex = "([A-Z])_([0-9])")

tibble(x = c("X1", "X2", "Y1", "Y2")) %>%
  extract(x, c("variable", "id"), regex = "([A-Z])([0-9])")

## Missing values
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

stocks %>% 
  pivot_wider(names_from = year, values_from = return)

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "year", 
    values_to = "return", 
    values_drop_na = TRUE
  )

stocks %>% 
  complete(year, qtr)

treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)

treatment %>% 
  fill(person)

## Case Study
View(who)

who1 <- who %>% 
  pivot_longer(
    cols = new_sp_m014:newrel_f65, 
    names_to = "key", 
    values_to = "cases", 
    values_drop_na = TRUE
  )
View(who1)

who1 %>% 
  count(key)

who2 <- who1 %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2

who3 <- who2 %>% 
  separate(key, c("new", "type", "sexage"), sep = "_")
who3

who3 %>% 
  count(new)

who4 <- who3 %>% 
  select(-new, -iso2, -iso3)

who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)
who5

who %>%
  pivot_longer(
    cols = new_sp_m014:newrel_f65, 
    names_to = "key", 
    values_to = "cases", 
    values_drop_na = TRUE
  ) %>% 
  mutate(
    key = stringr::str_replace(key, "newrel", "new_rel")
  ) %>%
  separate(key, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)

## Non-tidy data