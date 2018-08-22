# ViewPipeSteps

The goal of ViewPipeSteps is to help hackers debug pipe chains in a *slightly* more elegant fashion. Print/View debugging isn't sexy, but instead of manually inserting `%>% View()` after each step, spice it up a bit by highlighting the entire chain and calling the `viewPipeChain` addin:

![Alt Text](https://media.giphy.com/media/24p7Q2DkFpy5slRhOy/giphy.gif)

Alternatively, it can also serve as a more lively demonstration of the tidyverse. A teaching tool, perhaps.

# Installation

```
devtools::install_github("daranzolin/ViewPipeSteps")

```
# Supported Patterns

Thanks to the work of Joachim Gassen, `ViewPipeSteps` now supports most piping habits and patterns. Check [tools/test_cases.R for more elaborate examples.](https://github.com/daranzolin/ViewPipeSteps/blob/master/tools/test_cases.R) 

# Future Work

* Support groups and `skimr::skim`



