library(nycflights13)
library(tidyverse)

### nycflights13 ###
View(flights)
flights

##### Filter rows with filter() #####
jan1 <- filter(flights, month == 1, day == 1)
(dec <- filter(flights, month ==12, day == 25))

### comparisons ###
filter(flights, month == 11 | month == 12)
nov_dec <- filter(flights, month %in% c(11, 12))

filter (flights, !(arr_delay > 120 | dep_delay < 120))
filter (flights, arr_delay <= 120, dep_delay <= 120)

### missing values ###
df <- tibble(x = c(1, NA, 3))
filter (df, x>1)
filter (df, is.na(x)| x > 1)

## exercises ##
filter(flights, arr_delay >= 120)
filter(flights, dest == 'IAH' | dest == 'HOU')
filter(flights, carrier == 'UA' | carrier == 'AA' | carrier == 'DL')
filter (flights, month == 7 | month == 8 | month == 9)
filter(flights, arr_delay > 120 & dep_delay <= 0)
filter(flights, arr_delay >= 60 & air_time > 30)
filter(flights, dep_time <= 600 | dep_time == 2400)

##### Arrange rows with arrange() #####
arrange(flights, year, month, day)
arrange(flights, desc(dep_delay))

df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

## Exercises ##
arrange(df, desc(is.na(x)))
arrange(flights, desc(dep_delay))
arrange(flights, air_time)
arrange(flights, distance)
arrange(flights, desc(distance))

##### Select columns with select () #####
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

?select

rename(flights, tail_num = tailnum)
select(flights, time_hour, air_time, everything())

## exercises ##
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, dep_time:arr_delay, -c(sched_dep_time, sched_arr_time))
select(flights, dep_time, dep_time)

vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, -any_of(vars))

select(flights, contains("TIME"))

##### Add new variables with mutate() #####
flights_sml <-  select(flights,
                       year:day,
                       ends_with('delay'),
                       distance,
                       air_time)

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60)

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60,
       hours = air_time / 60,
       gain_per_hour = gain / hours)

transmute(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60,
       hours = air_time / 60,
       gain_per_hour = gain / hours)

### Useful creation functions ###
transmute(flights,
          dep_time,
          hours = dep_time %/% 100,
          minutes = dep_time %% 100)

## exercise ##

transmute(flights,
          dep_time, sched_dep_time,
          hours1 = dep_time %/% 100,
          hours2 = sched_dep_time %/% 100,
          dep_time_min = hours1 * 60 + (dep_time %% 100),
          sched_dep_time_min = hours2 * 60 + (sched_dep_time %% 100))

transmute(flights,
          hours1 = dep_time %/% 100,
          hours2 = arr_time %/% 100,
          dep_time_min = hours1 * 60 + (dep_time %% 100),
          arr_time_min = hours2 * 60 + (arr_time %% 100),
          air_time,
          air_time1 = arr_time - dep_time,
          air_time2 = arr_time_min - dep_time_min)
