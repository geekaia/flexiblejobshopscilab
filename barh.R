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
             ylim=c(0,6),
             col=cores, 
            # legend=legenda,
             main="Tempo por iteração (em segundos)", 
             cex.axis=0.8, 
             cex.names=0.2, 
             cex.main=0.8
              )

legend("topright", legenda, , bty="n", fill =cores);

se1 = 1.96 * sd(data$arq88) / sqrt(length(data$arq88))
se2 = 1.96 * sd(data$arq1010) / sqrt(length(data$arq1010))

lower = c(m.88-se1, m.1010-se2)#, m.v3-se3)
upper = c(m.88+se1, m.1010+se2)#, m.v3+se3)
errbar(bp[,1], tempos, upper, lower, add=T, xlab="")

m88 <- round(m.88,digits=2)
m1010 <- round(m.1010, digits=2)

text(0.7,0.2+ m.88, m88, cex=1)
text(1.9,0.2+ m.1010, m1010, cex=1)




# carrega o arquivo com os dados
data <- read.table("/home/geekaia/flexiblejobshopscilab/8x8tiems.csv", header=T, sep=",")

png(filename="box8x8-tempo.png", bg="white")
boxplot(data$tmp, main="Tempo 8x8",cex.axis=0.8,cex.main=1)
png(filename="box8x8-iteracoes.png", bg="white")
boxplot(data$Num,main="Iterações 8x8",cex.axis=0.8,cex.main=1)



png(filename="iteracoesetempo8x8.png", bg="white")
legenda <- c("Iterações")#, "Tempo")

m.Num <- mean( data$Num)
m.tmp <- mean(data$tmp)
# m.1010 ... 
tempos = c(m.Num)#, m.tmp)

cores <- c("lightblue",  "lightcyan", "lavender")

bp = barplot(tempos, 
            ylim=c(0,3961),
             col=cores, 
             # legend=legenda,
             main="Iterações para encontrar o ótimo do algoritmo para o arquivo 8x8", 
             cex.axis=0.8, 
             cex.names=0.2, 
             cex.main=1
)

legend("topright", legenda, cex=1, bty="n", fill =cores);

se1 = 1.96 * sd(data$Num) / sqrt(length(data$Num))
se2 = 1.96 * sd(data$tmp) / sqrt(length(data$tmp))

lower = c(m.Num-se1)#, m.tmp-se2)#, m.v3-se3)
upper = c(m.Num+se1)#, m.tmp+se2)#, m.v3+se3)
errbar(bp[,1], tempos, upper, lower, add=T, xlab="")

mNum <- round(m.Num,digits=2)
#mtmp <- round(m.tmp, digits=2)

text(0.7,700+ m.Num, mNum, cex=1)
#text(1.9,0.2+ m.tmp, mtmp, cex=1)





# carrega o arquivo com os dados
data <- read.table("/home/geekaia/flexiblejobshopscilab/8x8tiems.csv", header=T, sep=",")
legenda <- c("Tempo")

png(filename="tempos8x8 requerido.png", bg="white")

m.tmp <- mean(data$tmp)
# m.1010 ... 
tempos = c(m.tmp)

cores <- c("lightcyan", "lavender")

bp = barplot(tempos, 
             ylim=c(0,150),
             col=cores, 
             # legend=legenda,
             main="Tempo para encontrar o ótimo do algoritmo para o arquivo 8x8", 
             cex.axis=0.8, 
             cex.names=0.2, 
             cex.main=1
)

legend("topright", legenda, cex=1, bty="n", fill =cores);

#se1 = 1.96 * sd(data$Num) / sqrt(length(data$Num))
se2 = 1.96 * sd(data$tmp) / sqrt(length(data$tmp))

lower = c( m.tmp-se2)#, m.v3-se3)
upper = c(m.tmp+se2)#, m.v3+se3)
errbar(bp[,1], tempos, upper, lower, add=T, xlab="")

mtmp <- round(m.tmp, digits=2)
text(0.7,35+ m.tmp, mtmp, cex=1)






# carrega o arquivo com os dados
data <- read.table("/home/geekaia/flexiblejobshopscilab/10x10times.csv", header=T, sep=",")
legenda <- c("Tempo")




png(filename="tempos10x10 requerido.png", bg="white")

m.tmp <- mean(data$tmp)
# m.1010 ... 
tempos = c(m.tmp)

cores <- c("lightcyan", "lavender")

bp = barplot(tempos, 
             ylim=c(0,20),
             col=cores, 
             # legend=legenda,
             main="Tempo para encontrar o ótimo do algoritmo para o arquivo 10x10", 
             cex.axis=0.8, 
             cex.names=0.2, 
             cex.main=1
)

legend("topright", legenda, cex=1, bty="n", fill =cores);

#se1 = 1.96 * sd(data$Num) / sqrt(length(data$Num))
se2 = 1.96 * sd(data$tmp) / sqrt(length(data$tmp))

lower = c( m.tmp-se2)#, m.v3-se3)
upper = c(m.tmp+se2)#, m.v3+se3)
errbar(bp[,1], tempos, upper, lower, add=T, xlab="")

mtmp <- round(m.tmp, digits=2)
text(0.7,8+ m.tmp, mtmp, cex=1)




# carrega o arquivo com os dados
data <- read.table("/home/geekaia/flexiblejobshopscilab/10x10times.csv", header=T, sep=",")


png(filename="box10x10-tempo.png", bg="white")
boxplot(data$tmp,main="Tempo 10x10",cex.axis=0.8,cex.main=1)
png(filename="box10x10-iteracoes.png", bg="white")
boxplot(data$Num, main="Iterações 10x10", legend="Iterações",cex.axis=0.8,cex.main=1)



legenda <- c("Iterações")#, "Tempo")

png(filename="iteracoesetempo10x10.png", bg="white")

m.Num <- mean( data$Num)
m.tmp <- mean(data$tmp)
# m.1010 ... 
tempos = c(m.Num)#, m.tmp)

cores <- c("lightblue",  "lightcyan", "lavender")

bp = barplot(tempos, 
             ylim=c(0,210),
             col=cores, 
             # legend=legenda,
             main="Iterações para encontrar o ótimo do algoritmo para o arquivo 10x10", 
             cex.axis=0.8, 
             cex.names=0.2, 
             cex.main=1
)

legend("topright", legenda, , bty="n", fill =cores);

se1 = 1.96 * sd(data$Num) / sqrt(length(data$Num))
se2 = 1.96 * sd(data$tmp) / sqrt(length(data$tmp))

lower = c(m.Num-se1)#, m.tmp-se2)#, m.v3-se3)
upper = c(m.Num+se1)#, m.tmp+se2)#, m.v3+se3)
errbar(bp[,1], tempos, upper, lower, add=T, xlab="")

mNum <- round(m.Num,digits=2)
#mtmp <- round(m.tmp, digits=2)

text(0.7,80+ m.Num, mNum, cex=1)
#text(1.9,0.2+ m.tmp, mtmp, )



