---
layout: post
title: Differential expression for newcomers
math: true
permalink: newcomers_de
tags: stat_ml single_cell
---

This post might be for you if: 

- you or your colleagues recently measured quantities of tens of thousands of (CpG sites, chromatin regions, transcripts, proteins, metabolites) in each of two conditions. 
- you want a list of the (CpG sites, chromatin regions, transcripts, proteins, metabolites) that differ with high confidence, so you've decided to do some formal stats. 
- you are vaguely aware of a large, intimidating body of stats-heavy literature on this problem.
- you would like to have a coffee with someone in that field and get the big picture.

Attention conservation notice: if you think you have a pretty robust signal and you don't actually need formal stats, then you should probably compute log fold changes (!) and call it a day. You can always re-visit my post if your reviewers demand q-values. Otherwise ... 

> (!) Just please make it log2 or log10, not natural log, so I don't need a calculator to read your figures. 

### Due diligence 

... please proceed after consulting this checklist.

- ☑ I have replicates. Honest-to-god replicates, having as little in common with each other as they do with rest of the stuff I want to apply my findings to. 
- ☑ My experimental design varies a single factor of interest, and it's the only way my groups differ, OR I blocked my samples like 

        WT June 11,      KO June 11
        WT rep2 June 24, KO rep2 June 24
         
    not 
    
        WT June 11, WT rep2 June 11
        KO June 24, KO rep2 June 24
- ☑ I have done enough exploratory data analysis to look for outliers that might not reflect the biology I am interested in.
- ☑ I didn't "double dip": the demarcation of groups I'm comparing is independent of my molecular measurements. Or, if it's from clustering of single cells into groups, the clusters are stupidly obvious to both humans and algorithms (blood versus epithelium) and not subjective or fuzzy (anything to do with motherfucking pseudotime).

All set? Great!

### Normalization

Normalization is a necessary evil. I wish all molecular assays would give counts per cell or counts per cubic microliter with minimal processing and minimal confounding by technical factors, but they don't. In particular, detected counts of any given molecule in a sequencing assay depend not only on the number present in the sample, but also on the rate of detection. Rate of detection varies substantially from sample to sample (and, in single-cell data, from cell to cell). For example, in single-cell DNA sequencing assays such as ATAC or ChIP, there's only 2 (maybe 4) copies of the DNA in each cell, but the total fragments per cell is highly dispersed, not tightly clumped around 2n and 4n for any value of n. Here are three choices for how to deal with this. 

