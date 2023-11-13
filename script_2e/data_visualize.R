## Introduction
### Prerequisites
library(tidyverse)
library(palmerpenguins)
library(ggthemes)

## First steps
### The `penguins` data frame
penguins

glimpse(penguins)

? penguins

### Ultimate goal
### Creating a ggplot
ggplot(
  data=penguins,
  mapping=aes(x=flipper_length_mm, y=body_mass_g)
)+
  geom_point()

### Adding aesthetics and layers
ggplot(
  data=penguins,
  mapping=aes(x=flipper_length_mm, y=body_mass_g, color = species)
)+
  geom_point()+
  geom_smooth(method = "lm")

ggplot(
  data=penguins,
  mapping=aes(x=flipper_length_mm, y=body_mass_g)
)+
  geom_point(mapping = aes(color = species, shape = species))+
  geom_smooth(method = "lm")+
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species"
  ) +
  scale_color_colorblind()

### Exercises
nrow(penguins)
ncol(penguins)

?penguins

ggplot(penguins,
       aes(bill_depth_mm, bill_length_mm, color=species))+
  geom_point()

ggplot(
  penguins,
  aes(species, bill_length_mm))+
  geom_boxplot()

ggplot(data = penguins, aes(species)) + 
  geom_bar()

ggplot(
  data=penguins,
  mapping=aes(x=flipper_length_mm, y=body_mass_g)
)+
  geom_point(mapping = aes(color = species, shape = species))+
  geom_smooth(method = "lm")+
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species",
    caption = "Data come from the `palmerpenguins` package."
  ) +
  scale_color_colorblind()

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(aes(color = bill_depth_mm)) +
  geom_smooth()

## ggplot2 calls
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point()

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point()

## Visualizing distribuitions
### A categorical variable
ggplot(penguins, aes(x = species)) +
  geom_bar()

ggplot(penguins, aes(x = fct_infreq(species))) +
  geom_bar()

### A numerical variable
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 20)
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 2000)

ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()

### Exercises
ggplot(penguins, aes(x = species)) +
  geom_bar(color = "red")

ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red")

## Visualizing relationships
### A numerical and a categorical variable
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()

ggplot(penguins, aes(x = body_mass_g, color = species)) +
  geom_density(linewidth = 0.75)

ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
  geom_density(alpha = 0.5)

### Two categorical variables
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar()

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")

### Two numerical variables
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

### Three or more variables
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")
ggplot(penguins, aes(x = species, fill = island)) +
  geom_bar(position = "fill")
