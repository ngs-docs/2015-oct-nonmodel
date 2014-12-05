samples <- c("lung_repl1", "lung_repl2", "salivary_repl1", "salivary_repl2")

read.sample <- function(sample.name) {
    file.name <- paste(sample.name, "_counts.txt", sep="")
    result <- read.delim(file.name, col.names=c("gene", "count"), sep="\t", colClasses=c("character", "numeric"), row.names=1)
}

sample.1 <- read.sample(samples[1])
sample.2 <- read.sample(samples[2])
sample.3 <- read.sample(samples[3])
sample.4 <- read.sample(samples[4])

head(sample.1)

# Now let's combine them all into one dataset
all.data <- data.frame(sample.1, sample.2$count, sample.3$count,sample.4$count)

# name the columns
colnames(all.data)[1:ncol(all.data)] <- samples

# eliminate the last five rows
all.data <- all.data[1:(nrow(all.data)-5),]

# We now have a data frame with all the data in it!
head(all.data)

###

# now, do differential expression w/edgeR

library("edgeR")

# group replicates by sample type
group <- c(rep("lung",2), rep("salivary",2))

# calculate differential expression and dispersion
dge = DGEList(counts=all.data, group=group)
dge <- estimateCommonDisp(dge)
dge <- estimateTagwiseDisp(dge)

# plot!
et <- exactTest(dge)
etp <- topTags(et, n=100000)

summary(etp$table)

etp$table$logFC = -etp$table$logFC
pdf("edgeR-MA-plot.pdf")
plot(
  etp$table$logCPM,
  etp$table$logFC,
  xlim=c(-3, 20), ylim=c(-12, 12), pch=20, cex=.3,
  col = ifelse( etp$table$FDR < .1, "red", "black" ) )
dev.off()

# output CSV
write.csv(etp$table, "edgeR-lung-vs-salivary.csv")
