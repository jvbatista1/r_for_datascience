## Introduction
### Prerequisites
library(tidyverse)

## Getting started
heights <- read_csv('data/heights.csv')
read_csv("a,b,c
         1,2,3
         4,5,6")
read_csv("The first line of metadata
         The second line of metadata
         x,y,z
         1,2,3", skip = 2)

read_csv("# A comment I want to skip
         x,y,z
         1,2,3", comment = "#")

read_csv("1,2,3\n4,5,6", col_names = FALSE)

read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))

read_csv("a,b,c\n1,2,.", na = ".")

### Exercises
### What function would you use to read a file where fields were separated with “|”?

read_delim(I("a|b\n1.0|2.0"), delim = "|")
 
### Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() have in common?

read_csv(
  file,
  col_names = TRUE,
  col_types = NULL,
  col_select = NULL,
  id = NULL,
  locale = default_locale(),
  na = c("", "NA"),
  quoted_na = TRUE,
  quote = "\"",
  comment = "",
  trim_ws = TRUE,
  skip = 0,
  n_max = Inf,
  guess_max = min(1000, n_max),
  name_repair = "unique",
  num_threads = readr_threads(),
  progress = show_progress(),
  show_col_types = should_show_types(),
  skip_empty_rows = TRUE,
  lazy = should_read_lazy()
)

read_tsv(
  file,
  col_names = TRUE,
  col_types = NULL,
  col_select = NULL,
  id = NULL,
  locale = default_locale(),
  na = c("", "NA"),
  quoted_na = TRUE,
  quote = "\"",
  comment = "",
  trim_ws = TRUE,
  skip = 0,
  n_max = Inf,
  guess_max = min(1000, n_max),
  progress = show_progress(),
  name_repair = "unique",
  num_threads = readr_threads(),
  show_col_types = should_show_types(),
  skip_empty_rows = TRUE,
  lazy = should_read_lazy()
)
  
### What are the most important arguments to read_fwf()?

fwf_empty()
fwf_widths()
fwf_positions()
fwf_cols()
  
### Sometimes strings in a CSV file contain commas.
### To prevent them from causing problems they need to be surrounded by
### a quoting character, like " or '.
### By default, read_csv() assumes that the quoting character will be ".
### What argument to read_csv() do you need to specify to read the following text into a data frame?
  
read_csv("x,y\n1,'a,b'",   quote = "'")

### Identify what is wrong with each of the following inline CSV files.
### What happens when you run the code?
  
read_csv("a,b\n1,2,3\n4,5,6") #errado
read_csv("a,b,c\n1,2,3\n4,5,6") #certo

read_csv("a,b,c\n1,2\n1,2,3,4") #errado
read_csv("a,b,c,d\n1,2\n1,2,3,4") #certo

read_csv("a,b\n\"1")#errado
read_csv("a,b\n1,")#certo

read_csv("a,b\n1,2\na,b")#errado
read_csv("a,b\n1,2\na,b")#certo

read_csv("a;b\n1;3")#errado
read_csv2("a;b\n1;3")#errado

## Parsing a vector
str(parse_logical(c("TRUE", "FALSE", "NA")))
str(parse_integer(c("1", "2", "3")))  
str(parse_date(c("2010-01-01", "1979-10-14")))

parse_integer(c("1", "231", ".", "456"), na = ".")

x <- parse_integer(c("123", "345", "abc", "123.45"))
x
problems(x)

### Numbers
parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ","))

parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")

parse_number("$123,456,789")
parse_number("123.456.789", locale = locale(grouping_mark = "."))
parse_number("123'456'789", locale = locale(grouping_mark = "'"))

### Strings
charToRaw("Hadley")

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

x1
x2

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

### Factors
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)

### Dates, date-times, and times
parse_datetime("2010-10-01T2010")
parse_datetime("20101010")

parse_date("2010-10-01")

library(hms)
parse_time("01:10 am")
parse_time("20:10:01")

parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")

parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

### Exercises
### What are the most important arguments to locale()?

locale = locale()

### What happens if you try and set decimal_mark and grouping_mark to the same character? What happens to the default value of grouping_mark when you set decimal_mark to “,”? What happens to the default value of decimal_mark when you set the grouping_mark to “.”?

parse_double("123.456.789,12", locale = locale(grouping_mark = ".", decimal_mark = ","))
parse_number("123.456,78912", locale = locale(decimal_mark = ","))
parse_number("123.456,78912", locale = locale(grouping_mark = "."))

### I didn’t discuss the date_format and time_format options to locale(). What do they do? Construct an example that shows when they might be useful.

parse_guess("2010-10-01", locale = locale(date_format = "%Y/%m/%d"))

### If you live outside the US, create a new locale object that encapsulates the settings for the types of file you read most commonly.
### What’s the difference between read_csv() and read_csv2()?
### What are the most common encodings used in Europe? What are the most common encodings used in Asia? Do some googling to find out.
### Generate the correct format string to parse each of the following dates and times:
d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014
t1 <- "1705"
t2 <- "11:15:10.12 PM"

parse_date(d1, "%B %d, %Y")
parse_date(d2, "%Y-%b-%d")
parse_date(d3, "%d-%b-%Y")
parse_date(d4, "%B %d (%Y)")
parse_date(d5, "%m/%d/%y")
parse_time(t1, "%H%M")
parse_time(t2, "%I:%M:%OS %p")

## Parsing a file
### Strategy
guess_parser("2010-10-01")
guess_parser("15:01")
guess_parser(c("TRUE", "FALSE"))
guess_parser(c("1", "5", "9"))
guess_parser(c("12,352,561"))

str(parse_guess("2010-10-10"))

### Problems
challenge <- read_csv(readr_example("challenge.csv"))

problems(challenge)

tail(challenge)

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)

### Other strategies
challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)
challenge2

challenge2 <- read_csv(readr_example("challenge.csv"), 
                       col_types = cols(.default = col_character())
)

df <- tribble(
  ~x, ~y,
  "1", "1.21",
  "2", "2.32",
  "3", "4.56"
)
df
type_convert(df)

## Writing to a file
write_csv(challenge, "C:/Users/Victor/git/r_for_datascience/output/data/challenge.csv")

challenge
write_csv(challenge, "C:/Users/Victor/git/r_for_datascience/output/data/challenge-2.csv")
read_csv("C:/Users/Victor/git/r_for_datascience/output/data/challenge-2.csv")

write_rds(challenge, "C:/Users/Victor/git/r_for_datascience/output/data/challenge.rds")
read_rds("C:/Users/Victor/git/r_for_datascience/output/data/challenge.rds")

library(feather)
write_feather(challenge, "C:/Users/Victor/git/r_for_datascience/output/data/challenge.feather")
read_feather("C:/Users/Victor/git/r_for_datascience/output/data/challenge.feather")

## Other types of data
##haven
##readxl
##DBI