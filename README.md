
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TDS (Transport Data Science)

This is a GitHub Repository (repo for short) that supports teaching of
the Transport Data Science module at the University of Leeds. The module
can be taken by students on the [Data Science and
Analytics](https://courses.leeds.ac.uk/i071/data-science-and-analytics-msc)
and (from 2022 onwards) [Transport Planning and the
Environment](https://courses.leeds.ac.uk/a386/transport-planning-and-the-environment-msc)
MSc courses.

<!-- The module catalogue can be found at [`catalogue.md`](https://github.com/ITSLeeds/TDS/blob/master/catalogue.md). -->
<!-- The computer code accompanying the course can be found in the `code` folders. -->
<!-- To run this code you will need R and Python installed plus various packages and libraries. -->
<!-- The timetable can be found: -->
<!-- - On the University's system (official): [http://timetable.leeds.ac.uk/](http://timetable.leeds.ac.uk/teaching/202021/reporting/Individual?objectclass=module&idtype=name&identifier=TRAN5340M01&&template=SWSCUST+module+Individual&days=1-7&weeks=1-52&periods=1-21) -->
<!-- - In ical format (for import into Google/Outlook/other Calendar systems): https://github.com/ITSLeeds/TDS/raw/master/timetable-2020.ics -->
<!-- - As a .csv file (for easy reading as data): https://github.com/ITSLeeds/TDS/blob/master/timetable-2020.csv -->
<!-- See below for the sessions -->
<!-- The module timetable is shown in the table below. -->
<!-- # References -->
<!-- To access references collected for this course (and contribute more if you want), you can join the 'tds' Zotero group: https://www.zotero.org/groups/956304/tds -->

# Prerequisites

## Software

For this module you need to have up-to-date versions of R and RStudio
installed on a computer you have access to:

-   R from [cran.r-project.org](https://cran.r-project.org/)
-   RStudio from
    [rstudio.com](https://rstudio.com/products/rstudio/download/#download)
-   R packages, which can be installed by opening RStudio and typing
    `install.packages("stats19")` in the R console, for example.

You should have the latest stable release of R (4.0.0 or above) running
R on a decent computer, with at least 4 GB RAM and ideally 8 GB or more
RAM. See [Section 1.5 of the online guide Reproducible Road Safety
Research with
R](https://itsleeds.github.io/rrsrr/introduction.html#installing-r-and-rstudio)
for instructions on how to install key packages we will use in the
module.[1]

It is also recommended that you have installed and have experience with
GitHub Desktop (or command line git on Linux and Mac), Docker, Python,
QGIS and transport modelling tools such as SUMO and A/B Street. These
software packages will help with the course but are not essential.

## Data science experience

Attending the Introduction to R one-off 3 hour workshop (semester 1
Computer Skills workshop) and experience of using R (e.g. having used it
for work, in previous degrees or having completed an online course) is
essential. Students can demonstrate this by showing evidence that they
have worked with R before, have completed an online course such as the
first 4 sessions in the RStudio Primers series
<https://rstudio.cloud/learn/primers> or DataCamp’s Free Introduction to
R course: <https://www.datacamp.com/courses/free-introduction-to-r>.
This is an advanced and research-led module. Evidence of substantial
programming and data science experience in previous professional or
academic work, in languages such as R or Python, also constitutes
sufficient pre-requisite knowledge for the course.

## Course reading

Before the course starts you should read key texts on transport data
science.

**Essential**

-   The [transport
    chapter](http://geocompr.robinlovelace.net/transport.html)
    (available free [online](http://geocompr.robinlovelace.net/))
    (Lovelace, Nowosad, and Muenchow 2019)

**Core**

-   Paper on open source tools for geographic analysis in transport
    planning (Lovelace 2021)
-   Introduction to data science with R (available free
    [online](http://r4ds.had.co.nz/)) (Grolemund and Wickham 2016)
    <!-- - Introductory textbook introducing machine learning with lucid prose and worked examples in R (available free [online](http://www-bcf.usc.edu/~gareth/ISL/index.html)) [@james_introduction_2013] -->
-   Paper on analysing OSM data in Python (available
    [online](https://arxiv.org/pdf/1611.01890)) (Boeing 2017)

**Optional**

-   Paper on the **stplanr** paper for transport planning (available
    [online](https://cran.r-project.org/web/packages/stplanr/vignettes/stplanr-paper.html))
    (Lovelace and Ellison 2018)
-   Book on transport data science in Python (Fox 2018)
-   Papers describing the use of data science to solve transport
    planning problems (e.g. Szell et al. 2021;
    **orozco_datadriven_2020?**)
    <!-- - Seminal text on visualisation (available [online](https://github.com/yowenter/books/blob/master/Design/Edward%20R%20Tufte%20-The%20Visual%20Display%20of%20Quantitative%20Information.pdf), style available in the [tufte](https://github.com/rstudio/tufte) R package) [@tufte_visual_2001] -->
-   An academic paper describing the development of a web application
    for the Department for Transport (**goodman_scenarios_2019?**)

<!-- ## Course locations -->
<!-- See the image below for the course locations and the following links: -->
<!-- The lectures will be in the Business School Maurice Keyworth SR (1.15): http://students.leeds.ac.uk/room/1-01-087-2730-01-115 -->
<!-- The practicals will be in the West Teaching Lab Cluster (B.16): http://it.leeds.ac.uk/site/custom_scripts/clusters.php -->

# Slides and lectures

Slides can be found online:

-   See <https://itsleeds.github.io/TDS/slides/1-intro.html#1> for the
    introductory slides, for example
-   Videos of the lectures can be found on the University of Leeds’
    Blackboard system (you must must
    [register](https://www.leeds.ac.uk/info/101040/applying/86/how_to_apply_for_masters_courses)
    to courses such as [Data Science and
    Analytics](https://courses.leeds.ac.uk/i071/data-science-and-analytics-msc)
    or [Transport Planning and the
    Environment](https://courses.leeds.ac.uk/a386/transport-planning-and-the-environment-msc)
    to take the course)

# Assessment (for those doing this as credit-bearing)

-   You will build-up a portfolio of work
-   100% coursework assessed, you will submit by **Friday 14th May**:
    -   **a pdf document up to 10 pages long with figures, tables,
        references explaining how you used data science to research a
        transport problem**
    -   **reproducible code contained in an RMarkdown (.Rmd) document
        that produced the report**
-   Written in RMarkdown - will be graded for reproducibility
-   Code chunks and figures are encouraged
-   You will submit a non-assessed 2 page pdf + Rmd report by **Friday
    26th March**

# Issues and contributing

Any feedback or contributions to this repo are welcome. If you have a
question please open an issue here (you’ll need a GitHub account):
<https://github.com/ITSLeeds/TDS/issues>

<!-- # Data -->
<!-- Data for course can be accessed from the repos [Releases](https://github.com/ITSLeeds/TDS/releases) page. -->
<!-- You can, for example, download and unzip the data folder in a local version of the repo (accessed by downloading and unzipp https://github.com/ITSLeeds/TDS/archive/master.zip ) with the following R commands: -->
<!-- If you want to be clever you can use the piggyback package: -->
<!-- ```{r, eval=FALSE, engine='python', echo=FALSE} -->
<!-- import pandas as pd -->
<!-- e = pd.read_csv("/mnt/27bfad9a-3474-4e61-9a43-0156ebc67d67/home/robin/ITSLeeds/TDS/sample-data/everyone.csv") -->
<!-- pd.DataFrame.sort_values(e, "n_coffee") -->
<!-- ``` -->
<!-- # Other projects -->
<!-- - A book on R for Geocomputation: https://github.com/Robinlovelace/geocompr -->
<!-- - A Python package for OSM data analysis: https://github.com/gboeing/osmnx -->
<!-- # Building the website -->
<!-- To publish the slides and other content online, the following commands were used: -->

# References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-boeing_osmnx_2017" class="csl-entry">

Boeing, Geoff. 2017. “OSMnx: New Methods for Acquiring, Constructing,
Analyzing, and Visualizing Complex Street Networks.” *Computers,
Environment and Urban Systems* 65 (September): 126–39.
<https://doi.org/gbvjxq>.

</div>

<div id="ref-fox_data_2018" class="csl-entry">

Fox, Charles. 2018. *Data Science for Transport: A Self-Study Guide with
Computer Exercises*. 1st ed. 2018 edition. New York, NY: Springer.

</div>

<div id="ref-grolemund_r_2016" class="csl-entry">

Grolemund, Garrett, and Hadley Wickham. 2016. *R for Data Science*.
O’Reilly Media.

</div>

<div id="ref-lovelace_open_2021" class="csl-entry">

Lovelace, Robin. 2021. “Open Source Tools for Geographic Analysis in
Transport Planning.” *Journal of Geographical Systems*, January.
<https://doi.org/ghtnrp>.

</div>

<div id="ref-lovelace_stplanr_2018" class="csl-entry">

Lovelace, Robin, and Richard Ellison. 2018. “Stplanr: A Package for
Transport Planning.” *The R Journal* 10 (2): 7–23.
<https://doi.org/gkb499>.

</div>

<div id="ref-lovelace_geocomputation_2019" class="csl-entry">

Lovelace, Robin, Jakub Nowosad, and Jannes Muenchow. 2019.
*Geocomputation with R*. CRC Press.

</div>

<div id="ref-szell_growing_2021" class="csl-entry">

Szell, Michael, Sayat Mimar, Tyler Perlman, Gourab Ghoshal, and Roberta
Sinatra. 2021. “Growing Urban Bicycle Networks.” *arXiv:2107.02185
\[Physics\]*, July. <https://arxiv.org/abs/2107.02185>.

</div>

</div>

[1]  For further guidance on setting-up your computer to run R and
RStudio for spatial data, see these links, we recommend Chapter 2 of
Geocomputation with R (the Prerequisites section contains links for
installing spatial software on Mac, Linux and Windows):
<https://geocompr.robinlovelace.net/spatial-class.html> and Chapter 2 of
the online book *Efficient R Programming*, particularly sections 2.3 and
2.5, for details on R installation and
[set-up](https://csgillespie.github.io/efficientR/set-up.html) and the
[project management
section](https://csgillespie.github.io/efficientR/set-up.html#project-management).
