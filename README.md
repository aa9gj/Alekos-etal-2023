# RNAseq Differential Expression Analysis

Analysis code for the RNAseq portion of the manuscript:

**"Mitochondrial β-oxidation of adipose-derived fatty acids by osteoblast fuels parathyroid hormone-induced bone formation"**

Published in *JCI Insight*: [Alekos et al 2023](https://insight.jci.org/articles/view/165604)

## Overview

This repository contains the code and data for differential expression analysis of calvarial mouse osteoblasts comparing PTH (parathyroid hormone) treatment versus vehicle control. The analysis uses DESeq2 for identifying differentially expressed genes.

## Experimental Design

| Group | Treatment | Samples |
|-------|-----------|---------|
| Treatment | PTH (Parathyroid Hormone) | Con_PTH_1, Con_PTH_2, Con_PTH_3, Con_PTH_4 |
| Control | Vehicle | Con_Veh_1, Con_Veh_2, Con_Veh_3, Con_Veh_4 |

## Repository Structure

```
Alekos_etal_2023/
├── riddle_2022_analysis.R     # Main analysis script
├── gene_count_matrix.csv      # Raw gene count data (47,706 genes × 8 samples)
├── phenotypes.csv             # Sample metadata
├── multiqc_report.html        # Quality control report
├── REQUIREMENTS.md            # Package dependencies
├── README.md                  # This file
└── results/                   # Generated output (after running analysis)
    ├── diff_exp_sig_results.csv
    └── session_info.txt
```

## Requirements

- **R version**: 4.0 or higher
- **Required packages**:
  - DESeq2
  - dplyr
  - tidyverse
  - data.table
  - pheatmap

See [REQUIREMENTS.md](REQUIREMENTS.md) for installation instructions.

## Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/aa9gj/Alekos_etal_2023.git
   cd Alekos_etal_2023
   ```

2. **Install R dependencies** (if not already installed)
   ```r
   install.packages(c("dplyr", "tidyverse", "data.table", "pheatmap"))

   if (!requireNamespace("BiocManager", quietly = TRUE))
       install.packages("BiocManager")
   BiocManager::install("DESeq2")
   ```

3. **Run the analysis**

   Open RStudio and open the project file `Riddle_2022_analysis.Rproj`, then run:
   ```r
   source("riddle_2022_analysis.R")
   ```

   Or from the command line:
   ```bash
   Rscript riddle_2022_analysis.R
   ```

## Analysis Pipeline

The analysis script performs the following steps:

1. **Data Loading**: Read count matrix and sample metadata
2. **Normalization**: DESeq2 size factor normalization
3. **Quality Control**:
   - Variance stabilizing transformation (VST)
   - Sample correlation heatmap
   - PCA plots
4. **Differential Expression**:
   - DESeq2 negative binomial model
   - Dispersion estimation
   - Wald test for treatment vs control
5. **Results Export**:
   - Significant genes (padj < 0.05)
   - Session information for reproducibility

## Data Files

### gene_count_matrix.csv
- Raw gene counts from RNA-seq
- Rows: 47,706 genes (ENSEMBL ID | Gene Name format)
- Columns: 8 samples

### phenotypes.csv
- Sample metadata
- Columns: Sample name, Condition (treatment/control)

### multiqc_report.html
- Quality control metrics from MultiQC
- Open in a web browser to view

## Output

After running the analysis, results are saved to the `results/` directory:

- **diff_exp_sig_results.csv**: Differentially expressed genes (padj < 0.05)
  - Columns: gene_id, gene_name, baseMean, log2FoldChange, lfcSE, stat, pvalue, padj
- **session_info.txt**: R session information for reproducibility

## Citation

If you use this code or data, please cite:

> Alekos NS, et al. Mitochondrial β-oxidation of adipose-derived fatty acids by osteoblast fuels parathyroid hormone-induced bone formation. *JCI Insight*. 2023. DOI: [10.1172/jci.insight.165604](https://doi.org/10.1172/jci.insight.165604)

## License

This project is available for academic and research use. Please cite the original publication when using this code or data.

## Contact

For questions about this analysis, please open an issue on GitHub or contact the corresponding authors of the publication.
