# Tibbles
## Introduction
library(tidyverse)

## Creating tibbles
as_tibble(iris)

tibble(
  x = 1:5,
  y = 1,
  z = x^2+y
)

tb <- tibble(
  `:)` = "smile",
  ` ` = "space",
  `2000` = "number"

)

tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)

## Tibblees vs. data.frame
### Printing
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

nycflights13::flights %>% 
  print(n = 10, width = Inf)

nycflights13::flights %>% 
  View()

### Subsetting
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

df$x
df[["x"]]
df[[1]]
df %>% 
  .$x
df %>% 
  .[["x"]]

## Interacting with older code
class(as.data.frame(tb))

## Exercises
# How can you tell if an object is a tibble? (Hint: try printing mtcars, which is a regular data frame).
print(mtcars)

# Compare and contrast the following operations on a data.frame and equivalent tibble. What is different? Why might the default data frame behaviours cause you frustration?
df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

tb <- tibble(abc = 1, xyz = "a")
tb$x
tb[, "xyz"]
tb[, c("abc", "xyz")]

# If you have the name of a variable stored in an object, e.g. var <- "mpg", how can you extract the reference variable from a tibble?
var <- "mpg"

mtcars$var
mtcars[[var]]


# Practice referring to non-syntactic names in the following data frame by:
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

# Extracting the variable called 1.
annoying[[1]]

# Plotting a scatterplot of 1 vs 2.
ggplot(data = annoying) +
  geom_point(mapping = aes(x = `1`, y = `2`))

# Creating a new column called 3 which is 2 divided by 1.
annoying$`3` = annoying[[2]]/annoying[[1]]

# Renaming the columns to one, two and three.
annoying %>% 
  rename(one = `1`) %>% 
  rename(two = `2`) %>% 
  rename(three = `3`)

# What does tibble::enframe() do? When might you use it?
enframe(c(10:25))

# What option controls how many additional column names are printed at the footer of a tibble?
options(tibble.max_extra_cols)