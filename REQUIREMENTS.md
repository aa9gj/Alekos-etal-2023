# Requirements

This document describes the software dependencies required to run the analysis.

## R Version

- **Minimum**: R 4.0.0
- **Recommended**: R 4.2.0 or higher

## Required Packages

### From CRAN

| Package | Purpose |
|---------|---------|
| dplyr | Data manipulation |
| tidyverse | Data wrangling and visualization (includes ggplot2, tidyr) |
| data.table | Efficient data manipulation |
| pheatmap | Heatmap visualization |

### From Bioconductor

| Package | Purpose |
|---------|---------|
| DESeq2 | Differential expression analysis |
| SummarizedExperiment | Data structures (installed as DESeq2 dependency) |

## Installation

### Option 1: Manual Installation

Run these commands in R:

```r
# Install CRAN packages
install.packages(c("dplyr", "tidyverse", "data.table", "pheatmap"))

# Install Bioconductor manager
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

# Install DESeq2 and dependencies
BiocManager::install("DESeq2")
```

### Option 2: Using renv (Recommended for Reproducibility)

If you have `renv` installed, you can restore the exact package versions:

```r
# Install renv if needed
install.packages("renv")

# Initialize renv in the project
renv::init()

# Install packages
renv::install(c("dplyr", "tidyverse", "data.table", "pheatmap"))
renv::install("bioc::DESeq2")

# Create a snapshot
renv::snapshot()
```

## Verifying Installation

Run this code to verify all packages are installed correctly:

```r
# Check if all required packages are available
required_packages <- c("DESeq2", "dplyr", "tidyverse", "data.table", "pheatmap")

check_packages <- function(packages) {
  for (pkg in packages) {
    if (requireNamespace(pkg, quietly = TRUE)) {
      cat(sprintf("✓ %s: installed\n", pkg))
    } else {
      cat(sprintf("✗ %s: NOT INSTALLED\n", pkg))
    }
  }
}

check_packages(required_packages)
```

## Troubleshooting

### DESeq2 Installation Issues

If you encounter issues installing DESeq2:

1. **Update Bioconductor**:
   ```r
   BiocManager::install(version = "3.18")  # or latest version
   ```

2. **Install system dependencies** (Linux):
   ```bash
   # Ubuntu/Debian
   sudo apt-get install libcurl4-openssl-dev libssl-dev libxml2-dev

   # CentOS/RHEL
   sudo yum install libcurl-devel openssl-devel libxml2-devel
   ```

3. **Install system dependencies** (macOS):
   ```bash
   brew install openssl curl libxml2
   ```

### Package Version Conflicts

If you encounter version conflicts, try:

```r
# Update all packages
update.packages(ask = FALSE)

# Or use a fresh R library
.libPaths(c("./renv/library", .libPaths()))
```

## Session Info

For reference, the analysis was developed with these package versions:

```
R version 4.2.x
DESeq2 1.38.x
dplyr 1.1.x
tidyverse 2.0.x
data.table 1.14.x
pheatmap 1.0.x
```

Note: The exact session information is captured when you run the analysis and saved to `results/session_info.txt`.
