---
layout: post
title: Mean squared error for estimates of differential expression
math: true
tags: single_cell grn stat_ml
permalink: mse_of_de
---

### Bias-variance tradeoffs for virtual cell evals are weird

Consider a Perturb-seq experiment with controls $Y_1 ... Y_C$, perturbation G applied to samples $Z_1 ... Z_C$, and other perturbations applied to samples $X_1 ... X_N$, with N>>C. Suppose control samples have mean expression $M$ and samples with perturbation $J$ have mean expression $M+D_J$. Which simple estimators of $M$ and $D_G$ have lower or higher MSE?

For M, you would naturally think to average the controls. But you can probably reduce MSE by including all the perturbed samples as well. Including perturbed samples does induce a bias. But when you have noisy measurements, you can reduce the noise a lot by including more samples. We gave a brief mathematical analysis in the [PEREGGRN paper](https://link.springer.com/article/10.1186/s13059-025-03840-y) supplement. The bias is plausibly outweighed by the reduction in variance, especially when the perturbation effects are weak and sparse and when there are few controls. Evals based on MSE might disadvantage a seemingly true model because it's too data-intensive to fit.

(This post is part of a series on prediction of gene expression in response to genetic perturbations, which is often called virtual cell modeling.)

- [Episode 1](perturbation-methods): methods circa mid-2024
- [Episode 2](perturbation-benchmarks): benchmarks circa early 2025
- [Episode 3](FM-refs-2025): a broader look at genomic foundation models (large-scale, multi-purpose neural networks trained on DNA or RNA data)
- [Episode 4](virtual-cell-june-2025): new developments circa June 2025
- [Episode 5](mse_of_de): a snippet on weird behavior of MSE (this post)
- [Episode 6](target_gene_shenanigans): a rant on biological versus technical effects


### When Systema's "centroid" approach has better theoretical MSE than controls-only

What about the best MSE for $D_G$? Let's consider two estimators: "simple" (treatment mean minus control mean) and "mean-centered" (treatment mean minus everything-else mean). 

- For "simple", the formula is $(1/C)\sum_{i=1}^C Z_i - (1/C)\sum_{i=1}^C Y_i$, the bias is 0, and the variance is $\sigma^2/C + \sigma^2/C$. (Let's assume every sample has independent error with variance $\sigma^2$.) 
- For "centroid", the formula is $(1/C)\sum_{i=1}^C Z_i - (1/N)\sum_{i=1}^N X_i$, the bias is $(1/N)\sum_{i=1}^N D_{J(i)}-D_G$, and the variance is $\sigma^2/C + \sigma^2/N$. 
- (Let's assume every sample has independent error with variance $\sigma^2$.) 

Now, when does "centroid" have lower MSE? This happens if 

$$[(1/N)\sum_{i=1}^N(D_{J(i)}-D_G)]^2 < \sigma^2(1/C-1/N)$$

So, if the perturbations have similar outcomes (small mean $D_{J(i)}- D_G$), or the variance is high (large $\sigma^2$), or the controls are a small proportion of the experiment (large $1/C-1/N$), then the "centroid" strategy might have better MSE than the "simple" strategy. 

### This is additional justification for Systema's approach, beyond what they discuss

This simple derivation provides additional justification for the [Systema benchmarks](https://www.nature.com/articles/s41587-025-02777-8), which offer the "centroid" estimator (or something very similar) as a new and refined view of virtual cell performance. Systema's starting point is that simple baselines frequently outperform GEARS and scGPT according to simple evaluations. They attribute the phenomenon to systematic confounders or perturbation selection bias. Typical perturb-seq's circa 2024 are designed around a biological common thread. The most extreme examples are wrong-answers-only screens where all perturbations are chosen to be toxic. Since the perturbation effects are similar, $D_{J(i)}- D_G$ is small, and "centroid" is a better ground truth than "simple".

The above derivations also suggest that Systema's "centroid" estimator could remain valuable even in settings with no systematic confounding and no selection bias in the perturbations. For example, the "centroid" strategy could still be an improvement even if every gene is perturbed. Even if $D_{J(i)}- D_G$ is kinda big, "centroid" can win out as long as there's high noise (big $\sigma^2$) and a low number of controls (big $1/C$).