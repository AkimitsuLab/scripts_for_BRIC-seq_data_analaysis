library(BridgeR)
library(ggplot2)
arg1 <- commandArgs(trailingOnly=TRUE)[1]
normfile <- commandArgs(trailingOnly=TRUE)[2]
files <- c(arg1)
hour <- c(0,1,2,4,8,12)
group <- c("Control_lncRNA")
InforColumn <- 4

BridgeRCustom(YourNormFactor = normfile,
                          SelectNormFactor=F,
                          InputFiles = files,
                          InforColumn=4,
                          group = group,
                          hour = hour,
                          RPKMcutoff=0.1,
                          CutoffDataPointNumber = 4,
                          CutoffDataPoint1 = c(1,2),
                          CutoffDataPoint2 = c(8,12),
                          ThresholdHalfLife = c(8,12),
                          CutoffRelExp=0.001,
                          ModelMode="R2_selection")
