---
layout: post
title: A third miracle of modern frequentist statistics
math: true
permalink: miracles_3
tags: stat_ml
---

Here's post #3 of 4 on astonishingly general tools from modern frequentist statistics. This series highlights methods that can accomplish an incredible amount on the basis of very limited or seemingly wrong building blocks. It's not just about the prior anymore: each of these methods works *when you don't even know the likelihood.* I hope this makes you curious about what's out there and excited to learn more stats! 

### Generalized estimating equations

In the blandest possible regression setting, you would typically assume $Y_i \sim X_i\beta + \epsilon_i$ with $\epsilon_i$ mutually independent across all $i$. Sometimes this fails: you may have repeated measurements of the same individuals or test sites; you may include family members sharing a history, a culture, and a home rather than just whatever you measured in $X$. The typical response, Bayesian or Frequentist, is hierarchical modeling: a model like $$Y_{ij} = Z_{j(i)}\gamma_{j(i)} + X_{i}\beta_{i} + \epsilon_{i}$$ where $j(i)$ can be the same for different values of $i$. 

This leads to a very specific within-group covariance. Inference for these models typically must make strong assumptions about the distribution of the errors, and sometimes also needs detailed prior assumptions on the coefficients. Our next "modern" miracle (it's from the 80's, with closely related work even earlier) is a way to obtain coefficient estimates and asymptotically valid confidence intervals, with no strong assumptions on the distribution of the errors or even the correlation within groups. 

It's called generalized estimating equations, or GEE. I'll oversimplify, but the GEE point estimates are not special. The special part is the standard errors, which come from the variance-covariance matrix of the effect estimates. Naive standard errors go something like this. The usual estimator is

$$\hat \beta = (X^TX)^{-1}X^Ty$$

so the covariance of the estimator is

$$\begin{align}
Cov[\hat \beta] 
  &= (X^TX)^{-1}X^TCov[y]X(X^TX)^{-1}  \nonumber
\\&= \sigma^2(X^TX)^{-1}X^TX(X^TX)^{-1}  \nonumber
\\&= \sigma^2(X^TX)^{-1} \nonumber
\end{align}$$

. GEE works by refusing to simplify $Cov[y] = \sigma^2 I$. Instead, it substitutes in an estimate of the within-group covariance $\frac{1}{J}\sum_{j=1}^J Y_jY_j^T$, yielding a "sandwich":

$$ (X^TX)^{-1}X^T \left[\frac{1}{J}\sum_{j=1}^J Y_jY_j^T\right] X(X^TX)^{-1}$$

. Instead of converging to the simpler thing above, right or wrong, this converges to the right answer as long as the "meat" of the sandwich, $\frac{1}{J}\sum_{j=1}^J Y_jY_j^T$, does.

There are ways to make this more sophisticated to handle GLM stuff (link functions and binomial/poisson/whatever response distribution) and working hypotheses about the within-group correlation (autoregressive or exchangeable are common choices). See [here](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4321952/) for applications in genetics. The crucial idea is the sandwich estimation of standard errors. 

### That's all

That's all for now, but if you're hungry for more, check out the [next post](miracles_4) on standard errors for point estimates from variational expectation maximization!