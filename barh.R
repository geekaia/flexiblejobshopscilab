library(Hmisc)
library("ggplot2", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.3")

# carrega o arquivo com os dados
data <- read.table("/home/geekaia/flexiblejobshopscilab/tmp88.csv", header=T, sep=",")
legenda <- c("8x8", "10x10")

png(filename="temposPorIteracao.png", bg="white")

m.88 <- mean( data$arq88)
m.1010 <- mean(data$arq1010)
# m.1010 ... 
tempos = c(m.88, m.1010)

cores <- c("lightblue",  "lightcyan", "lavender")

bp = barplot(tempos, 
             ylim=c(0,10),
             col=cores, 
            # legend=legenda,
             main="Tempo por iteração (em segundos)", 
             cex.axis=0.5, 
             cex.names=0.2, 
             cex.main=0.8
              )

legend("topright", legenda, cex=0.8, bty="n", fill =cores);

se1 = 1.96 * sd(data$arq88) / sqrt(length(data$arq88))
se2 = 1.96 * sd(data$arq1010) / sqrt(length(data$arq1010))

lower = c(m.88-se1, m.1010-se2)#, m.v3-se3)
upper = c(m.88+se1, m.1010+se2)#, m.v3+se3)
errbar(bp[,1], tempos, upper, lower, add=T, xlab="")

m88 <- round(m.88,digits=2)
m1010 <- round(m.1010, digits=2)

text(0.7,1+ m.88, m88, cex=0.8)
text(1.9,1+ m.1010, m1010, cex=0.8)


