
# Geração de gráficos

library("ggplot2", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.3")

# carrega o arquivo com os dados
data <- read.table("/home/geekaia/flexiblejobshopscilab/10x10.csv", header=T, sep=",")
# nome do arquivo .png onde o gráfico será plotado
png(filename="iteracoes-10x10.png", bg="white")
boxplot(data[,1], ylab ="Iterações requeridas para alcançar 8", main="Arquivo 10x10 ") # do tempo

png(filename="tempo-10x10.png", bg="white")
boxplot(data[,3], ylab ="Tempo em segundos", main="Arquivo 10x10 ") # do tempo


data <- read.table("/home/geekaia/flexiblejobshopscilab/3x3.csv", header=T, sep=",")
# nome do arquivo .png onde o gráfico será plotado
png(filename="iteracoes-3x3.png", bg="white")
boxplot(data[,1], ylab ="Iterações requeridas para alcançar 15", main="Arquivo 3x3 ") # do tempo
png(filename="tempo-3x3.png", bg="white")
boxplot(data[,3], ylab ="Tempo em segundos", main="Arquivo 3x3 ") # do tempo


data <- read.table("/home/geekaia/flexiblejobshopscilab/4x5.csv", header=T, sep=",")
# nome do arquivo .png onde o gráfico será plotado
png(filename="iteracoes-4x5.png", bg="white")
boxplot(data[,1], ylab ="Iterações requeridas para alcançar 11", main="Arquivo 4x5") # do tempo
png(filename="tempo-4x5.png", bg="white")
boxplot(data[,3], ylab ="Tempo em segundos", main="Arquivo 4x5") # do tempo



