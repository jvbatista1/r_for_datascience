# Dates and times
## Introduction
### Prerequisites

library(tidyverse)
library(lubridate)
library(nycflights13)

## Creataing date/times
today()
now()

### From strings
ymd("2017-01-31")
mdy("January 31st, 2017")
dmy("31-Jan-2017")

ymd(20170131)

ymd_hms("2017-01-31 20:11:59")
mdy_hms("01/31/2017 08:01:00")

ymd(20170131, tz = "UTC")

### From individual components
flights %>% 
  select(year, month, day, hour, minute)

flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(departure = make_datetime(year, month, day, hour, minute))

make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt

flights_dt %>% 
  ggplot(aes(dep_time))+
  geom_freqpoly(binwidth = 86400)

flights_dt %>% 
  filter(dep_time<ymd(20130102)) %>% 
  ggplot(aes(dep_time))+
  geom_freqpoly(binwidth = 600)

### From other types
as_datetime(today())
as_date(now())

### Exercises
### What happens if you parse a string that contains invalid dates?
ymd(c("2010-10-10", "bananas"))
### What does the tzone argument to today() do? Why is it important?
now("UTC")
### Use the appropriate lubridate function to parse each of the following dates:

## Date_time components
datetime <- ymd_hms("2016-07-08 12:34:56")

year(datetime)
month(datetime)
mday(datetime)


yday(datetime)
wday(datetime)

month(datetime, label = TRUE)
wday(datetime, label = TRUE, abbr = FALSE)

flights_dt %>% 
  mutate(wday = wday(dep_time, label = TRUE)) %>% 
  ggplot(aes(x = wday)) +
  geom_bar()

flights_dt %>% 
  mutate(minute = minute(dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()) %>% 
  ggplot(aes(minute, avg_delay))+
  geom_line()

sched_dep <- flights_dt %>% 
  mutate(minute = minute(sched_dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n())

ggplot(sched_dep, aes(minute, n)) +
  geom_line()

### Rounding
