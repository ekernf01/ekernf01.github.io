---
layout: post
title: A fourth miracle of modern frequentist statistics
math: true
permalink: miracles_4
tags: stat_ml
---

Here's post #4 of 4 on tools from modern frequentist statistics that a guaranteed to work despite their basis in very limited or seemingly wrong building blocks. I hope this makes you curious about what's out there and excited to learn more stats! 

### Standard errors for variational inference

I know I said 3, but here's a bonus. Unlike the other miracles, you will need to specify the full likelihood for this one, but if you've only ever been exposed to Bayesian takes on variational inference, it will open your mind to interesting new possibilities. 

The usual Bayesian take on variational inference goes something like this. We have a Bayesian model $P(X, Z; \theta)$ where $X$ is observed, $Z$ contains parameters of interest, and $\theta$ controls the prior on $Z$. The posterior on $Z$ is hard to find, so instead, we "look under the lamppost". We choose a family $\{Q_\psi(Z)\}_{\psi \in \Psi}$ and look for the closest approximation to the posterior, usually in the KL "distance": 

$$\argmin_\psi D_{KL}(Q_\psi, P(Z|X;\theta))$$

. 

This has a not-so-small problem. In many applications, people sneak the parameters of interest into $\theta$! No posterior, no confidence interval, and no standard error is given for $\theta$. If you rely on the inferred value of $\theta$ to make conclusions, you are asking the audience to trust that $\theta$ is reasonably well estimated, Bayes be damned. A prominent example of this problem occurs in [the SCVI differential expression framework](https://www.biorxiv.org/content/biorxiv/early/2019/10/04/794289.full.pdf). It also happens in [EAGLE](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5501199/), though they do have an ad-hoc scheme assuming that $\theta$ is asymptotically Gaussian. (Wouldn't it be nice if that assumption turned out to be correct and applicable under broader circumstances? Sure seems nice to me!)

Often, $\theta$ is reasonably well estimated, for example by maximizing the observed-data likelihood $P(X, \theta)$ with respect to $\theta$. Today's miracle does two things: first, it guarantees that the optimization will find the right value for $\theta$, even if the methods used to maximize $\int_Z P(X, Z;\theta)dZ$ use $Q_\psi$ instead of the real posterior. Second, it provides an asymptotic distribution and standard errors for $\theta$.

The method is from [here](https://arxiv.org/abs/1510.08151) (disclaimer: I know Ted and Tyler and I'm excited to be pushing their work). They show that in many cases, you can take a certain derivative, and if it's zero, then you know your estimate of $\theta$ is consistent. The derivative is:

$$E[\frac{d}{d\theta}\max_\phi \int \log\frac{P(X, Z;\theta)}{Q_\psi(Z)}Q_\psi(Z)dZ]$$

and this is hard to do by hand, but Ted & Tyler provide a way to monte-carlo it out.

Once you know you get the right $\theta$, you can also get standard errors etc, because $\sqrt{n}(\theta - \theta_0)$ converges to a Gaussian with zero mean and known variance. Ted and Tyler give a formula and computation method for the variance using derivatives similar to the one in the consistency check.

### That's all

That's all for now, but if you're hungry for more, send me a tweet @ekernf01 or an email, and tell me to write the post I've been mulling on mind-blowing impossibility theorems. 