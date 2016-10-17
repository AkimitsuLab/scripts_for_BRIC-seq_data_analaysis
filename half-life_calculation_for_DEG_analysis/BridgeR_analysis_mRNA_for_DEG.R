library(BridgeR)
library(ggplot2)
arg1 <- commandArgs(trailingOnly=TRUE)[1]
arg2 <- commandArgs(trailingOnly=TRUE)[2]

files <- c(arg1, arg2)
hour <- c(0,1,2,4,8,12)
group <- c("Control","Knockdown")
InforColumn <- 4

BridgeRCore(InputFiles = files,
            InforColumn=4,
            group = group,
            hour = hour,
            RPKMcutoff=0.1,
            RelRPKMFig=F,
            SelectNormFactor=F,
            CutoffDataPointNumber = 4,
            CutoffDataPoint1 = c(1,2),
            CutoffDataPoint2 = c(8,12),
            ThresholdHalfLife = c(8,12),
            CutoffRelExp=0.001,
            ModelMode="R2_selection")

BridgeRCompare(InputFile="BridgeR_5C_HalfLife_calculation_R2_selection.txt",
               InforColumn=4,
               group=group,
               hour=hour,
               ComparisonFile=group,
               CutoffDataPointNumber = 4,
               ModelMode="R2_selection",
               Calibration=F)
