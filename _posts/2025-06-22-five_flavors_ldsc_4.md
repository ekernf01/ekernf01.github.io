---
layout: post
title: Five flavors of stratified LD score regression (Part 4, Lime)
math: true
tags: stat_ml
permalink: lime
---

Stratified linkage disequilibrium score regression (S-LDSC) is a workhorse technique at the intersection of human genetics and functional genomics, but its exposition is heavily genetics-coded. In cell biology and functional genomics, it is less well-known and well-understood than would be optimal. This post is part of a series introducing many flavors of S-LDSC for the newcomer. 

1. [Vanilla](vanilla) (original LDSC)
2. [Strawberry](strawberry) (stratified LDSC)
3. [Cranberry](cranberry) (cross-trait LDSC)
4. `this post -->` [Lime](lime) (signed LDSC)
5. [Melon](melon) (mediated expression score regression)

### Motivation

Suppose you are a functional genomics wizard AND a deep learning practitioner. You have not only chromatin data, but also sequence-to-function models that make *directional* predictions for local molecular effects of specific genetic variants. You want to see how well you model's predictions about specific alleles align with complex disease risk contributed by those alleles. You might run stratified LDSC, but how? Put all effects in the same set $C$? Have a set $C_+$ for positive effects and a set $C_-$ for negative effects? 

Close. You would run [lime-flavored (signed) LDSC](https://pubmed.ncbi.nlm.nih.gov/30177862/). 

### Key formulas 

$E[\hat \alpha | v] = r_f\sqrt{h^2_g}Rv$

You may notice that there is no $\chi$ and no $^2$; so; what is this saying?

- $\hat \alpha_j$ is the correlation between trait and genotype. Because we care about effect directions this time, we cannot square this. But since the genotypes and phenotypes are usually normalized to have mean 0 and variance 1, this correlation is the same type of coefficient estimate or summary statistic we have been dealing with in every flavor of LDSC.
- $R$ is the LD matrix. Because we care about effect directions this time, we cannot use $r^2$; we need to use $r$. You can think of this matrix as a blurring operator that takes the true effects and smears them out over a whole LD block. 
- $v$ is the vector of predicted molecular effects, scaled to have variance 1.
- $r_f$ is the correlation between the true genetic effects on the phenotype and the molecular effects predicted by the sequence model. Since everything is scaled to variance 1, you can also think of this as a regression coefficient. This is what the method estimates.

A more unexpected part of this paper is in the significance testing. 

### Significance testing and nuisance effects

Less common alleles are often less for a reason. At baseline, even without specific molecular-level explanations, rare alleles would tend to have a directional (deleterious) effect on a typical polygenic trait. To control for this, Reshef et al. widen $v$ into a matrix by appending 5 extra columns encoding discretized allele frequency for each genotype. 

They quantify significance of estimates for $r_f$ by randomly flipping signs of large contiguous blocks of entries of v and re-running the estimation. The null model holds that $Pr(\hat \alpha|v)$ does not depend on $sign(v)$; this is an unusual assumption that I have not seen anywhere else. This method allows them to maintain calibration even when large predicted effects co-localize with important regions that the model has no knowledge of, which is very different from s-LDSC.

### Empirical results

They deployed the model using annotations from deep-learning predictions of transcription factor binding for 382 TF's. Using transcription as a phenotype, they verified that several TF's tend to activate transcription as expected. Then they analyzed diseases and complex traits. Among the findings was some really interesting novel evidence for involvement of IRF1 in Crohn's disease. The IRF1 locus hosts SNP's contributing Crohn's risk, but it is densely packed with genes, and the cause of the association is not clear. This analysis aggregates smaller effects over the whole genome from places where IRF1 *binding sites* are affected by genetic variants, so it is not subject to the same fine-mapping difficulty.

### Stay tuned for part 5: ???.

The [next part of this series](???) is on ??? (???) linkage disequilibrium score regression. 


### Notes on derivation of lime LDSC

No notes.
