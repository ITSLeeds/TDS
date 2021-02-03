Software for transport data science
================
Robin Lovelace
University of Leeds,
2021-02-03<br/><img class="img-footer" alt="" src="http://www.stephanehess.me.uk/images/picture3.png">

## Agenda

-   Introduction to the module and team - 30 min
    <!-- Each person to say  1) their name and where they are based 2) why they took the module and 3) their level of knowledge of coding. -->

-   Live demo: getting set-up with RStudio - 25 minutes

-   5 minute break

-   Working together - Visualising transport data in the stplanr
    package - 30 minutes

-   Working alone - running the code in Sections 12.1 to 12.4 the
    Transport chapter of Geocomputation with R and answering the
    questions for the Bristol dataset - 1 hr

-   Bonus: Work through [Chapter
    5](https://r4ds.had.co.nz/transform.html#filter-rows-with-filter) of
    R for Data Science

## Pre-requisites

You need to have a number of packages installed and loaded. Install the
packages by typing in the following commands into RStudio (you do not
need to add the comments after the `#` symbol):[1]

``` r
install.packages("remotes")
pkgs = c(
  "nycflights13",# data package
  "pct",         # package for getting travel data in the UK
  "sf",          # spatial data package
  "stats19",     # downloads and formats open stats19 crash data
  "stplanr",     # for working with origin-destination and route data
  "tidyverse",   # a package for user friendly data science
  "tmap"         # for making maps
)
remotes::install_cran(pkgs)
remotes::install_github("nowosad/spDataLarge")
```

Load the tidyverse package as follows:

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──

    ## ✔ ggplot2 3.3.3     ✔ purrr   0.3.4
    ## ✔ tibble  3.0.6     ✔ dplyr   1.0.3
    ## ✔ tidyr   1.1.2     ✔ stringr 1.4.0
    ## ✔ readr   1.4.0     ✔ forcats 0.5.1

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

## Project set-up and tidyverse testing (30 minutes)

-   Check your packages are up-to-date with `update.packages()`
-   Create an RStudio project with an appropriate name for this module
    (e.g. `TDSmodule`)
-   Create appropriate files for code, data and anything else
    (e.g. images)
-   Create a script called `learning-tidyverse.R`, e.g. with the
    following command:

``` r
dir.create("code") # 
file.edit("code/learning-tidyverse.R")
```

## Getting started with transport data

We’re going to start by looking at the main types of transport data:[2]

In this section we will look at basic transport data in the R package
**stplanr**.

Attach the `tidyverse`, `stplanr` and `sf` packages as follows:

``` r
library(tidyverse)
library(stplanr)
library(sf)
```

    ## Linking to GEOS 3.8.0, GDAL 3.0.4, PROJ 7.0.0

The `stplanr` package contains some data that we can use to demonstrate
principles in Data Science, illustrated in the Figure below. Source:
Chapter 1 of R for Data Science (Grolemund and Wickham 2016) [available
online](https://r4ds.had.co.nz/introduction.html).

![](https://d33wubrfki0l68.cloudfront.net/571b056757d68e6df81a3e3853f54d3c76ad6efc/32d37/diagrams/data-science.png)

``` r
# import
od_data = stplanr::od_data_sample
```

``` r
# tidy
od_data = od_data %>%
  rename(walk = foot)
```

``` r
# transform
od_data_walk = od_data %>% 
  filter(walk > 0) %>% 
  select(geo_code1, geo_code2, all, car_driver, walk) %>% 
  mutate(proportion_walk = walk / all, proportion_drive = car_driver / all)
```

``` r
# visualise
plot(od_data_walk)
```

![](2-software_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

``` r
# model
model1 = lm(proportion_walk ~ proportion_drive, data = od_data_walk)
od_data_walk$proportion_walk_predicted = model1$fitted.values
```

``` r
# visualise
ggplot(od_data_walk) +
  geom_point(aes(proportion_drive, proportion_walk)) +
  geom_line(aes(proportion_drive, proportion_walk_predicted))
```

![](2-software_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

``` r
# transform
# ...
```

Exercises

1.  What is the class of the data in `od_data`?
2.  Subset (filter) the data to only include OD pairs in which at least
    one person (`> 0`) person walks (bonus: on what % of the OD pairs
    does at least 1 person walk?)
3.  Calculate the percentage who cycle in each OD pair in which at least
    1 person cycles
4.  Is there a positive relationship between walking and cycling in the
    data?
5.  Plot the zones representing the `geo_code` variables in the OD data
6.  Bonus: use the function `od2line()` in to convert the OD dataset
    into geographic desire lines

## Processing origin-destination data in Bristol

This section is based on Chapter 12 of Geocomputation with R:
<https://geocompr.robinlovelace.net/transport.html>

The task is to reproduce the results shown in that chapter on your own
computer. Some code to get started on a subset of the data is shown
below.

Start with a medium-sized dataset:

``` r
# import
od = spDataLarge::bristol_od
head(od)
```

    ## # A tibble: 6 x 7
    ##   o         d           all bicycle  foot car_driver train
    ##   <chr>     <chr>     <dbl>   <dbl> <dbl>      <dbl> <dbl>
    ## 1 E02002985 E02002985   209       5   127         59     0
    ## 2 E02002985 E02002987   121       7    35         62     0
    ## 3 E02002985 E02003036    32       2     1         10     1
    ## 4 E02002985 E02003043   141       1     2         56    17
    ## 5 E02002985 E02003049    56       2     4         36     0
    ## 6 E02002985 E02003054    42       4     0         21     0

``` r
# tidy
zones = spDataLarge::bristol_zones
zones = zones %>% 
  mutate(local_authority = word(string = name, 1))
plot(zones %>% select(local_authority), key.pos = 1)
```

![](2-software_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

``` r
# transform
bristol_sf = tmaptools::geocode_OSM("bristol", as.sf = TRUE, return.first.only = T, geometry = "point")
mapview::mapview(bristol_sf)
```

![](2-software_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

``` r
bristol_buffer_10km = geo_buffer(bristol_sf, dist = 10000)
zones_central = zones[bristol_buffer_10km, , op = sf::st_within]
```

    ## although coordinates are longitude/latitude, st_within assumes that they are planar

``` r
# visualise
mapview::mapview(zones_central)
```

![](2-software_files/figure-gfm/unnamed-chunk-20-2.png)<!-- -->

``` r
# transform
od_central = od %>%
  filter(o %in% zones_central$geo_code) %>% 
  filter(d %in% zones_central$geo_code) 
nrow(od_central) / nrow(od)
```

    ## [1] 0.5140893

``` r
desire_lines = od2line(od_central, zones_central)
```

    ## Creating centroids representing desire line start and end points.

``` r
desire_lines$distance_direct_m = as.numeric(st_length(desire_lines))
desire_lines = desire_lines %>% 
  mutate(proportion_active = (bicycle + foot) / all)
```

``` r
# visualise
ggplot(desire_lines) +
  geom_point(aes(distance_direct_m, proportion_active))
ggplot(desire_lines) +
  geom_point(aes(distance_direct_m, proportion_active, size = all), alpha = 0.3)
```

<img src="2-software_files/figure-gfm/unnamed-chunk-22-1.png" width="40%" /><img src="2-software_files/figure-gfm/unnamed-chunk-22-2.png" width="40%" />

``` r
# model/visualise
m1 = lm(proportion_active ~ 
          distance_direct_m + I(distance_direct_m^2),
        data = desire_lines)
desire_lines = desire_lines %>% 
  mutate(
    new_active_travel = m1$fitted.values * car_driver,
    new_total_active = new_active_travel + bicycle + foot,
    new_proportion_active = new_total_active / all
    ) %>% 
  arrange(proportion_active)
ggplot(desire_lines) +
  geom_point(aes(distance_direct_m, proportion_active, size = all), alpha = 0.3) +
  geom_point(aes(distance_direct_m, new_proportion_active, size = all), alpha = 0.3, colour = "blue")
```

![](2-software_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

``` r
# visualise
ggplot(desire_lines) +
  geom_sf(aes(colour = new_proportion_active, alpha = all))
```

![](2-software_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

``` r
library(tmap)
tm_shape(desire_lines) +
  tm_lines(palette = "-viridis", breaks = c(0, 5, 10, 20, 40, 100) / 100,
    lwd = "all",
    scale = 9,
    title.lwd = "Number of trips",
    alpha = 0.6,
    col = c("proportion_active", "new_proportion_active"),
    title = "Active travel (%)"
  ) +
  tm_scale_bar()
```

    ## Legend labels were too wide. Therefore, legend.text.size has been set to 0.46. Increase legend.width (argument of tm_layout) to make the legend wider and therefore the labels larger.
    ## Legend labels were too wide. Therefore, legend.text.size has been set to 0.46. Increase legend.width (argument of tm_layout) to make the legend wider and therefore the labels larger.

![](2-software_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

## Reading-in and processing basic data

Read-in coffee data:

``` r
u = paste0(
  "https://github.com/ITSLeeds/TDS/",
  "raw/master/sample-data/everyone.csv"
  )
d = read_csv(u)
```

    ## 
    ## ── Column specification ────────────────────────────────────────────────────────
    ## cols(
    ##   person_name = col_character(),
    ##   n_coffee = col_double(),
    ##   like_bus_travel = col_logical()
    ## )

Create a new variable called ‘n\_coffee\_yr’ with the following command:

``` r
d$n_coffee_yr = d$n_coffee * 52
```

Find the mean number of cups of coffee people drink per year (and the
total)

Note: the same result can be achieved as follows:

``` r
d_updated = mutate(d, n_coffee_yr = n_coffee * 52)

# or 
d_updated = d %>% 
  mutate(n_coffee_yr = n_coffee * 52)
```

-   Which do you prefer?

-   Filter-out only those who travel by bus

-   Bonus: Create a new dataset that keeps only the `person_name` and
    `n_coffee_yr` variables (hint: use the `select()` function)

-   Bonus: do those who travel by bus drink more or less coffee than
    those who do not?

## Processing medium sized data and basic visualisation (30 minutes)

This section will use content from Chapter 5 of the R for Data Science
book (**grolemund\_data\_2016?**).

-   Read [section
    5.1](https://r4ds.had.co.nz/transform.html#filter-rows-with-filter)
    of R for Data Science and write code that reproduces the results in
    that section in the script `learning-tidyverse.R`

Your script will start with something like this:

``` r
library(tidyverse)
library(nycflights13)
```

-   Take a random sample of 10,000 flights and assign it to an object
    with the following line of code:

``` r
library(nycflights13)
flights_sample = sample_n(flights, 1e4)
unique(flights$carrier)
```

    ##  [1] "UA" "AA" "B6" "DL" "EV" "MQ" "US" "WN" "VX" "FL" "AS" "9E" "F9" "HA" "YV"
    ## [16] "OO"

-   Find the unique carriers with the `unique()` function

-   Create an object containing flights from United, American, or Delta,
    and assign it to `f`, as follows:

``` r
f = filter(flights, grepl(pattern = "UA|AA|DL", x = carrier))
f2 = filter(flights, grepl(pattern = "UA", x = carrier) |
             grepl(pattern = "AA", x = carrier) |
             grepl(pattern = "DL", x = carrier)
           )
f3 = filter(flights, str_detect(carrier, "UA|AA|DL"))
```

-   Create plots that visualise the sample flights, using code from
    Chapter 3 of the same book, starting with the following plot:

``` r
ggplot(f) +
  geom_point(aes(air_time, distance))
```

![](2-software_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->

-   Add transparency so it looks like this (hint: use `alpha =` in the
    `geom_point()` function call):

<!-- -->

    ## Warning: Removed 2117 rows containing missing values (geom_point).

![](2-software_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->

-   Add a colour for each carrier, so it looks something like this:

``` r
ggplot(f) +
  geom_point(aes(air_time, distance, colour = carrier), alpha = 0.5)
```

    ## Warning: Removed 2117 rows containing missing values (geom_point).

![](2-software_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->

-   Bonus 1: find the average air time of those flights with a distance
    of 1000 to 2000 miles

-   Bonus 2: use the `lm()` function to find the relationship between
    flight distance and time, and plot the results (start the plot as
    follows, why did we use `na.omit()`? hint - find help with
    `?na.omit()`):

``` r
f = na.omit(f)
m = lm(air_time ~ distance, data = f)
f$pred = m$fitted.values
```

![](2-software_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->

## Homework

1.  create a reproducible document

-   Create an Rmarkdown file with the following command:

``` r
file.edit("learning-tidyverse.Rmd")
```

-   Take a read of the guidance on RMarkdown files online and in the
    following location (or search online for the ‘RMarkdown
    cheatsheet’):

<!-- -->

    Help > Cheatsheets > RMarkdown

-   Put the code you generated for `tidyverse.R` into the Rmd file and
    knit it

-   Bonus: create a GitHub repo and publish the results of of your work
    (hint: putting `output: github_document` may help here!)

2.  Work-through the remaining exercises of the first sections in R4DS
    chapters 3 and 5

-   Write and R script, with comments, to show your working (and prove
    you’ve done it!)

3.  Create an RMarkdown file containing reproducible code outlining what
    you learned today

4.  Identify a dataset you would like to work with for the practical
    next week.

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-grolemund_r_2016" class="csl-entry">

Grolemund, Garrett, and Hadley Wickham. 2016. *R for Data Science*.
O’Reilly Media.

</div>

</div>

[1]  Note: if you want to install the development version of a package
from GitHub, you can do so. Try, for example, running the following
command: `remotes::install_github("ITSLeeds/pct")`

[2]  Note: if you want to get zone data for a different region you can
do so, e.g. with:
`zones = sf::read_sf("https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/west-yorkshire/z.geojson")`
