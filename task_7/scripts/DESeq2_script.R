library(DESeq2)
library(dplyr)
library(ggplot2)
library(ggrepel)

expr_raw <- read.csv("C:/Users/mefim/Downloads/rna_seq_diff_exp/raw_counts_ici_samples.tsv",
                     sep='\t', row.names = 1)
colnames(expr_raw) <- gsub("-", ".", colnames(expr_raw))

sample_metadata <- read.csv("C:/Users/mefim/Downloads/rna_seq_diff_exp/meta_responses.tsv", 
                            row.names = 1, sep='\t')
rownames(sample_metadata) <- gsub("-", ".", rownames(sample_metadata))

sample_metadata <- sample_metadata[sample_metadata$X0 %in% c('R', 'NR'), , drop = FALSE] 

outliers <- c('Luc_65_S30_R1_001ReadsPerGene',
              'LuC_59_S1_R1_001ReadsPerGene', 
              'LuC_56_S19_R1_001ReadsPerGene',
              'Luc.1_S10_R1_001ReadsPerGene',
              'Luc.45_S5_R1_001ReadsPerGene',
              'LuC_72_S3_R1_001ReadsPerGene',
              'LuC_50_S5_R1_001ReadsPerGene')

expr_raw <- expr_raw[, !colnames(expr_raw) %in% outliers]
sample_metadata <- sample_metadata[!rownames(sample_metadata) %in% outliers,, drop = FALSE ]
head(colnames(expr_raw))
head(rownames(sample_metadata))
expr_raw <- expr_raw[, intersect(colnames(expr_raw), rownames(sample_metadata))]
sample_metadata <- sample_metadata[colnames(expr_raw), , drop = FALSE]

dds <- DESeqDataSetFromMatrix(countData = expr_raw,
                              colData = sample_metadata,
                              design = ~ X0)
dds$X0 <- relevel(dds$X0, ref = "NR")
dds <- DESeq(dds)
res <- results(dds)
summary(res)

res_df <- as.data.frame(res) %>% 
  select(log2FoldChange, pvalue, padj) %>%
  arrange(padj)

write.table(res_df,
            file = "C:/Users/mefim/Downloads/rna_seq_diff_exp/DEG_results.tsv",
            sep = "\t", quote = FALSE, col.names = NA)

#volcano plot
pvalue_threshold <- 10**(-2)
log2fc_threshold <- 2

res$significance <- ifelse(res$padj < pvalue_threshold & abs(res$log2FoldChange) > log2fc_threshold, 
                           "Significant", "Not Significant")
res$log2FoldChange <- as.numeric(res$log2FoldChange)
res$padj <- as.numeric(res$padj)

hgnc_table <- read.csv("C:/Users/mefim/Downloads/rna_seq_diff_exp/hgnc_complete_set.txt", 
                       row.names = 1, sep='\t')
symbol_map <- setNames(hgnc_table$symbol, hgnc_table$ensembl_gene_id)
rownames(res) <- sapply(rownames(res), function(id) {
  if (id %in% names(symbol_map) && !is.na(symbol_map[id])) {
    symbol_map[id]
  } else {
    id
  }
})

res_df <- as.data.frame(res)
significant_genes <- as.data.frame(subset(res_df, padj < pvalue_threshold & abs(log2FoldChange) > log2fc_threshold))

ggplot(res_df, aes(x = log2FoldChange, y = -log10(padj), color = significance)) +
  geom_point(alpha = 0.8, size = 1.5) +
  scale_color_manual(values = c("grey", "red")) +
  geom_hline(yintercept = -log10(pvalue_threshold), linetype = "dashed", color = "black") +  # порог p-value
  geom_vline(xintercept = c(-log2fc_threshold, log2fc_threshold), linetype = "dashed", color = "black") +  # пороги fold change
  labs(title = "Volcano Plot R vs NR", x = "Log2 Fold Change", y = "-Log10 Adjusted P-value") +
  theme_minimal() +
  theme(legend.position = "none") +
  geom_text_repel(data = significant_genes, 
                  aes(label = rownames(significant_genes)), size = 3, max.overlaps = 10) +
  xlim(-10, 10)

