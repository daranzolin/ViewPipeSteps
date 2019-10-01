# Needed for some examples
library(tidyverse)

# Garabage (should throw parsing error)
This is no valid R code.

# Valid expression that contains no call (should throw error)
variable

#Call that contains no assignment or pipe (should throw error)
sleep(1000)

#Call containing assignment but no RHS call (should throw error)
y <- 42

#Call containing assignment but no pipe (should throw error)
y <- 6 * 7

#Simple pipe
mtcars %>% filter(am == 1)

# One line pipe
mtcars %>% filter(am == 1) %>% select(qsec)

# One line pipe with assignment
mtcars %>% filter(am == 1) %>% select(qsec) -> result

# Multiple line pipe with end assignment
mtcars %>%
  filter(am == 1) %>%
  select(qsec) -> result

# Multiple line pipe with comments and normal assignment
iris_long <-
  iris %>%
  #gather this here data frame
  gather(measure, value, -Species) %>%
  arrange(-value) #sort by value descending

# Mix of one line and multiple line pipe
iris %>% group_by(Species) %>% summarize_if(is.numeric, mean) %>%
  ungroup() %>% gather(measure, value, -Species) %>%
  arrange(value)

# Pipe with command spanning multiple lines
iris %>%
  group_by(Species) %>%
  summarise(Sepal.Length.min = min(Sepal.Length),
            Sepal.Width.min = min(Sepal.Width),
            Petal.Length.min = min(Petal.Length),
            Petal.Width.min = min(Petal.Width)) -> min_iris

# Example from issue #14

diamonds %>%
  select(carat, cut, color, clarity, price) %>%
  group_by(color) %>%
  summarise(n = n(), price = mean(price)) %>%
  arrange(desc(color))

# Assign with pipe (esoteric, works)
assign("result", mtcars %>% filter(am == 1) %>% select(qsec))

# do.call with pipe (too esoteric, throws an error)
do.call("%>%", list(quote(mtcars), quote(filter(am == 1))))
