---
layout: post
title: Five flavors of stratified LD score regression (Part 2, Strawberry)
math: true
tags: stat_ml
permalink: strawberry
---

Stratified linkage disequilibrium score regression (S-LDSC) is a workhorse technique at the intersection of human genetics and functional genomics, but its exposition is heavily genetics-coded. In cell biology and functional genomics, it is less well-known and well-understood than would be optimal. This post is part of a series introducing many flavors of S-LDSC for the newcomer. 

1. [Vanilla](vanilla) (original LDSC)
2. `this post --->` [Strawberry](strawberry) (stratified LDSC)
3. [Cranberry](cranberry) (cross-trait LDSC)
4. [Lime](lime) (signed LDSC)
5. [Melon](melon) (mediated expression score regression)

### Motivation

Suppose you are a functional genomics wizard, and you have [identified 180,000 open chromatin regions in endometrial cells](https://pubmed.ncbi.nlm.nih.gov/29259032/). You want to see if they are more likely than other regions to harbor [alleles affecting endometriosis risk](https://www.medrxiv.org/content/10.1101/2024.11.26.24316723v1.full). Naively, you might take the 132 fine-mapped causal variants (this is the highest-resolution result of the endometriosis GWAS) and check how many are in open chromatin regions. Hopefully, it exceeds the expected base rate, based on the total size of the open chromatin regions versus the total size of the human genome. But, this approach seems weak. First, because fine-mapping is hard, and LD blocks are often much bigger than open chromatin regions. Second, because endometriosis may be affected by thousands of smaller genetic effects that did not reach the GWAS significance threshold, but may contain signal in aggregate.     

Strawberry (stratified) LDSC, from [Finucane et al. 2015](https://www.nature.com/articles/ng.3404), accounts for LD natively, so no fine-mapping is required, and it can detect aggregate effects of many loci that each individually cannot reach genome-wide significance. 

### Key formulas 

Let $C_1$ denote the set of SNPs in endometrial open chromatin regions and let $C_2$ denote the set of SNPs not in open chromatin regions. As in [vanilla](vanilla), $\chi^2$ is defined as $N\hat \beta^2$, but different from vanilla, $\ell$ now gets a subscript, meaning the sum ranges over a limited set of SNPs: $\ell_{j,C} \equiv \sum_{k\in C} r_{jk}^2$. And there is a parameter for each set, $\tau_C$, controlling the variance of genetic effects from loci in $C$ (it's the per-SNP heritability).  

$E[\chi^2] = N\sum_{C\in C_1, C_2} \tau_C \ell_{j,C} + Na + 1$

The quantities estimated by strawberry LDSC are the $\tau_C$'s and $a$ and the rest are inputs. 

### Empirical results

Finucane et al. load up the model with 53 annotations based on simple properties (e.g. coding vs noncoding; conserved sequence), chromatin state (e.g. H3K27ac often found in enhancers), and other telltale signs of enhancers (e.g. CAGE-seq). They run s-LDSC on GWAS summary statistics for 17 traits, e.g. height, LDL, Crohn's disease. Conserved sequence was heavily enriched for genetic effects, and coding sequences and enhancers were also enriched. They also loaded up the model with some cell-type-specific annotations and found sensible results: Crohn's and rheumatoid arthritis most enriched for blood/immune-specific annotations; fasting glucose most enriched for pancreas-specific annotations; schizophrenia and bipolar most enriched for CNS-specific annotations. 

### Stay tuned for part 3: cranberry.

The [next part of this series](cranberry) is on cranberry (cross-trait) linkage disequilibrium score regression. 


### Notes on derivation of strawberry LDSC

The underlying assumption is really simple: the true per-SNP effects $\beta$ are assumed to follow $\beta_j \sim N(0, \sum_{C|j \in C}\tau_C)$. The derivation is simpler than [vanilla](vanilla), with no discussion of population structure, and the main subtlety is the precise meaning of $\tau_C$, which depends on whether your sets overlap or not. 

This method features standard errors and significance tests, which rely on a resampling stratagem called the jackknife. I am not sure where to read a full treatment of the jackknife, but [here](https://personal.utdallas.edu/~herve/abdi-Jackknife2010-pretty.pdf) is a basic intro. The ldsc jackknife code is available [here](https://github.com/bulik/ldsc/blob/master/ldscore/jackknife.py). It revolves around "pseudovalues" which take the form $B\hat \tau - (B-1)\hat \tau_b$, where B is the number of blocks, $\hat\tau$ is a full-data estimate, and $\hat\tau_b$ is an estimate from data with block $b$ deleted. The core assumption is that effect size estimates are i.i.d., and LD violates this assumption, which is (I think) why resampling must be done in blocks.