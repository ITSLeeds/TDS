Routing
================
Malcolm Morgan
University of Leeds
<br/><img class="img-footer" alt="" src="https://comms.leeds.ac.uk/wp-content/themes/toolkit-wordpress-theme/img/logo.png">

## Setting Up (10 minutes)

We will use [ITS Go](https://itsleeds.github.io/go/) to do an easy setup
of your computer.

``` r
source("https://git.io/JvGjF")
```

If that does not work the packages we will be using are:

-   sf
-   tidyverse
-   tmap
-   pct
-   stplanr
-   dodgr
-   opentripplanner
-   igraph
-   ropensci/osmextract

New packages to install:

``` r
install.packages("opentripplanner")
```

``` r
library(sf)
library(tidyverse)
library(stplanr)
library(opentripplanner)
library(tmap)
tmap_mode("plot")
```

## Using OpenTripPlanner to get routes

We have setup the Multi-modal routing service OpenTripPlanner for West
Yorkshire. Try typing the URL shown during the session into your
browser. You should see somthign like this:

<div class="figure" style="text-align: center">

<img src="otp_screenshot.png" alt="\label{fig:otpgui}OTP Web GUI" width="1920" />
<p class="caption">
OTP Web GUI
</p>

</div>

**Exercise**: Play with the web interface, finding different types of
routes. What strengths/limitations can you find?

### Connecting to OpenTripPlanner

To allow R to connect to the OpenTripPlanner server, we will use the
`opentripplanner` package and the function `otp_connect`. In this
example I have saved the hostname of the server as a variable called
“robinIP” in my Renviron file by using `usethis::edit_r_environ()`.

However, you can also just set it manually.

``` r
# ip = "localhost" # to run it on your computer (see final bonus exercise)
ip = "otp.saferactive.org" # an actual server
otpcon = otp_connect(hostname = ip, 
                     port = 80,
                     router = "west-yorkshire")
```

If you have connected successfully, then you should get a message
“Router exists.”

To get some routes, we will start by importing some data we have used
previously. Note that the data frame has 78 columns (only a few of which
are useful) and 1k rows:

``` r
u = "https://github.com/ITSLeeds/TDS/releases/download/0.1/desire_lines.geojson"
desire_lines = read_sf(u)
dim(desire_lines)
```

    ## [1] 1000   78

**Exercise** Subset the and overwrite the `desire_lines` data frame with
the `=` assignment operator so that it only has the following columns:
geo\_code1, geo\_code2, all, bicycle, foot, car\_driver, and geometry.
You can test the that the operation worked by executing the object name,
the result should look like that shown below.

    ## Simple feature collection with 1000 features and 6 fields
    ## geometry type:  LINESTRING
    ## dimension:      XY
    ## bbox:           xmin: -2.104536 ymin: 53.5695 xmax: -1.153171 ymax: 54.00022
    ## geographic CRS: WGS 84
    ## # A tibble: 1,000 x 7
    ##    geo_code1 geo_code2   all bicycle  foot car_driver                   geometry
    ##    <chr>     <chr>     <int>   <int> <int>      <int>           <LINESTRING [°]>
    ##  1 E02002183 E02002184   537       8   137        317 (-1.880148 53.94245, -1.8…
    ##  2 E02002183 E02002186   176       1     3        143 (-1.880148 53.94245, -1.9…
    ##  3 E02002184 E02002185   325       4     6        217 (-1.81851 53.92598, -1.75…
    ##  4 E02002184 E02002186   334       1     5        256 (-1.81851 53.92598, -1.94…
    ##  5 E02002184 E02002187   159       1     7        113 (-1.81851 53.92598, -1.74…
    ##  6 E02002184 E02002333   191       2     3        139 (-1.81851 53.92598, -1.69…
    ##  7 E02002186 E02002188   259       6     5        204 (-1.941534 53.91154, -1.8…
    ##  8 E02002186 E02002189   233       4    10        155 (-1.941534 53.91154, -1.9…
    ##  9 E02002186 E02002190   714       7    19        478 (-1.941534 53.91154, -1.9…
    ## 10 E02002186 E02002191   341       1    12        188 (-1.941534 53.91154, -1.9…
    ## # … with 990 more rows

This dataset has desire lines, but most routing packages need start and
endpoints, so we will extract the points from the lines using the
`line2df` function. An then select the top 3 desire lines.

**Exercises** 1. Use the `tmap` package to plot the `desire_lines`.
Choose different ways to visualise the data so you can understand local
commuter travel patterns. 1. Produce a data frame called `desire` which
contains the coordinates of the start and endpoints of the lines in
`desire_lines` but not the geometries. 1. Subset out the top three
desire lines by the total number of commuters and create a new data
frame called `desire_top` 1. Find the driving routes for `desire_top`
and call them `routes_top` using `otp_plan`

``` r
qtm(desire_lines)
```

![](6-routing_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

``` r
tm_shape(desire_lines) +
  tm_lines(lwd = "all", col = "car_driver", scale = 4, palette = "viridis")
```

![](6-routing_files/figure-gfm/unnamed-chunk-12-2.png)<!-- -->

To find the routes for the first three desire lines use the following
command:

``` r
desire_top = top_n(desire_lines, 3, all)
routes_top = route(
  l = desire_top,
  route_fun = otp_plan,
  mode = "CAR",
  otpcon = otpcon
  )
```

We can plot those routes using the `tmap` package, the result should
appear as follows (if you set `tmap_mode("view")`)

![](6-routing_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

We can also get Isochones from OTP.

``` r
isochrone = otp_isochrone(otpcon, fromPlace = c(-1.558655, 53.807870), 
                          mode = c("BICYCLE","TRANSIT"),
                          maxWalkDistance = 3000)
isochrone$time = isochrone$time / 60
tm_shape(isochrone) +
  tm_fill("time", alpha = 0.6)
```

![](6-routing_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

To save overloading the server, I have pre-generated some extra routes.

``` r
u = "https://github.com/ITSLeeds/TDS/releases/download/0.20.1/transit_routes.gpkg"
download.file(url = u, destfile = "transit_routes.gpkg", mode = "wb")
u = "https://github.com/ITSLeeds/TDS/releases/download/0.20.1/driving_routes.gpkg"
download.file(url = u, destfile = "driving_routes.gpkg", mode = "wb")

routes_drive = read_sf("driving_routes.gpkg")
routes_transit = read_sf("transit_routes.gpkg")
```

**Exercise** Examine these two new datasets `routes_drive` and
`routes_transit` plot them on a map, what useful information do they
contain what is missing?

Note that some of the desire lines do not have a route. This is usually
because the start or endpoint is too far from the road.

**Exercise** How many routes are missing for each mode? How could you
improve this method, so there were no missing routes?

## Line Merging

Notice that `routes_transit` has returned separate rows for each mode
(WALK, RAIL). Notice the `route_option` column shows that some routes
have multiple options.

Let’s suppose you want a single line for each route.

**Exercise**: Filter the `routes_transit` to contain only one route
option per origin-destination pair. **Bonus Exercise**: Do the above,
but make sure you always select the fastest option.

Now We will group the separate parts of the routes together.

``` r
routes_transit_group = routes_transit %>%
  dplyr::group_by(fromPlace, toPlace) %>%
  dplyr::summarise(duration = sum(duration),
                   startTime = min(startTime),
                   endTime = max(endTime),
                   distance = sum(distance))
```

We now have a single row, but instead of a `LINESTRING`, we now have a
mix of `MULTILINESTRING` and `LINESTRING`, we can convert to a
linestring by using `st_line_merge()`. Note how the different columns
where summarised.

First, we must separate out the `MULTILINESTRING` and `LINESTRING`

``` r
routes_transit_group_ml = routes_transit_group[st_geometry_type(routes_transit_group) == "MULTILINESTRING", ]
routes_transit_group = routes_transit_group[st_geometry_type(routes_transit_group) != "MULTILINESTRING", ]
routes_transit_group_ml = st_line_merge(routes_transit_group_ml)
routes_transit_group = rbind(routes_transit_group, routes_transit_group_ml)
```

## Network Analysis (dodgr) (20 minutes)

**Note** Some people have have problems running dodgr on Windows, if you
do follow these
[instructions](https://github.com/ITSLeeds/TDS/blob/master/practicals/dodgr-install.md).

We will now look to analyse the road network using `dodgr`. First let’s
find the distances between all our centroids for a cyclist.
`dodgr_dists` returns a matrix of distances in km, note the speed of
using dodgr to find 64 distances compared to using a routing service.
`dodgr` works well for these type of calculation, but cannot do public
transport timetables.

``` r
library(osmextract)
library(dodgr)
library(igraph)
roads = oe_get("isle-of-wight", extra_tags = c("maxspeed","oneway"))
```

    ## Reading layer `lines' from data source `/mnt/57982e2a-2874-4246-a6fe-115c199bc6bd/data/osm/geofabrik_isle-of-wight-latest.gpkg' using driver `GPKG'
    ## Simple feature collection with 44424 features and 11 fields
    ## geometry type:  LINESTRING
    ## dimension:      XY
    ## bbox:           xmin: -5.401978 ymin: 43.35489 xmax: -0.175775 ymax: 50.89599
    ## geographic CRS: WGS 84

``` r
roads = roads[!is.na(roads$highway),]
road_types = c("residential","secondary","tertiary",
                        "unclassified","primary","primary_link",
                        "secondary_link","tertiary_link")
roads = roads[roads$highway %in% road_types, ]
graph = weight_streetnet(roads)
```

<!-- **Exercise**: Reproduce the Isle of Wight flow data `d_iow_origins` that you used in the Data Cleaning Practical -->

We will find the betweeness centrality of the Isle of Wight road
network. THis can take a long time, so first lets check how long it will
take.

``` r
estimate_centrality_time(graph)
```

    ## Estimated time to calculate centrality for full graph is 00:00:04

``` r
centrality = dodgr_centrality(graph)


clear_dodgr_cache()

centrality_sf = dodgr_to_sf(centrality)
tm_shape(centrality_sf) +
  tm_lines("centrality",
           lwd = 3,
           n = 8,
           style = "fisher",
           palette = "-viridis")
```

![](6-routing_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

**Exercise**: Use `dodgr_contract_graph` before calculating centrality,
how does this affect the computation time and the results?

**Bonus Exercises** 1. Work though the OpenTripPlanner vignettes
[Getting
Started](https://docs.ropensci.org/opentripplanner/articles/opentripplanner.html)
and [Advanced
Features](https://docs.ropensci.org/opentripplanner/articles/advanced_features.html)
to run your own local trip planner.
