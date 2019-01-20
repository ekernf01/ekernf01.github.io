## Why feature selection?

A typical workflow for analysis of single-cell RNA-seq count matrices starts with the analyst estimating dispersion (excess variability) for each gene, then aggressively culling the gene list. It's typical to go from a count matrix with 15k to 20k genes down to only 1,000 or so genes. 

Why? Aren't you worried you'll miss something?

It turns out, no surprise, there's work on this topic. In this post I want to introduce ideas from [this paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2898454/#FD16) (Johnstone and Lu 2009, "On Consistency and Sparsity for Principal Components Analysis in High Dimensions"). Beginning with assumptions that seem biologically reasonable to me, they show that PCA works best when you use only features with excess variance. 