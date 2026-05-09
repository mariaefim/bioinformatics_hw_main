import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

star = pd.read_csv("/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/res_star/RNA_ReadsPerGene.out.tab", sep="\t", header=None, names=["gene_id", "unstranded", "forward", "reverse"])
star = star[star["gene_id"].str.startswith("ENSG")]
star["sum_34"] = star["forward"] + star["reverse"]

htseq = pd.read_csv("/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/htseq_counts.txt", sep="\t", header=None, names=["gene_id", "count"])
htseq = htseq[htseq["gene_id"].str.startswith("ENSG")]

merged_2 = pd.merge(star[["gene_id", "unstranded"]], htseq, on="gene_id")
merged_34 = pd.merge(star[["gene_id", "sum_34"]], htseq, on="gene_id")

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 8))

#график 1-col_2
ax1.scatter(merged_2["unstranded"], merged_2["count"], alpha=0.3, s=5, color="red")
max_val1 = max(merged_2["unstranded"].max(), merged_2["count"].max())
ax1.plot([0, max_val1], [0, max_val1], "--", color="gray", linewidth=1, label="y=x")
corr1 = merged_2["unstranded"].corr(merged_2["count"])
ax1.set_xlabel("STAR (col_2)")
ax1.set_ylabel("HTSeq")
ax1.set_title(f"STAR (col_2) vs HTSeq counts\nPearson r = {corr1:.4f}", fontsize=14)
ax1.legend()

#график 2-col_3+4
ax2.scatter(merged_34["sum_34"], merged_34["count"], alpha=0.3, s=5, color="red")
max_val2 = max(merged_34["sum_34"].max(), merged_34["count"].max())
ax2.plot([0, max_val2], [0, max_val2], "--", color="gray", linewidth=1, label="y=x")
corr2 = merged_34["sum_34"].corr(merged_34["count"])
ax2.set_xlabel("STAR (col_3 + col_4)")
ax2.set_ylabel("HTSeq")
ax2.set_title(f"STAR (col_3 + col_4) vs HTSeq counts\nPearson r = {corr2:.4f}", fontsize=14)
ax2.legend()

plt.tight_layout()
plt.savefig("/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/star_vs_htseq_both.png", dpi=150)
plt.show()
