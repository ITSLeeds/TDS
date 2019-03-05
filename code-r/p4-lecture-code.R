import networkx as nx
quit()
xaringan::inf_mr("slides/2-software.Rmd")
reticulate::repl_python()
xaringan::inf_mr("slides/2-software.Rmd")
# net = dodgr::dodgr_streetnet("bangor")
library(osmdata)
net = opq("bangor") %>%
add_osm_feature("highway")
plot(net)
net = opq("bangor") %>%
add_osm_feature("highway") %>%
osmdata_sf()
net = opq("bangor") %>%
add_osm_feature("highway") %>%
osmdata_sf()
plot(net$osm_lines)
library(sf)
plot(net$osm_lines)
plot(net$osm_lines$geometry)
slow_roads = net$osm_lines[net$osm_lines$maxspeed < 40, ]
net$osm_lines$maxspeed < 40
net$osm_lines$maxspeed
slow_roads = net$osm_lines[net$osm_lines$maxspeed == "30 mph", ]
sel_30 = as.character(net$osm_lines$maxspeed) == "30 mph"
summary(sel_30)
sel_30 = as.character(net$osm_lines$maxspeed) == "60 mph"
summary(sel_30)
fast_roads = net$osm_lines[sel_30, ]
summary(sel_30)
sel_speed = !is.na(net$osm_lines$maxspeed)
summary(sel_speed)
fast_roads = net$osm_lines[sel_spee, ]
fast_roads = net$osm_lines[sel_speed, ]
mapview::mapview(fast_roads)
vignette("stplanr-paper")
m = mapview::mapview(fast_roads)
m@map
citr:::insert_citation()
citr:::insert_citation()
citr::tidy_bib_file(rmd_file = "slides/2-software.Rmd", messy_bibliography = "~/allrefs.bib", file = "references.bib")
file.edit("code-r/p1.R")
u = "/mnt/27bfad9a-3474-4e61-9a43-0156ebc67d67/home/robin/npct/pct-outputs-regional-R/commute/msoa/greater-manchester/l.Rds"
desire_lines = readRDS(u)
x = 1:9
y = sqrt(x)
m = cbind(x, y)
plot(m)
# roads in Leeds
library(osmdata)
# roads_leeds = opq("leeds") %>%
#   add_osm_feature("highway") %>%
#   osmdata_sf()
# cycleway_leeds = opq("leeds") %>%
#   add_osm_feature("highway", "cycleway") %>%
#   osmdata_sf()
library(sf)
cw = cycleway_leeds$osm_lines
plot(cw)
desire_lines = sf::st_as_sf(desire_lines)
desire_lines_1000 = desire_lines %>%
top_n(1000, all)
# u = "/mnt/27bfad9a-3474-4e61-9a43-0156ebc67d67/home/robin/npct/pct-outputs-regional-R/commute/msoa/greater-manchester/l.Rds"
# desire_lines = readRDS(u)
# desire_lines = sf::st_as_sf(desire_lines)
library(dplyr)
library(sf)
desire_lines_1000 = desire_lines %>%
top_n(1000, all)
file.edit("slides/1-intro.Rmd")
car_dependent_routes = desire_lines %>%
mutate(percent_drive = car_driver / all * 100) %>%
filter(rf_dist_km < 3 & rf_dist_km > 1)
library(tmap)
ttm()
car_dependent_routes = desire_lines_1000 %>%
mutate(percent_drive = car_driver / all * 100) %>%
filter(rf_dist_km < 3 & rf_dist_km > 1)
b = c(0, 25, 50, 75)
tm_shape(car_dependent_routes) +
tm_lines(col = "percent_drive", lwd = "all", scale = 5, breaks = b, palette = "-inferno")
u = "https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/greater-manchester/l.geojson"
desire_lines_all = read_sf(u)
desire_lines_1000 = desire_lines %>%
top_n(1000, all)
plot(desire_lines_1000$geometry)
car_dependent_routes = desire_lines_1000 %>%
mutate(percent_drive = car_driver / all * 100) %>%
filter(rf_dist_km < 3 & rf_dist_km > 1)
b = c(0, 25, 50, 75)
tm_shape(car_dependent_routes) +
tm_lines(col = "percent_drive", lwd = "all", scale = 5, breaks = b, palette = "-inferno")
library(sf)
library(tmap)
library(dplyr)
region = "west-yorkshire"
u = paste0(
"https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/",
region,
"/l.geojson"
)
desire_lines = read_sf(u)
desire_lines_1000 = desire_lines %>%
top_n(1000, all)
plot(desire_lines_1000$geometry)
car_dependent_routes = desire_lines_1000 %>%
mutate(percent_drive = car_driver / all * 100) %>%
filter(rf_dist_km < 3 & rf_dist_km > 1)
b = c(0, 25, 50, 75)
tm_shape(car_dependent_routes) +
tm_lines(col = "percent_drive", lwd = "all", scale = 5, breaks = b, palette = "-inferno")
sum(desire_lines_1000$car_driver)
file.copy("practicals/1-intro.Rmd", "practicals/2-software.Rmd")
file.edit("practicals/2-software.Rmd")
library(tidyverse)
library(nycflights13)
ggplot(flights) +
geom_line(aes(air_time, distances))
ggplot(flights) +
geom_line(aes(air_time, distance))
ggplot(flights) +
geom_point(aes(air_time, distance))
ggplot(sample_n(flights, 1e4)) +
geom_point(aes(air_time, distance))
f = sample_n(flights, 1e4)
ggplot(f) +
geom_point(aes(air_time, distance))
ggplot(f) +
geom_point(aes(air_time, distance), alpha = 0.2)
ggplot(f) +
geom_point(aes(air_time, distance), alpha = 0.9)
ggplot(f) +
geom_point(aes(air_time, distance), alpha = 0.1)
ggplot(f) +
geom_point(aes(air_time, distance, colour = f$carrier), alpha = 0.1)
m = lm(air_time ~ distance, data = f)
f$pred = m$fitted.values
ggplot(f) +
geom_point(aes(air_time, distance, colour = carrier), alpha = 0.5)
flights
f = filter(flights, flights$carrier == "UA" | "AA" | "DL")
View(flights)
f = filter(flights, grepl(pattern = "UA|AA|DL", x = .))
f = filter(flights, grepl(pattern = "UA|AA|DL", x = carrier))
ggplot(f) +
geom_point(aes(air_time, distance))
ggplot(f) +
geom_point(aes(air_time, distance, colour = carrier), alpha = 0.5)
m = lm(air_time ~ distance, data = f)
f$pred = m$fitted.values
ggplot(f) +
geom_point(aes(air_time, distance, colour = carrier), alpha = 0.5) +
geom_line(aes(pred, distance))
f$pred = m$fitted.values
m = lm(air_time ~ distance, data = f)
f$pred = m$fitted.values
m = lm(air_time ~ distance, data = f)
f$pred = m$fitted.values
m = lm(air_time ~ distance, data = f, na.action = NULL)
f = na.omit(f)
m = lm(air_time ~ distance, data = f)
f$pred = m$fitted.values
ggplot(f) +
geom_point(aes(air_time, distance, colour = carrier), alpha = 0.5) +
geom_line(aes(pred, distance))
u = paste0(
"https://github.com/ITSLeeds/TDS/",
"blob/master/sample-data/everyone.csv"
)
u = paste0(
"https://github.com/ITSLeeds/TDS/",
"raw/master/sample-data/everyone.csv"
)
d = read_csv(u)
d$n_coffee_yr = d$n_coffee * 52
d = mutate(d, n_coffee_yr = n_coffee * 52)
# or
d = d %>%
mutate(n_coffee_yr = n_coffee * 52)
update.packages()
install.packages("stats19")
citation("stats19")
citation("stats19")
reprex::reprex()
reprex::reprex(citation("stats19"))
install.packages("nasapower")
citation("nasapower")
reprex::reprex(citation("nasapower"))
file.edit("practicals/3-data-structures.Rmd")
u = "https://github.com/ITSLeeds/TDS/releases/download/0.1/desire_lines.geojson"
library(sf)
u = "https://github.com/ITSLeeds/TDS/releases/download/0.1/desire_lines.geojson"
download.file(u, "desire_lines.geojson")
desire_lines = read_sf("desire_lines.geojson")
plot(desire_lines)
plot(desire_lines["car_driver"])
library(tmap)
tm_shap(desire_lines) +
tm_lines()
tm_shape(desire_lines) +
tm_lines()
tm_shape(desire_lines) +
tm_lines(col = "car_driver")
tm_shape(desire_lines) +
tm_lines(col = "foot")
tm_shape(desire_lines) +
tm_lines(col = "foot", lwd = "all")
tm_shape(desire_lines) +
tm_lines(col = "foot", lwd = "all", scale = 9)
desire_lines_1_5km = desire_lines %>%
filter(e_dist_km > 1 & e_dist_km < 3)
desire_lines_1_5km
desire_lines_1_5km = desire_lines %>%
filter(e_dist_km > 1 & e_dist_km < 3)
desire_lines
filter
# Chunk 1
library(dplyr)
library(sf)
u = "https://github.com/ITSLeeds/TDS/releases/download/0.1/desire_lines.geojson"
download.file(u, "desire_lines.geojson")
desire_lines = read_sf("desire_lines.geojson")
# note: you can also read-in the file from the url:
# desire_lines = read_sf(u)
# Chunk 2
library(tmap)
tm_shape(desire_lines) +
tm_lines()
# Chunk 3
tm_shape(desire_lines) +
tm_lines(col = "car_driver")
# Chunk 4
tm_shape(desire_lines) +
tm_lines(col = "foot")
# Chunk 5
tm_shape(desire_lines) +
tm_lines(col = "foot", lwd = "all", scale = 9)
desire_lines_1_5km = desire_lines %>%
filter(e_dist_km > 1 & e_dist_km < 3)
plot(desire_lines_1_5km$geometry)
desire_lines_pcar = desire_lines %>%
mutate(desire_lines_1_5km = car_driver / all * 100)
desire_lines_pcar = desire_lines %>%
mutate(percent_drive = car_driver / all * 100)
car_dep_100 = desire_lines_pcar %>%
top_n(n = 100, wt = percent_drive)
car_dep_100 = desire_lines_pcar %>%
top_n(n = 100, wt = percent_drive)
tm_shape(car_dep_100) +
tm_lines()
tm_shape(car_dep_100) +
tm_lines(col = "percent_drive", lwd = "all", scale = 5)
tm_shape(car_dep_100) +
tm_lines(col = "percent_drive", lwd = "all", scale = 5)
ttm()
tm_shape(car_dep_100) +
tm_lines(col = "percent_drive", lwd = "all", scale = 5)
tm_shape(car_dep_100) +
tm_lines(col = "percent_drive", lwd = "all", scale = 5) +
tm_view(basemaps = leaflet::providers$OpenStreetMap.BlackAndWhite)
region = "west-yorksire"
u_zones = "/master/commute/msoa/"
region = "west-yorksire"
b = "https://github.com/npct/pct-outputs-regional-notR/raw"
u_region = paste0("/master/commute/msoa/", region)
u = paste0("/master/commute/msoa/", region)
u_od = paste0(b, u, "/od_attributes.csv")
od = readr::read_csv(u_od)
u_od
region = "west-yorkshire"
b = "https://github.com/npct/pct-outputs-regional-notR/raw"
u = paste0("/master/commute/msoa/", region)
u_od = paste0(b, u, "/od_attributes.csv")
od = readr::read_csv(u_od)
z = sf::read_sf(paste0(b, u, "/z.geojson"))
z = sf::read_sf(paste0(b, u, "/z.geojson"))
c = sf::read_sf(paste0(b, u, "/c.geojson"))
od_clean = od %>%
select(-id)
desire_lines = stplanr::od2line(flow = od_clean, c)
mapview::mapview(desire_lines[1:100, ])
desire_lines
plot(desire_lines$geometry[999:1999, ])
plot(desire_lines$geometry[999:1999 ])
od_clean = od %>%
select(-id) %>%
desire_lines = stplanr::od2line(flow = od_clean, c)
od_clean = od %>%
select(-id)
cents = sf::read_sf(paste0(b, u, "/c.geojson"))
od_clean = od %>%
select(-id)
desire_lines = stplanr::od2line(flow = od_clean, cents)
plot(desire_lines[1:99, ])
plot(desire_lines[1:99, ])
desire_lines
plot(desire_lines[1:99, ])
plot(desire_lines$geometry[1:99])
cents
od
od_clean
cents
od_clean
od_clean
od_clean = od %>%
select(-id) %>%
filter(geo_code1 %in% cents$geo_code) %>%
filter(geo_code2 %in% cents$geo_code)
desire_lines = stplanr::od2line(flow = od_clean, cents)
plot(desire_lines$geometry[1:99])
mapview::mapview(desire_lines[1:100, ])
head(mpg)
library(tidyverse)
head(mpg)
mpg
ggplot(mpg)
ggplot(mpg) +
geom_point(mapping = aes(hwy, cyl))
ggplot(mpg) +
geom_point(mapping = aes(hwy, cyl), col = "red")
ggplot(mpg) +
geom_point(mapping = aes(hwy, cyl, col = "red"))
ggplot(mpg) +
geom_point(mapping = aes(hwy, cyl, col = drv ))
library(nycflights13)
names(flights)
?flights
# Were delayed by at least an hour, but made up over 30 minutes in flight
# part 1:
delayed_hour = flights %>%
filter(dep_delay > 60)
nrow(delayed_hour)
nrow(delayed_hour) / nrow(flights)
# part 2:
delayed_half_or_less = flights %>%
filter(arr_delay < 30)
# part 3:
result = flights %>%
filter(dep_delay > 60) %>%
filter(arr_delay < 30)
nrow(result)
# part 3:
result = flights %>%
filter(dep_delay > 60 & arr_delay < 30)
nrow(result)
# base R approach
sel_delayed = flights$dep_delay > 60
sel_arrive = flights$arr_delay < 30
class(sel_arrive)
sel_combined = sel_arrive & sel_delayed
sel_combined
result2 = flights[sel_combined, ]
nrow(result2)
summary(is.na(flights$arr_delay))
# base R approach
sel_delayed = flights$dep_delay > 60 &
!is.na(flights$dep_delay)
sel_arrive = flights$arr_delay < 30 &
!is.na(flights$arr_delay)
class(sel_arrive)
sel_combined = sel_arrive & sel_delayed
sum(sel_arrive)
sum(sel_combined)
result2 = flights[sel_combined, ]
nrow(result2)
# part 2: calculate length of delay
flight_delays = flights %>%
mutate(delay = dep_delay - arr_delay)
summary(flight_delays$delay)
# part 2:
delayed_half_or_less = flight_delays %>%
filter(delay < 30)
# part 3:
result = flight_delays %>%
filter(dep_delay > 60 & delay < 30)
result
nrow(result)
summary(flight_delays$delay)
library(dplyr)
library(sf)
u = "https://github.com/ITSLeeds/TDS/releases/download/0.1/desire_lines.geojson"
download.file(u, "desire_lines.geojson")
desire_lines = read_sf("desire_lines.geojson")
library(tmap)
tm_shape(desire_lines) +
tm_lines()
library(flights)
library(dplyr)
# part 3:
result = flight_delays %>%
filter(dep_delay > 60 & delay > 30)
nrow(result)
# part 3:
result = flight_delays %>%
filter(dep_delay > 60 & delay > 30)
nrow(result)
flights
purrr::map_chr(flights, class)
sapply(flights, class)
purrr::map_chr(flights, class)
lapply(flights, class)
library(spDataLarge)
devtools::install_github("Nowosad/spDataLarge")
library(sf)
names(bristol_zones)
plot(bristol_zones)
library(dplyr)
library(sf)
names(bristol_zones)
plot(bristol_zones)
zones_joined = left_join(bristol_zones, zones_attr, by = "geo_code")
zones_attr = bristol_od %>%
group_by(o) %>%
summarize_if(is.numeric, sum) %>%
dplyr::rename(geo_code = o)
zones_joined = left_join(bristol_zones, zones_attr, by = "geo_code")
sum(zones_joined$all)
#> [1] 238805
names(zones_joined)
remotes::install_github("r-spatial/sf")
library(sf)
#> Linking to GEOS 3.5.1, GDAL 2.1.2, PROJ 4.9.3
ls = st_sfc(st_linestring(rbind(c(0,0),c(0,1))),
st_linestring(rbind(c(0,0),c(.1,0))),
st_linestring(rbind(c(0,1),c(.1,1))),
st_linestring(rbind(c(2,2),c(2,2.00001))))
st_sample(ls, 80)
library(sf)
#> Linking to GEOS 3.5.1, GDAL 2.1.2, PROJ 4.9.3
ls = st_sfc(st_linestring(rbind(c(0,0),c(0,1))),
st_linestring(rbind(c(0,0),c(.1,0))),
st_linestring(rbind(c(0,1),c(.1,1))),
st_linestring(rbind(c(2,2),c(2,2.00001))))
st_sample(ls, 80)
plot(.Last.value)
plot(.Last.value)
