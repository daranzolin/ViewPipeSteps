# ViewPipeSteps

The goal of ViewPipeSteps is to help hackers debug pipe chains in a *slightly* more elegant fashion. Print/View debugging isn't sexy, but instead of manually inserting `%>% View()` after each step, spice it up a bit by highlighting the entire chain and calling the `viewPipeChain` addin:

![Alt Text](https://media.giphy.com/media/24p7Q2DkFpy5slRhOy/giphy.gif)

Alternatively, it can also serve as a more lively demonstration of the tidyverse. A possible teaching tool, perhaps.

# Installation

```
devtools::install_github("daranzolin/ViewPipeSteps")

```
# Supported Patterns

It's nigh impossible to account for everyone's idiosyncracies, but the Addin works fine if you keep to [the tidyverse style code.](http://style.tidyverse.org/pipes.html) For example, this works fine:

```
iris %>%
  group_by(Species) %>%
  summarize_if(is.numeric, mean) %>%
  ungroup() %>%
  gather(measure, value, -Species) %>%
  arrange(value)
```

As does this:

```
mtcars %>% filter(am == 1) %>% select(qsec) 

```

The Addin can also ignore comments:

```
iris_long <-
  iris %>%
  #gather this here data frame
  gather(measure, value, -Species) %>%
  arrange(-value) #sort by value descending
```

This, however, is not supported:

```
iris %>% group_by(Species) %>% summarize_if(is.numeric, mean) %>%
  ungroup() %>% gather(measure, value, -Species) %>%
  arrange(value)
```

# Future Work

* Support groups and `skimr::skim`



