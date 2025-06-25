---
layout: post
title: Five flavors of stratified LD score regression: part 3, cranberry
math: true
tags: stat_ml
permalink: cranberry
---

Stratified linkage disequilibrium score regression (S-LDSC) is a workhorse technique at the intersection of human genetics and functional genomics, but its exposition is heavily genetics-coded. In cell biology and functional genomics, it is less well-known and well-understood than would be optimal. This post is part of a series introducing many flavors of S-LDSC for the newcomer. 

1. [Vanilla](vanilla) (original LDSC)
2. [Strawberry](strawberry) (stratified LDSC)
3. `this post -->` [Cranberry](cranberry) (cross-trait LDSC)
4. [Lime](lime) (signed LDSC)
5. [Melon](melon) (mediated expression score regression)

### Motivation

Correlation is treacherous. Let's say you think that Crohn's disease is correlated with rheumatoid arthritis. So what? Maybe those are just the patients with access to specialists. To make the case that there's a real interesting common biological mechanism here, you need to refine your analysis. For example, maybe you could somehow isolate and separately analyze inborn genetic risk for Crohn's and inborn genetic risk for rheumatoid arthritis. These are present at birth, regardless of any selection effect or environmental exposure, so a genetic correlation would be more convincing evidence for biochemical commonalities between two phenotypes. How do we define and estimate genetic correlations? Enter [cranberry (cross-trait) LDSC](https://pmc.ncbi.nlm.nih.gov/articles/PMC4797329/). 

(Note: there existed other methods to estimate genetic correlations prior to cross-trait LDSC. It has a practical privacy advantage though: you can run it without access to individual-level data.)

### Key formulas 

Given one trait with standardized per-SNP association estimates $\hat \beta_j$, we built a model for $E[\chi_j^2] = E[N\hat \beta_j^2]$. Given two traits with per-SNP association estimates $\beta_{1j},\beta_{2j}$, it's not a huge stretch to now build a model for $E[\beta_{1j}\beta_{2j}]$, and that's exactly what they do.

$$E[\beta_{1j}\beta_{2j}] = \sqrt{N_1N_2}\rho_g\ell_j/M + \rho N_s/\sqrt{N_1N_2}$$

Ok, what's new in here?

- There are now two sample sizes, $N_1$ and $N_2$, and the size of the sample overlap is $N_s$. 
- $\rho_g$ is the genetic covariance. This is muddled by a definition that seems, to me, to mistreat a crucial scale parameter. But near as I can tell, this is a theoretical parameter defined as $\sum_j \beta_{1j}\beta_{2j}$, where $\beta_{tj}$ is the true association of SNP j with phenotype t, scaled to a variance of 1. This $\rho_g$ is the main unknown parameter estimated by cranberry (cross-trait) ldsc.
- $\rho$ is the correlation between the two phenotypes among the subjects present in both studies. If you can't compute it directly, then you can estimate it from the summary statistics in the usual way (intercept of a regression). 

The formula says that two genetic effects of a SNP j will appear more similar in a way that is proportional to how genetically similar the underlying traits are and how big the local LD block is, with a correction for sample overlap. I have no idea why the sample sizes are floating around like that, although if you wonder why the number of SNPs $M$ appears where it does, that is explained in the derivations. 

When the two traits and the two studies are identical, the right hand side reduces to $N\ell_jh_g^2/M + 1$, the original formula (without population stratification).

### Empirical results

They applied xt-LDSC to 24 traits. They find some obvious ones: birth length and birth weight are genetically correlated; HDL and triglycerides are (genetically) anticorrelated; Crohn's and ulcerative colitis are (genetically) correlated. They also find some big correlations that seem less obviously *genetic*: education anti-correlates with both smoking and triglycerides. A later study found that [cross-trait assortative mating can severely bias genetic correlation estimates](https://pubmed.ncbi.nlm.nih.gov/36395242/), so I will not put too much stock into these results, but xt-LDSC is still an important building block. 

### Stay tuned for part 4: lime.

The [next part of this series](lime) is on lime (signed) linkage disequilibrium score regression. 

### Notes on derivation of cranberry LDSC

A key justification for the nomenclature is that $\rho_g$ equals the correlation between $y_{g1}$ and $y_{g2}$ where $y_g$ is a prediction of the phenotype based solely available genotypes. In other words: given only genetic effects, with no influence of environment or selection bias etc., this is how correlated the phenotypes would be. This justification is Lemma 1 and the proof is quite quick. 

The core assumption is $Cov[(\beta_1, \beta_2)] = \rho_g/M$. The derivation is mostly pretty straightforward, except section 1.1 equation 5:

$$\frac{1}{\sqrt{N_1N_2}}E[Y_j^TYZ_j^TZ] = \ell_j + \frac{MN_s}{\sqrt{N_1N_2}}$$

$Y$ and $Z$ are standardized genotypes. They cover the same SNPs but potentially different individuals. So part of the confusion is that $Y$ and $Z_j$ are not conformable! Starting from equation 3, the $Z_j^TZ$ term should really be transposed. Getting past that, $Y_j^TY$ is a vector of correlations between genotype $j$ and all genotypes, which we might reasonably call $\hat r_{jY}$. Applying the same logic to $Z$, we now have a dot product $\hat r_{jY}^T \hat r_{jZ}$, which is a sum $\sum_k \hat r_{jkY} \hat r_{jkZ}$ that looks very similar to an LD score. ...

... So where does the $\frac{MN_s}{\sqrt{N_1N_2}}$ come from?? I see no explanation. With all three of vanilla, strawberry, and cranberry published in 2015, this must have been second nature to Bulik-Sullivan and Finucane by now. It's not second nature to me at the moment, but I notice $\hat r_{jkZ}$ is a sample correlation coefficient, and in vanilla supplement eqn 1.7, 1.8 [(pdf)](https://static-content.springer.com/esm/art%3A10.1038%2Fng.3211/MediaObjects/41588_2015_BFng3211_MOESM39_ESM.pdf), they explain that this sample estimate is higher than the true value $r_{jkZ}$, which leaves room for an extra term to pop out. Bias of the sample correlation coefficient seems to be hard but well-studied ([CV thread](https://stats.stackexchange.com/questions/220961/is-the-sample-correlation-coefficient-an-unbiased-estimator-of-the-population-co)).