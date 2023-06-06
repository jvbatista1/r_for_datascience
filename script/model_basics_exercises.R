# Model basics
## Introduction
### Prerequisistes

library(tidyverse)

library(modelr)
options(na.action = na.warn)

## A simple model
ggplot(sim1, aes(x,y))+
  geom_point()

models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)

ggplot(sim1, aes(x,y))+
  geom_abline(aes(intercept = a1, slope = a2), data = models, alpha = 1/4)+
  geom_point()

model1 <- function(a, data){
  a[1] + data$x*a[2]
}

model1(c(7,1.5), sim1)

measure_distance <- function(mod, data){
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff^2))
}
measure_distance(c(7,1.5), sim1)

sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}

models <- models %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
models

ggplot(sim1, aes(x,y))+
  geom_point(size = 2, colour = "grey30")+
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist),
    data = filter(models, rank(dist)<=10)
  )

ggplot(models, aes(a1, a2))+
  geom_point(data = filter(models, rank(dist)<=10), size = 4, colour = "red")+
  geom_point(aes(colour = -dist))

grid <- expand.grid(
  a1 = seq(-5, 20, length = 25),
  a2 = seq(1, 3, length = 25)
) %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

grid %>% 
  ggplot(aes(a1, a2)) +
  geom_point(data = filter(grid, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist)) 

ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist), 
    data = filter(grid, rank(dist) <= 10)
  )

best <- optim(c(0, 0), measure_distance, data = sim1)
best$par

ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(intercept = best$par[1], slope = best$par[2])

sim1_mod <- lm(y~x, data=sim1)
coef(sim1_mod)

### Exercises
### 1. One downside of the linear model is that it is sensitive to unusual
### values because the distance incorporates a squared term. Fit a linear model
### to the simulated data below, and visualise the results. Rerun a few times to
### generate different simulated datasets. What do you notice about the model?
  
  sim1a <- tibble(
    x = rep(1:10, each = 3),
    y = x * 1.5 + 6 + rt(length(x), df = 2)
  )
### 2. One way to make linear models more robust is to use a different distance
### measure. For example, instead of root-mean-squared distance, you could use
### mean-absolute distance:
  
  measure_distance <- function(mod, data) {
    diff <- data$y - model1(mod, data)
    mean(abs(diff))
  }
### Use optim() to fit this model to the simulated data above and compare it to
### the linear model.

### 3. One challenge with performing numerical optimisation is that it’s only 
### guaranteed to find one local optimum. What’s the problem with optimising a 
### three parameter model like this?
  
  model1 <- function(a, data) {
    a[1] + data$x * a[2] + a[3]
  }
  
## Visualising models
### Predictions
grid <- sim1 %>% 
  data_grid(x)
grid

grid <- grid %>% 
  add_predictions(sim1_mod)
grid

ggplot(sim1, aes(x))+
  geom_point(aes(y=y))+
  geom_line(aes(y=pred), data=grid, colour="red", size=1)

### Residuals
sim1 <- sim1 %>% 
  add_residuals(sim1_mod)

ggplot(sim1, aes(resid))+
  geom_freqpoly(binwidth = 0.5)

ggplot(sim1, aes(x, resid))+
  geom_ref_line(h = 0)+
  geom_point()

### Exercises
### 1. Instead of using lm() to fit a straight line, you can use loess() to fit
### a smooth curve. Repeat the process of model fitting, grid generation,
### predictions, and visualisation on sim1 using loess() instead of lm(). How
### does the result compare to geom_smooth()?
  
### 2. add_predictions() is paired with gather_predictions() and
### spread_predictions(). How do these three functions differ?
  
### 3. What does geom_ref_line() do? What package does it come from? Why is
### displaying a reference line in plots showing residuals useful and important?
  
### 4. Why might you want to look at a frequency polygon of absolute residuals?
### What are the pros and cons compared to looking at the raw residuals?

## Formulas and model families
df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)
model_matrix(df, y ~ x1)

model_matrix(df, y ~ x1 - 1)

model_matrix(df, y ~ x1 + x2)

### Categorical variables
df <- tribble(
  ~sex, ~response,
  "male", 1,
  "female", 2,
  "male", 1,
)
model_matrix(df, response~sex)

ggplot(sim2)+
  geom_point(aes(x,y))

mod2 <- lm(y~x, data=sim2)

grid <- sim2 %>% 
  data_grid(x) %>% 
  add_predictions(mod2)
grid

ggplot(sim2, aes(x))+
  geom_point(aes(y=y))+
  geom_point(data=grid, aes(y=pred), colour = 'red', size = 4)

tibble(x = "e") %>% 
  add_predictions(mod2)

### Interactions (continuous and categorical)
ggplot(sim3, aes(x1, y))+
  geom_point(aes(colour = x2))

mod1 <-  lm(y~x1+x2, data = sim3)
mod2 <-  lm(y~x1*x2, data = sim3)

grid <- sim3 %>% 
  data_grid(x1, x2) %>% 
  spread_predictions(mod1, mod2)
grid

grid <- sim3 %>% 
  data_grid(x1, x2) %>% 
  gather_predictions(mod1, mod2)
grid

ggplot(sim3, aes(x1, y, colour = x2))+
  geom_point()+
  geom_line(data=grid, aes(y=pred))+
  facet_wrap(~model)

sim3 <- sim3 %>% 
  gather_residuals(mod1, mod2)

ggplot(sim3, aes(x1, resid, colour = x2))+
  geom_point()+
  facet_grid(model~x2)

### Interactions (two continuous)
mod1 <-  lm(y~x1+x2, data = sim4)
mod2 <-  lm(y~x1*x2, data = sim4)

grid <- sim4 %>% 
  data_grid(
    x1=seq_range(x1,5),
    x2=seq_range(x2,5)
  ) %>% 
  gather_predictions(mod1, mod2)
grid

seq_range(c(0.0123, 0.923423), n = 5)
seq_range(c(0.0123, 0.923423), n = 5, pretty = TRUE)

x1 <- rcauchy(100)
seq_range(x1, n = 5)
seq_range(x1, n = 5, trim = 0.10)
seq_range(x1, n = 5, trim = 0.25)
seq_range(x1, n = 5, trim = 0.50)

x2 <- c(0, 1)
seq_range(x2, n = 5)
seq_range(x2, n = 5, expand = 0.10)
seq_range(x2, n = 5, expand = 0.25)
seq_range(x2, n = 5, expand = 0.50)

ggplot(grid, aes(x1, x2)) + 
  geom_tile(aes(fill = pred)) + 
  facet_wrap(~ model)

ggplot(grid, aes(x1, pred, colour=x2, group=x2))+
  geom_line()+
  facet_wrap(~model)
ggplot(grid, aes(x2, pred, colour=x1, group=x1))+
  geom_line()+
  facet_wrap(~model)
