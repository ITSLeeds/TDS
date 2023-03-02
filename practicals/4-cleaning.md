Data structures
================
Robin Lovelace
University of Leeds
<br/><img class="img-footer" alt="" src="https://comms.leeds.ac.uk/wp-content/themes/toolkit-wordpress-theme/img/logo.png">

## Review of homework exercise: demo then individual Q&A

``` r
library(tidyverse)
library(sf)
```

## Simple data cleaning

**Exercises** Try evaluating these lines of code, what goes wrong how
could you fix them? IS the only one “correct” solution discuss in pairs
how you would approach different types of data cleaning.

``` r
as.numeric(c("1","2.2","3,3"))
as.numeric(c("1","","3.3"))
sum(c(3,4,NA))
mean(c(3,4,NA))
max(c(3,4,NA))
d1 <- as.Date("31/11/2020")
d2 <- Sys.Date()
difftime(d2, d1)
NULL == NA
is.logical(NA)
is.null(NA)
is.na(NULL)
is.numeric("1")
is.numeric(1,2)
anyNA(c(6,2,NA))
1:3
1:1
1:0
seq_len(0)
seq_len(3)
0.1 + 0.2 - 0.3 == 0
```

## Data cleaning on a big dataset

Download the file `wu03uk_v3.zip` from the Wicid website:
[wicid.ukdataservice.ac.uk](http://wicid.ukdataservice.ac.uk/cider/wicid/downloads.php).
You should be able to read it in as follows:

``` r
unzip("~/Downloads/wu03uk_v3.zip")
d = read_csv("wu03uk_v3.csv")
```

Load data representing MSOA zones in Isle of Wight. You could download
zones from a number of places, including
<https://www.ukdataservice.ac.uk/get-data/geography.aspx>

An easy way to get zone data for West-Yorkshire is with the `pct`
package, which can be installed as follows:

The zones for Isle of Wight can be shown as follows.

``` r
zones = pct::get_pct_zones(region = "isle-of-wight", geography = "msoa")
plot(zones$geometry)
```

![](4-cleaning_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

## Processing/cleaning

-   Clean the names of the `d` object, e.g. using the following
    commands:

``` r
names(d) = snakecase::to_snake_case(names(d))
names(d)[5] = "metro"
```

-   Create a new variable called `pcycle` representing the percentage
    cycling in each OD pair

-   Create a minimal version of the dataset `d` only containing a few
    key variables

-   What proportion of people in England and Wales are represented in
    the dataset `d`

-   Create a subset of the object `d` called `d_iow_origins` that only
    contains routes that originate in Isle of Wight

-   Create a subset that contains only od pairs with origins and
    destinations in Isle of Wight

**Bonus: Convert the origin-destination data you have of Isle of Wight
into desire lines**, e.g. with:

``` r
desire_lines = stplanr::od2line(flow = d_iow_origins, zones)
desire_top = desire_lines %>% top_n(100, bicycle)
plot(desire_top)
```

``` r
mapview::mapview(desire_top)
```

## Working on your own datset / project portfolio

-   Identify, download and clean a dataset to include in your coursework
    portfolio .Rmd document

## Homework

-   Consolidate your knowledge of data cleaning by adding reproducible
    data cleaning code to your in-progress project portfolio.
