---
layout: post
title: You can't estimate the mean.
math: true
permalink: impossible_3
tags: stat_ml
---

*Maybe this was naive of me. I thought that if you were willing to assume that the mean exists, you could probably ... estimate it?* Nope, fuck you. Here we go. 

Consider a family of univariate probability distributions with the following properties.

- Every member of the family has a mean. (No Cauchy distributions allowed.)
- For every real number, some member of the family has that mean (expressiveness).
- The family is convex: if $f$ and $g$ are in the family, then $pf + (1-p)g$ is also in the family.
- The family is translation-invariant: if $X$ is an RV drawn from a member of the family, then the distribution of $X+c$ is also in the family.
- The family is not empty.

This seems like a mild set of requirements. An example of a family satisfying them is the set of all finite Gaussian mixtures. Another example is the set of all finite mixtures of point masses. Should we expect to be able to get reasonable confidence intervals for the mean?

![The meme where Bugs Bunny smugly says "No."](images/BugsBunnyNo.jpg)

Ok, what about hypothesis tests for the mean equalling 0?

![The meme where Bugs Bunny smugly says "No."](images/BugsBunnyNo.jpg)

Ok, can we at least have a good point estimate?

![The meme where Bugs Bunny smugly says "No."](images/BugsBunnyNo.jpg)

The result is from [this paper](https://projecteuclid.org/journals/annals-of-mathematical-statistics/volume-27/issue-4/The-Nonexistence-of-Certain-Statistical-Procedures-in-Nonparametric-Problems/10.1214/aoms/1177728077.full) by Bahadur and Savage. The proofs take a member of the family with a certain mean, say 0, and produce a very similar member of the family with a very different mean. For instance, suppose you start with a distribution having 100% probability at 0. You want to move at most 0.001% of the probability mass, but you need to move the mean to 10^80. What do you choose? Put 99.999% of the mass at 0 and 0.001% of the mass at 10^85. With a sample of size 1,000, it's likely to be all zeroes either way, and thus in the worst case, you have no clue as to the true value of the mean.

To avoid falling into this trap, you can estimate the median instead of the mean. Or, you can either rule out large things. Or, you can rule out rare things. 

- Large things. Bounded families of probability distributions do not suffer from the problems raised by Bahadur and Savage. The assumptions this breaks are translation invariance and expressiveness. I don't miss this at all. Let's be frank: have you ever measured a quantity using a real number, where any result no matter how big would be an acceptable measurement? If your RNA-seq pipeline gave to a TPM of 10^50, would you go ahead and model that? 
- Rare things. Families of finite mixtures where each mixture component has mass at least $p$ for some positive $p$ also do not suffer from this problem. Unfortunately, rare things seem quite ... common ... in practice. 

This is part of a series on [disturbing impossibility theorems](impossible_0).
