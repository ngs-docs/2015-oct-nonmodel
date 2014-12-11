library("edgeR")

files <- c("female_repl1_counts.txt", "female_repl2_counts.txt",
      "male_repl1_counts.txt", "male_repl2_counts.txt")

data <- readDGE(files, header=FALSE)

print(data)
head(data$counts)

###

group <- c(rep("female",2), rep("male",2))

dge = DGEList(counts=data, group=group)
dge <- estimateCommonDisp(dge)
dge <- estimateTagwiseDisp(dge)

# plot!
et <- exactTest(dge)
etp <- topTags(et, n=100000)
etp$table$logFC = -etp$table$logFC
pdf("chick-edgeR-MA-plot.pdf")
plot(
  etp$table$logCPM,
  etp$table$logFC,
  xlim=c(-3, 20), ylim=c(-12, 12), pch=20, cex=.3,
  col = ifelse( etp$table$FDR < .2, "red", "black" ) )
dev.off()

# more plot!
pdf("chick-edgeR-MDS.pdf")
plotMDS(dge)
dev.off()

# output CSV
write.csv(etp$table, "chick-edgeR.csv")
