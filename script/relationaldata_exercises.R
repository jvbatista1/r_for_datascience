# Relational data
## Introduction
### Prerequisites
library(tidyverse)
library(nycflights13)

## nycflights13
airlines

airports

planes

weather

### Exercises
#### Imagine you wanted to draw (approximately) the route each plane flies from its origin to its destination.
#### What variables would you need?
#### What tables would you need to combine?
c(airports, flights)
  
#### I forgot to draw the relationship between weather and airports.
#### What is the relationship and how should it appear in the diagram?
airports$faa
weather$origin
  
#### weather only contains information for the origin (NYC) airports.
#### If it contained weather records for all airports in the USA, what additional relation would it define with flights?
  
#### We know that some days of the year are “special”, and fewer people than usual fly on them.
#### How might you represent that data as a data frame? What would be the primary keys of that table?
#### How would it connect to the existing tables?
year
month
day
specialholidays

## Keys
planes %>% 
  count(tailnum) %>% 
  filter(n>1)
weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n>1)

flights %>% 
  count(year, month, day, flight) %>% 
  filter(n > 1)
flights %>% 
  count(year, month, day, tailnum) %>% 
  filter(n > 1)

### Exercises
#### Add a surrogate key to flights.
flights %>%
  arrange(year, month, day, sched_dep_time, carrier, flight) %>%
  mutate(flight_id = row_number()) %>%
  glimpse()

#### Identify the keys in the following datasets
Lahman::Batting
babynames::babynames
nasaweather::atmos
fueleconomy::vehicles
ggplot2::diamonds
#### (You might need to install some packages and read some documentation.)
#### Draw a diagram illustrating the connections between the Batting, People, and Salaries tables in the Lahman package.
#### Draw another diagram that shows the relationship between People, Managers, AwardsManagers.
#### How would you characterize the relationship between the Batting, Pitching, and Fielding tables?

## Mutating joins
flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

flights2 %>% 
  select(-origin, -dest) %>% 
  left_join(airlines, by="carrier")

flights2 %>%
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

### Understanding joins
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)
### Inner join
x %>% 
  inner_join(y, by = "key")

### Outer joins
### Duplicate keys
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)
left_join(x, y, by = "key")

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)
left_join(x, y, by = "key")

### Defining the key columns
flights2 %>% 
  left_join(weather)

flights2 %>% 
  left_join(planes, by = "tailnum")

flights2 %>% 
  left_join(airports, c("dest" = "faa"))
flights2 %>% 
  left_join(airports, c("origin" = "faa"))

### Exercises
#### Compute the average delay by destination, then join on the airports data frame so you can show the spatial distribution of delays. Here’s an easy way to draw a map of the United States:
  airports %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()
#### (Don’t worry if you don’t understand what semi_join() does — you’ll learn about it next.)
#### You might want to use the size or colour of the points to display the average delay for each airport.
#### Add the location of the origin and destination (i.e. the lat and lon) to flights.
#### Is there a relationship between the age of a plane and its delays?
#### What weather conditions make it more likely to see a delay?
  
#### What happened on June 13 2013? Display the spatial pattern of delays, and then use Google to cross-reference with the weather.

### Other implementations

## Filtering joins
top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest

flights %>% 
  filter(dest %in% top_dest$dest)

flights %>% 
  semi_join(top_dest)

flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)

### Exercises
#### What does it mean for a flight to have a missing tailnum? What do the tail numbers that don’t have a matching record in planes have in common? (Hint: one variable explains ~90% of the problems.)

#### Filter flights to only show flights with planes that have flown at least 100 flights.

#### Combine fueleconomy::vehicles and fueleconomy::common to find only the records for the most common models.

#### Find the 48 hours (over the course of the whole year) that have the worst delays. Cross-reference it with the weather data. Can you see any patterns?
  
#### What does anti_join(flights, airports, by = c("dest" = "faa")) tell you? What does anti_join(airports, flights, by = c("faa" = "dest")) tell you?
  
#### You might expect that there’s an implicit relationship between plane and airline, because each plane is flown by a single airline. Confirm or reject this hypothesis using the tools you’ve learned above.

## Join problems
airports %>% count(alt, lon) %>% filter(n > 1)

## Set operations
df1 <- tribble(
  ~x, ~y,
  1,  1,
  2,  1
)
df2 <- tribble(
  ~x, ~y,
  1,  1,
  1,  2
)

intersect(df1, df2)
union(df1, df2)
setdiff(df1, df2)
setdiff(df2, df1)

