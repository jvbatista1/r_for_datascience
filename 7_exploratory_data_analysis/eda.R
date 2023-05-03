library(tidyverse)
library(lvplot)

##### VARIATION #####
### Visualizing distributions ###
ggplot(data = diamonds)+
  geom_bar(mapping = aes(x = cut))

diamonds %>% 
  count(cut)

ggplot(data=diamonds)+
  geom_histogram(mapping=aes(x=carat), binwidth = 0.5)

diamonds %>% 
  count(cut_width(carat, 0.5))

smaller <- diamonds %>% 
  filter(carat<3)

### Typical values ###
ggplot(data=smaller, mapping = aes(x=carat))+
  geom_histogram(binwidth = 0.1)

ggplot(data = smaller, mapping = aes(x = carat, colour = cut))+
  geom_freqpoly(binwidth=0.1)

ggplot(data = smaller, mapping = aes(x=carat))+
  geom_histogram(binwidth = 0.01)

ggplot(data = faithful, mapping = aes(x = eruptions))+
  geom_histogram(binwidth = 0.25)

### Unusual values ###
ggplot(diamonds)+
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

ggplot(diamonds)+
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)+
  coord_cartesian(ylim = c(0,50))

unusual <- diamonds %>% 
  filter(y<3|y>20) %>% 
  select(price, x, y, z) %>% 
  arrange(y)
unusual

### Exercises
ggplot(diamonds)+
  geom_histogram(mapping = aes(x = x), binwidth = 0.1)+
  coord_cartesian(ylim = c(0,50))

ggplot(diamonds)+
  geom_histogram(mapping = aes(x = z), binwidth = 0.1)+
  coord_cartesian(ylim = c(0,50), xlim = c(0,5))

unusual <- diamonds %>% 
  filter(z<1|z>10) %>% 
  select(price, x, y, z) %>% 
  arrange(z)
unusual

ggplot(diamonds)+
  geom_histogram(mapping = aes(x=price), binwidth = 1)+
  coord_cartesian(ylim = c(0,50), xlim = c(0,5000))

ggplot(diamonds)+
  geom_histogram(mapping = aes(x = carat), binwidth = 0.01)+
  coord_cartesian(xlim = c(0.5,1.5))

diamonds %>%
  filter(carat>0.98 & carat<1.01) %>% 
  count(carat)

##### MISSING VALUES #####
diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))

diamonds2 <- diamonds %>% 
  mutate(y=ifelse(y<3|y>20, NA, y))

ggplot(data = diamonds2, mapping = aes(x=x, y=y))+
  geom_point()

ggplot(data = diamonds2, mapping = aes(x=x, y=y))+
  geom_point(na.rm=T)

nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)

##### COVARIATION #####
### A categorical and a continuous variable ###
ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(data=diamonds, mapping=aes(x=cut, y=price))+
  geom_boxplot()

ggplot(data=mpg, mapping=aes(x=class, y=hwy))+
  geom_boxplot()

ggplot(data=mpg)+
  geom_boxplot(mapping=aes(x=reorder(class, hwy, FUN = median), y=hwy))

ggplot(data=mpg)+
  geom_boxplot(mapping=aes(x=reorder(class, hwy, FUN = median), y=hwy))+
  coord_flip()

### Exercises
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(x=cancelled, y=(..count..)/sum(..count..))) + 
  geom_bar()


nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(x=cancelled, y=sched_dep_time)) + 
  geom_boxplot()

ggplot(data=diamonds, mapping = aes(x=price, y=carat))+
  geom_point()

ggplot(data=diamonds, mapping = aes(x=cut, y=carat))+
  geom_boxplot()

ggplot(data=diamonds, mapping=aes(x=cut, y=price))+
  geom_lv()

ggplot(data=diamonds, mapping=aes(x=cut, y=price))+
  geom_violin()

ggplot(data=diamonds, mapping=aes(x=price, y=..density..))+
  geom_histogram()+
  facet_wrap(vars(cut))

### Two categorical variables ###
ggplot(data=diamonds)+
  geom_count(mapping = aes(x=cut,y=color))
             