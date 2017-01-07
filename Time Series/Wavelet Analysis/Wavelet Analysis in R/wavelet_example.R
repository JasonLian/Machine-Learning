install.packages('biwavelet')
library(biwavelet)
ts = read.csv("monthly_rainfall.csv", header=FALSE)
wt1 = wt(ts)
par(mfrow=c(3,1))
Xtick = c(1,60,120,180,240,300)
Xlab = c(1980,1985,1990,1995,2000,2005)


plot(ts, type="l", ylab="Rainfall(mm)", xlab="Time(year)", ylim=c(0,600), main="Monthly Rainfall", xaxt="n")
axis(side=1, lwd=2, at=Xtick, labels=Xlab, tick=TRUE, las=1)

plot(wt1, type="power.corr.norm", main="Bias-corrected wavelet power", ylab="Period(monthly)", xlab="Time(year)", xaxt="n")
axis(side=1, lwd=2, at=Xtick, labels=Xlab, tick=TRUE, las=1)

plot(wt1, type="power.norm", main="Not-corrected wavelet power", ylab="Period(monthly)", xlab="Time(year)", xaxt="n")
axis(side=1, lwd=2, at=Xtick, labels=Xlab, tick=TRUE, las=1)

par(oma = c(0, 0, 0, 1), mar = c(5, 4, 4, 5) + 0.1)
plot(wt1, plot.cb = TRUE, plot.phase = FALSE)
