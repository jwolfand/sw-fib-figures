# This script creates figure 5 of the manuscript
# Multiple Pathways to Bacterial Load Reduction by Stormwater Best Management Practices:
# Trade-offs in Performance, Volume, and Treated Area
source("multiplot.R")
library(ggplot2)
library(ggtern)
library(plotly)
library(akima)

# User-entered constants
mult <- 43.44083342/10^6 #Conversion factor from units to m^3
mass.in <- 4.10e+22
date = "171207"
colorstring = c("yellow", "green", "dodgerblue3")
lblsize <- 10

inf = read.table("Output/withinf_2017-12-19.txt", header = T)
noinf = read.table("Output/noinf_2017-12-19.txt", header = T)
inf$pct.rem = (mass.in - inf$mass.load) / mass.in * 100
noinf$pct.rem = (mass.in - noinf$mass.load) / mass.in * 100

#-------- Create Contour Plot -------
# P1
inf.subset <- subset(inf, log.rem %in% c(0.25))

fld <- with(inf.subset, interp(x = pct.rtd, y = num.SCMs * mult, z = wet.exceedances, 
                               xo = seq(min(pct.rtd), max(pct.rtd), length = 400), duplicate = "mean"))
gdat <- interp2xyz(fld, data.frame = TRUE)
names(gdat) <- c('pct.rtd', 'treat.vol', 'wet.exceedances')

p1 <- plot_ly(
  gdat,
  x = ~ pct.rtd,
  y = ~ treat.vol,
  z = ~ wet.exceedances,
  colors = colorstring,
  type = 'contour',
  autocontour = F,
  colorbar = list(nticks = 20, title = "# Exceedances"),
  showscale = TRUE,
  contours = list(
    start = 0,
    end = 150,
    size = 5,
    showlabels = TRUE,
    labelfont = list(size = lblsize)
  )
)

#P2
inf.subset <- subset(inf, log.rem %in% c(3))

fld <- with(
  inf.subset,
  interp(
    x = pct.rtd,
    y = num.SCMs * mult,
    z = wet.exceedances,
    xo = seq(min(pct.rtd), max(pct.rtd), length = 400),
    duplicate = "mean"
  )
)
gdat <- interp2xyz(fld, data.frame = TRUE)
names(gdat) <- c('pct.rtd', 'treat.vol', 'wet.exceedances')

p2 <- plot_ly(
  gdat,
  x = ~ pct.rtd,
  y = ~ treat.vol,
  z = ~ wet.exceedances,
  colors = colorstring,
  type = 'contour',
  autocontour = F,
  showscale = FALSE,
  contours = list(
    start = 0,
    end = 150,
    size = 5,
    showlabels = TRUE,
    labelfont = list(size = lblsize)
  )
)

#P3
noinf.subset <- subset(noinf, log.rem %in% c(0.25))

fld <- with(
  noinf.subset,
  interp(
    x = pct.rtd,
    y = num.SCMs * mult,
    z = wet.exceedances,
    xo = seq(min(pct.rtd), max(pct.rtd), length = 400),
    duplicate = "mean"
  )
)
gdat <- interp2xyz(fld, data.frame = TRUE)
names(gdat) <- c('pct.rtd', 'treat.vol', 'wet.exceedances')

p3 <- plot_ly(
  gdat,
  x = ~ pct.rtd,
  y = ~ treat.vol,
  z = ~ wet.exceedances,
  colors = colorstring,
  type = 'contour',
  autocontour = F,
  showscale = FALSE,
  contours = list(
    start = 0,
    end = 150,
    size = 5,
    showlabels = TRUE,
    labelfont = list(size = lblsize)
  )
)

#P4
noinf.subset <- subset(noinf, log.rem %in% c(3))

fld <- with(
  noinf.subset,
  interp(
    x = pct.rtd,
    y = num.SCMs * mult,
    z = wet.exceedances,
    xo = seq(min(pct.rtd), max(pct.rtd), length = 400),
    duplicate = "mean"
  )
)
gdat <- interp2xyz(fld, data.frame = TRUE)
names(gdat) <- c('pct.rtd', 'treat.vol', 'wet.exceedances')

