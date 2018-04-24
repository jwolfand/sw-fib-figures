# This script creates Figure 6 and S3 of the paper entitled
# Multiple pathways to bacterial load reduction by stormwater best management practices:
# tradeoffs in performance, volume, and treated area


source("multiplot.R")
library(ggplot2)
library(ggtern)
library(akima)

# Constants
# Hardcoded, total mass to calculate percent load reduction
mass.in <- 4.10319152914786E+22
date <- Sys.Date()
withinf = read.table("Output/withinf_2017-12-19.txt", header = T)
noinf = read.table("Output/noinf_2017-12-19.txt", header = T)
withinf$pct.rem = (mass.in - withinf$mass.load) / mass.in * 100
noinf$pct.rem = (mass.in - noinf$mass.load) / mass.in * 100
withinf$log.rem <- as.factor(withinf$log.rem)
noinf$log.rem <- as.factor(noinf$log.rem)
colnames(noinf) = c(
  "pct.rtd",
  "SCM",
  "num.SCMs",
  "Log Removal",
  "wet.exceedances",
  "dry.exceedances",
  "GM.exceedances",
  "mass.load",
  "pct.rem"
)
colnames(withinf) = c(
  "pct.rtd",
  "SCM",
  "num.SCMs",
  "Log Removal",
  "wet.exceedances",
  "dry.exceedances",
  "GM.exceedances",
  "mass.load",
  "pct.rem"
)
conv <- 43.44083342 / 10 ^ 6 #Conversion factor from units to m^3
group.colors <-
  c(
    "#A93226",
    "#76448A",
    "#1861FD",
    "#148F77",
    "#1E8449",
    "#B7950B",
    "#B9770E",
    "#A04000",
    "#616A6B",
    "#283747"
  )

# Function to create the annual wet weather exceedance plots
CreateFig1 <- function (data, pct) {
  p <- ggplot(
    subset(
      data,
      pct.rtd %in% pct &
        `Log Removal` %in% c(0, 0.25, 0.5, 0.75, 1, 1.5, 2, 3)
    ),
    aes(
      x = num.SCMs * conv,
      y = wet.exceedances,
      group = `Log Removal`,
      color = `Log Removal`,
      shape = `Log Removal`
    )
  ) +
    geom_point() +
    geom_line(size = 1) +
    scale_shape_manual(values = seq(15, 24)) +
    #scale_color_hue(l = 40, c = 40) +
    scale_colour_manual(values = group.colors[3:10]) +
    scale_x_continuous(
      expand = c(0, 0),
      sec.axis = sec_axis( ~ . / conv, name = "# Bioretention Units")
    ) +
    scale_y_continuous(expand = c(0, 0)) +
    coord_cartesian(ylim = c(0, 60)) +
    geom_hline(yintercept = 15, linetype = "dashed") +
    theme_bw() +
    theme(
      plot.title = element_text(hjust = 0.5),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      text = element_text(size = 16),
      legend.position = "none"
    )
  
  return(p)
}

# Function to create the annual load reduction plots
CreateFig2 <- function (data, pct) {
  p <- ggplot(
    subset(
      data,
      pct.rtd %in% pct &
        `Log Removal` %in% c(0, 0.25, 0.5, 0.75, 1, 1.5, 2, 3)
    ),
    aes(
      x = num.SCMs * conv,
      y = round(pct.rem, 3),
      group = `Log Removal`,
      color = `Log Removal`,
      shape = `Log Removal`
    )
  ) +
    geom_point() + geom_line(size = 1) +
    scale_shape_manual(values = seq(17, 24)) +
    scale_colour_manual(values = group.colors[3:10]) +
    scale_y_reverse(lim = c(100, 0)) +  theme_bw() +
    scale_x_continuous(
      expand = c(0, 0),
      sec.axis = sec_axis( ~ . / conv, name = "# Bioretention Units")
    )  +
    theme(
      plot.title = element_text(hjust = 0.5),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      text = element_text(size = 16),
      legend.position = "none"
    ) + geom_vline(xintercept = 71074 * conv,
                   size = 0.5,
                   linetype = "dashed")
  return(p)
}

### FIGURE 6 - 8 PANELS OF WW EXCEEDANCES AND LOAD REDUCTION (100, 95, 75, 50 % TREATED)
p1 <- CreateFig1(noinf, 100)
p2 <- CreateFig1(noinf, 95)
p3 <- CreateFig1(noinf, 75)
p4 <- CreateFig1(noinf, 50)
p5 <- CreateFig2(withinf, 100)
p6 <- CreateFig2(withinf, 95)
p7 <- CreateFig2(withinf, 75)
p8 <- CreateFig2(withinf, 50)
svg(
  filename = paste0(
    "C:/SUSTAIN/PROJECTS/Ballona/sw-fib-figures/Figures/",
    date,
    "_Fig_6.svg"
  ),
  width = 10,
  height = 10
)
q2 <- multiplot(p1, p2, p3, p4, p5, p6, p7, p8, cols = 2)
dev.off()

### FIGURE S3 - 4 PANELS OF WW EXCEEDANCES AND LOAD REDUCTION (90 AND 25% TREATED)
p1 <- CreateFig1(withinf, 90)
p2 <- CreateFig1(withinf, 25)
p3 <- CreateFig2(withinf, 90)
p4 <- CreateFig2(withinf, 25)
svg(
  filename = paste0(
    "C:/SUSTAIN/PROJECTS/Ballona/sw-fib-figures/Figures/",
    date,
    "_Fig_S3.svg"
  ),
  width = 10,
  height = 5
)
q2 <- multiplot(p1, p2, p3, p4, cols = 2)
dev.off()
