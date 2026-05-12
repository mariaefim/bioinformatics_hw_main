BiocManager::install("limma")
library(limma)
library(ggplot2)
library(ggrepel)
library(Biobase)

exp <- read.csv("C:/Users/mefim/Downloads/rna_seq_diff_exp/GSE63885/expression_for_limma2.csv", 
                header = TRUE, row.names = 'Gene.Symbol')
ann <- read.csv("C:/Users/mefim/Downloads/rna_seq_diff_exp/GSE63885/annotation_for_limma.csv", 
                header = TRUE, row.names = 'X')

#отфильтруем низкоэкспрессируемые гены (берем топ 50% наиболее экспрессируемых генов)
medians <- apply(exp, 1, median)
exp <- exp[medians > median(medians), ]

exp_set <- ExpressionSet(assayData = as.matrix(exp), phenoData = AnnotatedDataFrame(ann))

slope <- factor(ann$clinical.status.post.1st.line.chemotherapy..cr...complete.response..pr...partial.response..sd...stable.disease..p...progression..ch1,
                levels = c("pNC", "pCR"))  #pNC как референс

design <- model.matrix(~ slope)
colnames(design) <- c("Intercept", "pCR")

fit <- lmFit(exp_set, design)
fit <- eBayes(fit)
top <- topTable(fit, coef = "pCR", adjust = "BH", n = Inf) 
top <- top[, c("logFC", "P.Value", "adj.P.Val")]

#добавление столбцов significant
pvalue_threshold <- 0.05

top$sig_adjP_lfc1 <- ifelse(top$adj.P.Val < pvalue_threshold & abs(top$logFC) > 1, "+", "-")
top$sig_pval_lfc1 <- ifelse(top$P.Value   < pvalue_threshold & abs(top$logFC) > 1, "+", "-")

top$sig_adjP_lfc2 <- ifelse(top$adj.P.Val < pvalue_threshold & abs(top$logFC) > 2, "+", "-")
top$sig_pval_lfc2 <- ifelse(top$P.Value   < pvalue_threshold & abs(top$logFC) > 2, "+", "-")

top$sig_adjP_lfc3 <- ifelse(top$adj.P.Val < pvalue_threshold & abs(top$logFC) > 3, "+", "-")
top$sig_pval_lfc3 <- ifelse(top$P.Value   < pvalue_threshold & abs(top$logFC) > 3, "+", "-")

table(top$sig_adjP_lfc1)
table(top$sig_pval_lfc1)

table(top$sig_adjP_lfc2)
table(top$sig_pval_lfc2)

table(top$sig_adjP_lfc3)
table(top$sig_pval_lfc3)

write.table(top, file = "C:/Users/mefim/Downloads/rna_seq_diff_exp/GSE63885/DEG_limma_results.tsv",
            sep = "\t", quote = FALSE, row.names = TRUE)

#volcano plot
plot_volcano <- function(df, lfc_threshold, sig_col, title) {
  sig_genes <- subset(df, df[[sig_col]] == "+")
  
  ggplot(df, aes(x = logFC, y = -log10(P.Value), color = .data[[sig_col]])) +
    geom_point(alpha = 0.8, size = 1.5) +
    scale_color_manual(values = c("grey", "red")) +
    geom_hline(yintercept = -log10(pvalue_threshold), linetype = "dashed", color = "black") +
    geom_vline(xintercept = c(-lfc_threshold, lfc_threshold), linetype = "dashed", color = "black") +
    labs(title = title, x = "Log Fold Change", y = "-Log10 P-value") +
    theme_minimal() +
    theme(legend.position = "none") +
    geom_text_repel(data = sig_genes,
                    aes(label = rownames(sig_genes)), size = 3, max.overlaps = 10)
}

plot_volcano(top, 1, "sig_pval_lfc1", "Volcano Plot |LogFC| > 1")
plot_volcano(top, 2, "sig_pval_lfc2", "Volcano Plot |LogFC| > 2")
plot_volcano(top, 3, "sig_pval_lfc3", "Volcano Plot |LogFC| > 3")