p4 <- plot_ly(
  gdat,
  x = ~ pct.rtd,
  y = ~ treat.vol,
  z = ~ wet.exceedances,
  colors = colorstring,
  type = 'contour',
  autocontour = F,
  showscale = FALSE,
  contours = list(
    start = 0,
    end = 150,
    size = 5,
    showlabels = TRUE,
    labelfont = list(size = lblsize)
  )
)

# P5
inf.subset <- subset(inf, log.rem %in% c(0.25))

fld <- with(
  inf.subset,
  interp(
    x = pct.rtd,
    y = num.SCMs * mult,
    z = dry.exceedances,
    xo = seq(min(pct.rtd), max(pct.rtd), length = 400),
    duplicate = "mean"
  )
)
gdat <- interp2xyz(fld, data.frame = TRUE)
names(gdat) <- c('pct.rtd', 'treat.vol', 'dry.exceedances')

p5 <- plot_ly(
  gdat,
  x = ~ pct.rtd,
  y = ~ treat.vol,
  z = ~ dry.exceedances,
  colors = colorstring,
  type = 'contour',
  autocontour = F,
  showscale = FALSE,
  contours = list(
    start = 0,
    end = 150,
    size = 20,
    showlabels = TRUE,
    labelfont = list(size = lblsize)
  )
)

#P6
inf.subset <- subset(inf, log.rem %in% c(0.3))

fld <- with(
  inf.subset,
  interp(
    x = pct.rtd,
    y = num.SCMs * mult,
    z = dry.exceedances,
    xo = seq(min(pct.rtd), max(pct.rtd), length = 400),
    duplicate = "mean"
  )
)
gdat <- interp2xyz(fld, data.frame = TRUE)
names(gdat) <- c('pct.rtd', 'treat.vol', 'dry.exceedances')

p6 <- plot_ly(
  gdat,
  x = ~ pct.rtd,
  y = ~ treat.vol,
  z = ~ dry.exceedances,
  colors = colorstring,
  type = 'contour',
  autocontour = F,
  showscale = FALSE,
  contours = list(
    start = 0,
    end = 150,
    size = 20,
    showlabels = TRUE,
    labelfont = list(size = lblsize)
  )
)

#P7
noinf.subset <- subset(noinf, log.rem %in% c(0.25))

fld <- with(
  noinf.subset,
  interp(
    x = pct.rtd,
    y = num.SCMs * mult,
    z = dry.exceedances,
    xo = seq(min(pct.rtd), max(pct.rtd), length = 400),
    duplicate = "mean"
  )
)
gdat <- interp2xyz(fld, data.frame = TRUE)
names(gdat) <- c('pct.rtd', 'treat.vol', 'dry.exceedances')

p7 <- plot_ly(
  gdat,
  x = ~ pct.rtd,
  y = ~ treat.vol,
  z = ~ dry.exceedances,
  colors = colorstring,
  type = 'contour',
  autocontour = F,
  showscale = FALSE,
  contours = list(
    start = 0,
    end = 150,
    size = 5,
    showlabels = TRUE,
    labelfont = list(size = lblsize)
  )
)

#P8
noinf.subset <- subset(noinf, log.rem %in% c(3))

fld <- with(
  noinf.subset,
  interp(
    x = pct.rtd,
    y = num.SCMs * mult,
    z = dry.exceedances,
    xo = seq(min(pct.rtd), max(pct.rtd), length = 400),
    duplicate = "mean"
  )
)
gdat <- interp2xyz(fld, data.frame = TRUE)
names(gdat) <- c('pct.rtd', 'treat.vol', 'dry.exceedances')

p8 <- plot_ly(
  gdat,
  x = ~ pct.rtd,
  y = ~ treat.vol,
  z = ~ dry.exceedances,
  colors = colorstring,
  type = 'contour',
  autocontour = F,
  showscale = FALSE,
  contours = list(
    start = 0,
    end = 150,
    size = 20,
    showlabels = TRUE,
    labelfont = list(size = lblsize)
  )
)

p <- subplot(nrows = 4,  p1, p2, p3, p4, p5, p6, p7, p8, shareX = TRUE, shareY = TRUE)
#p
htmlwidgets::saveWidget(p, "Contour_figure.html")
#export(p, file = "image.png")
