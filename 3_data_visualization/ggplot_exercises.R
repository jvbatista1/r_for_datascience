#tirado do https://r4ds.had.co.nz/data-visualisation.html

library(tidyverse)

####### the mpg dataframe #######
View(mpg)

####### creating a ggplot #######
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

#ggplot(data = mpg) + 
#  geom_point(mapping = aes(x = hwy, y = cyl))

#ggplot(data = mpg) + 
#  geom_point(mapping = aes(x = class, y = drv))

####### aesthetic mappings #######
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

#ggplot(data = mpg) +
#  geom_point(mapping = aes(x = displ, y = hwy, color = year))

#ggplot(data = mpg) +
#  geom_point(mapping = aes(x = displ, y = hwy, size = year))

#ggplot(data = mpg) +
#  geom_point(mapping = aes(x = displ, y = hwy, shape = year))

#ggplot(data = mpg) +
#  geom_point(mapping = aes(x = displ, y = hwy, color = year, size = year))

#ggplot(data = mpg) +
#  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))

####### facets #######
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

#ggplot(data = mpg) +
#  geom_point(mapping = aes(x = displ, y = hwy)) +
#  facet_grid(. ~ cyl)

#ggplot(data = mpg) +
#  geom_point(mapping = aes(x = displ, y = hwy)) +
#  facet_wrap(~ year, nrow = 2)

#?facet_wrap

####### geometric objects #######
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point()+
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class))+
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class))+
  geom_smooth(data = filter(mpg, class == 'subcompact'), se = FALSE)

## exercises ##
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_line()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_histogram()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_area()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(se = F)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(se = F, mapping = aes(group = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = F, mapping = aes(group = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = drv)) + 
  geom_smooth(se = F)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = drv)) + 
  geom_smooth(se = F, mapping = aes(linetype = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, fill = drv)) + 
  geom_point(shape = 21, colour = "white")

####### statistical transformations #######
View(diamonds)

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

?geom_bar

ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))

demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))

ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

## exercises ##
ggplot(data = diamonds) +
  geom_col(mapping = aes(x = cut, y = depth))

?stat_smooth()

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop), group = 1))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = after_stat(prop), group = 1))

####### position adjustments #######
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, colour = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")

ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
  geom_bar(fill = NA, position = "identity")

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), position = 'jitter')

## exercises ##
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point(position = 'jitter')

?geom_jitter()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_jitter()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_count()

?geom_boxplot

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, group = class, color = class)) + 
  geom_boxplot(show.legend = T)

####### coordinate systems #######
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()+
  coord_flip()

nz <- map_data('nz')
?map_data

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = 'white', colour = 'black')

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = 'white', colour = 'black')+
  coord_quickmap()

bar <- ggplot(data=diamonds) +
  geom_bar(
    mapping = aes(x=cut, fill=cut),
    show.legend = T,
    width=1
  ) +
  theme(aspect.ratio = 1) +
  labs(x=NULL, y=NULL)

bar + coord_flip()
bar + coord_polar()

## exercises ##
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))+
  coord_polar()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()

