library("edgeR")

files <- c("0Hour_repl1_counts.txt", "0Hour_repl2_counts.txt",
      "6Hour_repl1_counts.txt", "6Hour_repl2_counts.txt")

data <- readDGE(files, header=FALSE)

print(data)
head(data$counts)

###

group <- c(rep("0Hour",2), rep("6Hour",2))

dge = DGEList(counts=data, group=group)
dge <- estimateCommonDisp(dge)
dge <- estimateTagwiseDisp(dge)

# plot!
et <- exactTest(dge)
etp <- topTags(et, n=100000)
etp$table$logFC = -etp$table$logFC
pdf("nema-edgeR-MA-plot.pdf")
plot(
  etp$table$logCPM,
  etp$table$logFC,
  xlim=c(-3, 20), ylim=c(-12, 12), pch=20, cex=.3,
  col = ifelse( etp$table$FDR < .2, "red", "black" ) )
dev.off()

# more plot!
pdf("nema-edgeR-MDS.pdf")
plotMDS(dge)
dev.off()

# output CSV
write.csv(etp$table, "nema-edgeR.csv")
