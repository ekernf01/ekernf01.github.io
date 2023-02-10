---
layout: post
title: You can't construct confidence intervals near a region of non-identifiability
math: true
permalink: impossible_5
tags: stat_ml
---

This post will highlight Jean-Marie Dufour's absolutely impenetrable *tour de force* "Some Impossibility Theorems in Econometrics With Applications to Structural and Dynamic Models", also known by its English title, "Weak Instruments, Get Rekt." Dufour talk about confidence intervals for a parameter $\phi$ in a situation where:

- There is a nuisance parameter $\theta$.
- For some $\theta$, $\phi$ cannot be identified.

Let's talk about the simplest possible example of how things go horribly, provably wrong: we want a confidence interval for $\beta_1/\beta_2$ after fitting a regression $Y_i = \beta_1 X_{i1} + \beta_2 X_{i2} + \epsilon_i$, where $\epsilon_i$ is iid N(0,1). 

Absent prior information, we're going to center the interval on $\hat \beta_1 / \hat \beta_2$, where the hat indicates the least squares estimate of the corresponding parameter. Now, how wide should the interval be? Let's start with a Wald interval, aka the delta method, aka propagation of errors. The [delta method says](https://en.wikipedia.org/wiki/Delta_method) that the variance of $g(\beta)$ is roughly $g'(\beta)Cov(\beta)g'(\beta)^T$. Here, $g'(\beta) = (1/\beta_2, -\beta_1/\beta_2^2)$ and $Cov(\beta)$ is $(X^TX)^{-1}$. We might start by hoping the delta method is a good approximation: the sampling distribution is approximately Gaussian with mean $\beta_1/\beta_2$ and variance $g'(\beta)Cov(\beta)g'(\beta)^T$. For 95% coverage, we could then set the interval radius to 1.96 times the square root of the delta-rule variance. 

I consulted Dufour's work about what actually happens when we do this and whether the coverage is close to 95%. It's not. In the worst case scenario ($\beta_2$ close to 0), coverage can be arbitrarily close to 0%. You can test it with this snippet of R code, and if you leave the parameters as I've set them below, coverage is usually less than 400 of the 1000 runs. 

    n_sim = 1000
    coverage = 0
    phi = 10
    b2 = 0.1
    b1 = b2*phi
    for(i in 1:n_sim){
        b1_est = rnorm(1, b1, 1)
        b2_est = rnorm(1, b2, 1)
        phi_est = b1_est/b2_est
        derivative = c(1/b2_est, -b1_est/b2_est^2)
        variance_delta_rule = sum(derivative^2)
        radius = 1.96*sqrt(variance_delta_rule)
        contained = (phi_est - radius < phi) && (phi < phi_est + radius)
        coverage = coverage + contained/n_sim
    }
    coverage


#### Coda

This is part of a series on [disturbing impossibility theorems](impossible_0).