- Don't deal with it. This is probably a bad choice for you, but it's possible to learn certain interesting things from this vantage: certain cell types [do just have more mRNA](https://www.biorxiv.org/content/10.1101/2021.12.13.472426v1).  
- Divide by total counts ("library size"): This is conceptually simple. Scale all cells or all samples to the same total. The problem is that if 100 genes go up under your treatment, with no other changes, then after normalization, you'll see 100 genes go up and G-100 genes go down (where G is the total number of genes measured). By analogy, a basket with 5 apples, 5 bananas, and 5 oranges changes to a basket with 5 bananas and 5 oranges. Only the apples have changed, but when scaled by num fruits, it's now 50% bananas instead of 33%. 
- "Trimmed mean of M-values": scale each sample by a factor that assumes most genes don't change, but some might. This fixes the above "50% bananas" problem. The method is explained more, and benchmarked on housekeeping genes, [here](https://genomebiology.biomedcentral.com/articles/10.1186/gb-2010-11-3-r25). Its single-cell RNA descendant is [scran](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0947-7). To me, this is the clear winner for most users. 

 I don't think there is a single-cell ATAC equivalent of TMM yet, which might be why single-cell ATAC normalization sucks at removing detection efficiency effects. (The top principal component is ususally highly correlated with the number of reads.)

What to do with the output of these methods for size factor estimation? Sometimes you take the sample-size or cell-size factors from normalization and immediately divde your counts by the size factors. Other times, you stash the size factors for further use, because flipping a coin 100 times (size factor) and getting 10 heads (count) is not exactly the same as flipping it ten times (size factor) and getting one head (count). This is usually folded into a regression model using an [offset](https://stats.stackexchange.com/questions/11182/when-to-use-an-offset-in-a-poisson-regression). 

#### Things other people mean when they say "normalization"

Usage varies, and you gotta clarify the scope every time you use the term "normalization." To me, normalization begins and ends with turning raw data into an interpretable measure of relative abundance with the best possible mitigation of confounding by technical factors such as capture efficiency. But many people also want their normalization procedures to yield output with convenient statistical properties. Specifically, people might want each gene to have the same variance and to look roughly Gaussian. Success or failure in this more statistical type of normalization can strongly affect PCA, and you should think about whether you need to do it for your specific analysis. For differential expression, it is usually not necessary: many existing tools (see below) handle non-Gaussian data and non-constant variance natively.

### Formal stats 

For optimal estimation and testing, there's three things you usually want to take care of. Someone has usually already published on "how" to do it, so let me talk about "what?" and "why?" before I give refs on "how". 

#### Mean-variance relationship

If you love Poisson distributions, skip two paragraphs and go to "How might this blow up in your face?". Otherwise, when you flip a coin a million times, each flip having probability 1/10,000 of coming up heads, the number of heads follows a statistical law called a Poisson distribution. When you prep a sample with a million copies of your molecule and expect to detect ~100 of them (all independent), same deal. Lots of molecular measurements are either Poisson, or Poisson layered on top of some other sources of variation. 

Poisson probabilities possess a peculiar property: the standard deviation is the square root of the mean. So if group 1 has higher levels of Transcript A than group 2, measurements in group 1 will be not only larger, but also noisier (more dispersed). I skipped a class at UW so I actually don't know whether ignoring this causes excess false positives, loss of power, or both, but you can probably do better than me by consulting your friendly local applied regression textbook, and in the meanwhile, you should try to get the mean-variance relationship right.

**How might this blow up in your face?** Some data look Very Not Poisson: the standard deviation does not even increase with the mean ([example](https://support.bioconductor.org/p/9139906/)). In this scenario, you've got other options. For example, any method built around a negative binomial distribution assumes $\sigma = \sqrt{\mu + \phi \mu^2}$ where $\sigma$ is the standard deviation, $\mu$ is the mean, and $\phi$ is a "dispersion parameter" typically estimated from the data. See "Pointers" below for even more choices. The punchline, and the way to choose among these choices: look for a mean-variance relationship and check that the method you're using models it well.

#### Mean-variance relationship is hard to talk about in multivariate problems

Compared to textbook applied regression with a single target variable, there's a weird communication barrier surrounding the mean-variance relationship in multi-variable analyses like this. It could be:

1. "within-gene": considering any single gene, groups of samples with higher mean have higher standard deviation. 
2. "across-genes": genes with higher means have systematically higher or lower standard deviations than even your model from (1.) would expect.

Popular tools like edgeR and deseq2 address this by estimating a separate dispersion parameter for each gene. This is great, because you can accommodate unexpected biological or measurement error effects that affect high-expressed and low-expressed genes differently. But this is also hard, because you probably have rather few replicates -- maybe 2, or 3, or 5. No matter how you slice it, this makes it hard to estimate dispersion or standard deviation. How can we accommodate this need, despite low sample count?


#### Shrinkage: sharing is caring 

For this awful situation of estimating the standard deviation from just 4 replicates, sharing information between genes helps. The best standard deviation estimate is usually a compromise between a gene-specific value and a value shared across all genes. Slightly fancier methods will share information only among genes that have a similar expression level, and they may identify outlier genes and not shrink those estimates. [Here](http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#dispersion-plot-and-fitting-alternatives) is an example plot showing dispersion estimates, most of which have been "shrunk" towards other genes with similar mean expression. 

#### Proper handling of "pseudoreplication"

Multiple cells from one organism or culture dish are not independent replicates. If you have four 10X runs with 10,000 cells each, then you have 4 replicates, not 40,000. In the early days, probably the best you could do was sum up the counts from the cells within each sample. Nowadays, there is scalable software for hierarchical models that address pseudoreplication natively. This is especially helpful when some samples have lots more cells than others. To the extent that variation is cell-to-cell instead of sample-to-sample, a well-specified hierarchical model can correctly give more credence to samples with more cells, while still not losing sight of the small number of truly independent replicates. 

### Pointers to software

Ok, thanks for the coffee. Now that you know what you're doing and why, you naturally want to know **how** to do all this. Fortunately, you do not have to implement all of these features yourself from scratch. You have access to highly sophisticated existing software that can offer the aforementioned features even on a tight timeframe. (If you'd like me to add some software to this list, I would be open to that. Email me or tweet @ekernf01.)

#### Classics

Here are some specific methods that share many or all the features discussed above.

microarray-oriented Gaussian mixed models

- limma

RNA-seq-oriented negative binomial models

- [nebula-hl](https://www.nature.com/articles/s42003-021-02146-6)
- [edgeR](http://bioconductor.org/packages/devel/bioc/vignettes/edgeR/inst/doc/edgeRUsersGuide.pdf)
- [deseq2](http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html)

Models designed for binary data (like allele-specific expression or methylation status)

- [DSS](https://academic.oup.com/bioinformatics/article/32/10/1446/1743267)
- [unnamed method](https://academic.oup.com/nar/article/42/8/e69/1074350)

#### Off the beaten path

You may run into certain types of trouble that require extensions of the work above, or alternatives to it.

- CRISPR perturbations hard to measure? Try [conditional randomization](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-021-02545-2).
- Double-dipping with differential expression on a pseudotime axis? Try [Poisson splitting](https://arxiv.org/abs/2207.00554).
