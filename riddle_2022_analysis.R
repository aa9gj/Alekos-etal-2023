# ==============================================================================
# Riddle 2022 Differential Expression Analysis
# ==============================================================================
# Analysis code for the RNAseq portion of Alekos et al 2023
# "Mitochondrial B-oxidation of adipose-derived fatty acids by osteoblast
# fuels parathyroid hormone-induced bone formation"
# Published in JCI Insight: https://insight.jci.org/articles/view/165604
#
# This script performs differential expression analysis comparing PTH-treated
# calvarial mouse osteoblasts vs vehicle control using DESeq2.
# ==============================================================================

# Load required libraries
library(DESeq2)
library(dplyr)
library(tidyverse)
library(data.table)
library(pheatmap)

# ==============================================================================
# Data Loading
# ==============================================================================

# Read count data and sample metadata (using relative paths for reproducibility)
CountData <- read.csv("gene_count_matrix.csv", row.names = 1)
ColData <- read.csv("phenotypes.csv", row.names = 1)

# Verify samples match between count data and metadata
if (!all(rownames(ColData) %in% colnames(CountData))) {
  stop("Sample names in phenotypes.csv do not match columns in gene_count_matrix.csv")
}

# Reorder columns of count data to match metadata row order
reorder_idx <- match(rownames(ColData), colnames(CountData))
reordered_CountData <- CountData[, reorder_idx]

# ==============================================================================
# DESeq2 Object Creation and Normalization
# ==============================================================================

# Create DESeq2 dataset
dds <- DESeqDataSetFromMatrix(
  countData = reordered_CountData,
  colData = ColData,
  design = ~ Condition
)

# Estimate size factors for normalization
dds <- estimateSizeFactors(dds)

# Extract normalized counts
normalized_counts <- counts(dds, normalize = TRUE)
normalized_counts <- as.data.frame(normalized_counts)

# ==============================================================================
# Quality Control Visualizations
# ==============================================================================

# Variance stabilizing transformation for QC plots
vsd <- vst(dds, blind = TRUE)

# Extract matrix of transformed counts
vsd_mat <- assay(vsd)

# Compute correlation values between samples
vsd_cor <- cor(vsd_mat, vsd_mat)

# Plot sample correlation heatmap
pheatmap(vsd_cor, annotation = select(ColData, Condition))

# PCA plot of samples
plotPCA(vsd, intgroup = "Condition")

# Enhanced PCA plot with sample labels
se <- SummarizedExperiment(
  log2(counts(dds, normalized = TRUE) + 1),
  colData = colData(dds)
)
pca_plot <- plotPCA(DESeqTransform(se), intgroup = "Condition")
pca_plot + geom_label(aes(label = name), size = 2)

# ==============================================================================
# Differential Expression Analysis
# ==============================================================================

# Run DESeq2 analysis
dds <- DESeq(dds, betaPrior = FALSE)

# Plot dispersion estimates
plotDispEsts(dds)

# Extract results: treatment (PTH) vs control (Vehicle)
con_vs_treat <- results(
  dds,
  contrast = c("Condition", "treatment", "control"),
  alpha = 0.05
)

# Filter for significant results (padj < 0.05)
con_vs_treat_res <- subset(con_vs_treat, padj < 0.05)

# Summary of differential expression results
cat("\n========== Differential Expression Summary ==========\n")
cat("Treatment (PTH) vs Control (Vehicle)\n")
summary(con_vs_treat_res)

# ==============================================================================
# Export Results
# ==============================================================================

# Convert results to data frame and add gene annotations
con_vs_treat_res <- as.data.frame(con_vs_treat_res)
con_vs_treat_res <- setDT(con_vs_treat_res, keep.rownames = TRUE)[]
con_vs_treat_res <- separate(
  con_vs_treat_res,
  rn,
  into = c("gene_id", "gene_name"),
  sep = "\\|"
)

# Create output directory if it doesn't exist
if (!dir.exists("results")) {
  dir.create("results")
}

# Save significant differential expression results
write.csv(
  con_vs_treat_res,
  "results/diff_exp_sig_results.csv",
  quote = FALSE,
  row.names = FALSE
)

cat("\nResults saved to: results/diff_exp_sig_results.csv\n")

# ==============================================================================
# Session Information
# ==============================================================================

# Capture session info for reproducibility
sink("results/session_info.txt")
cat("Session Information\n")
cat("===================\n")
cat("Date:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")
sessionInfo()
sink()

cat("Session info saved to: results/session_info.txt\n")
cat("\n========== Analysis Complete ==========\n")
