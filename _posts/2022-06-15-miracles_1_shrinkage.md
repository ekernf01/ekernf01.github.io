---
layout: post
title: Four miracles of modern frequentist statistics
math: true
permalink: miracles_1
tags: stat_ml
---

Over the past N years I've heard lots of smart people that I respect say things like "inside every frequentist there's a Bayesian waiting to come out" and "Everybody who actually analyzes data uses Bayesian methods." These people are not seeing what I'm seeing, and that's a shame, because what I'm seeing is frankly astonishing.

Here's post #1 of 4 on tools from modern frequentist statistics, each with a distinctive advantage that nearly defies belief in terms of how much can be accomplished on the basis of very limited or seemingly wrong building blocks. It's not just about the prior anymore: each of these methods works *when you don't even know the likelihood.*

### Optimal shrinkage based on the method of moments

When you have many parameters to estimate and not much data for each -- for instance, dispersion of 10,000 transcript counts over 6 biological replicates -- it is common to assume that they are similar to one another, so that each can share data with the others and improve the efficiency of estimation (*shrinkage*). This can be given a Bayesian justification by assuming the parameters come from a common prior, and it has a frequentist justification in that specific implementations [famously out-perform the mean squared error of the sample mean](https://en.wikipedia.org/wiki/James%E2%80%93Stein_estimator).

In a particular application, how much influence should each estimate take from the others? People bend over backwards to answer this question. For example, in the [edgeR paper](https://academic.oup.com/bioinformatics/article/23/21/2881/372869) section 3.2, you can see Robinson and Smyth start with dispersion estimators whose sampling distributions are very far from Gaussian (point masses at 0) but still pretend they are Gaussian in order to select a shrinkage parameter. For another example, the [scikit-learn bayesian ridge regression](https://scikit-learn.org/stable/modules/linear_model.html#bayesian-regression) uses not just a prior on regression coefficients, but a prior on the strength of ... the prior on the strength of ... the regression coefficients. These types of schemes become difficult to understand, at least for me, and it is hard to know if there are unforeseen consequences. Due to all the specific distributional assumptions, they are also difficult to adapt for use in situations where the likelihood is unknown -- which is what this post is about.

Thus, our first modern miracle is a simpler method for optimal shrinkage. If your estimate is a convex combination $\lambda T  + (1-\lambda) U$ of an unbiased estimator $U$ (e.g. the sample mean) and a shrinkage target $T$ (e.g. all coordinates equal to the grand mean), then the optimal $\lambda$ is 

$$\frac{\sum_{i=1}^p Var(U_i) - Cov(U_i, T_i) }{\sum_{i=1}^p E[(T_i-U_i)^2]}$$

. This allows optimal shrinkage with no specific distributional assumptions on the observed data or the latent variables. All you need to do is plug in some moment estimates. If you want to read more, I find the clearest presentation is [Schaefer and Strimmer 2005](https://www.cs.princeton.edu/~bee/courses/read/schafer-SAGMB-2005.pdf) section 2.2, and you can also follow that to the original 2003 work by Ledoit and Wolf. 

### That's all

That's all for now, but if you're hungry for more, check out the [next post](posts/miracles_2) on calibrated conditional independence testing!