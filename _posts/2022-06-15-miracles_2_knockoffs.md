---
layout: post
title: Four miracles of modern frequentist statistics
math: true
permalink: miracles_2
tags: stat_ml
---

Over the past N years I've heard lots of smart people that I respect say things like "inside every frequentist there's a Bayesian waiting to come out" and "Everybody who actually analyzes data uses Bayesian methods." These people are not seeing what I'm seeing, and that's a shame, because what I'm seeing is frankly astonishing.

Here's post #2 of 4 on tools from modern frequentist statistics, each with a distinctive advantage that nearly defies belief in terms of how much can be accomplished on the basis of very limited or seemingly wrong building blocks. It's not just about the prior anymore: each of these methods works *when you don't even know the likelihood.* I hope this makes you curious about what's out there and excited to learn more stats! 

### Conditional randomization and model-X knockoffs

If you analyze data, then at some point, you will need to test if $X_1$ has an association with $Y$ after controlling for $X_2$. This act is a fundamental building block in causal statistics, and it appears all over the social and biomedical sciences. This is especially trickly when the form of $P(Y|X)$ is either uncooperative -- like when you fit [certain advanced regression models](https://stat.ethz.ch/pipermail/r-help/2006-May/094765.html) -- or worse, completely unknown, as it might be when fitting a random forest. 

For testing regression coefficients when $P(Y|X)$ is unknown, the usual approach is permutation. This does not correctly test conditional effects like $Y \perp \!\!\! \perp X_1 | X_2$. Even under the null hypothesis, negative controls should reflect indirect effects like $Y \rightarrow X_2 \rightarrow X_1$. Permuted copies lack these indirect effects, and they are thus poor negative controls. 

Our second miracle of modern statistics is *conditional randomization*, discussed in section 4 of [this paper](https://arxiv.org/abs/1610.02351). The principle is to formulate a model for $P(X_1|X_2)$, which is often easier than modeling $P(Y|X)$. Once you have it, you can sample negative control copies of $X_1$ and build a null distribution for an arbitrary test statistic. For instance, in [this work on CRISPR screens](https://www.biorxiv.org/content/10.1101/2020.08.13.250092v7), models for transcript counts, i.e. $P(Y|X)$, cannot be calibrated correctly, but the null distribution is adequately described by a model for the detection of CRISPR guide RNA's, $P(X_1|X_2)$. 

If that still seems pedestrian rather than miraculous, don't worry -- there's more. Often, this conditional effect testing is embedded in a higher-dimensional setting where there are hundreds of $X$'s or more. Typically, there is no particular ordering, so for example it is unclear whether to test $X_1$ before adding $X_2$ to the model, or after. The genome-wide association study is one type of problem with this structure; another is [causal structure learning](https://arxiv.org/abs/2206.01152). 

A natural thing to want, but a hard thing to get, is selection of relevant X's with controlled false discovery rate. This is provided by everything outside section 4 of [the same paper that proposed conditional randomization](https://arxiv.org/abs/1610.02351). The method is to sample a set of "knockoffs" in the same shape as $X$, and as different from $X$ as possible, but while obeying a key exchangeability condition. If $S$ is a set of variables in $X$, and $swap_S(X, \tilde X)$ exchanges the variables in $S$ with their knockoffs in $\tilde X$, the knockoff construction task demands that the joint distribution be preserved after swapping.

$$swap_S(X, \tilde X) =^D X, \tilde X$$

From this exchangeability property, Candes & company construct a "machine" that can wrap any measure of variable importance -- lasso paths, correlation coefficients, tree-based, whatever -- and turn it into an FDR-controlled variable selection procedure. It's hard to construct the knockoffs, but modern techniques can manage:

- for [large human genetics data](https://msesia.github.io/knockoffgwas/)
- for [any graphical model](https://arxiv.org/abs/1903.00434)
- when the distribution family is unknown, [with generative networks](https://arxiv.org/abs/1811.06687) 

This is all done with no assumptions whatsoever on $P(Y|X)$. It can be complicated and nonlinear; it can have wild outliers and cauchy-distributed errors; or it can be linear with Gaussian noise. This works regardless. 

### That's all

That's all for now, but if you're hungry for more, check out the [next post](posts/miracles_3) on standard errors for regression coefficients with non-IID data!