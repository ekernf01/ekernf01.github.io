---
layout: page
title: We want `R` functions for gradients and hessians
permalink: /gnorm_hnorm/
math: true
---


R typically offers functions prefixed by `d`, `p`, `q`, and `r` for pdf, cdf, inverse cdf, and sampling. These are somewhat useful for inference, especially MCMC since you're usually sampling and computing densities. You can even get the log density from the `d` function with an extra argument. But, for everyday fitting via likelihoods or empirical Bayes, I wish they would have included functions prefixed with `g` for the gradient of the log density w.r.t. the parameters and `h` for the hessian. Imagine if you could code up a Newton-Raphson update in two lines:

    mean_sd = c('mean'=0, 'sd'=1)
    mean_sd = mean_sd - solve( 
        hnorm(x, mean_sd['mean'], mean_sd['sd']), 
        gnorm(x, mean_sd['mean'], mean_sd['sd']) 
        )

(The interface would have to be considered, but here I am thinking of $x$ as a vector, and the return value is the gradient or hessian assuming the entries of $x$ are i.i.d.) 

Does this functionality exist? I suspect it doesn't, because I've looked a bit, and people seem to do it from scratch, for instance in this [vignette about maximum likelihood inference](https://r-forge.r-project.org/scm/viewvc.php/*checkout*/paper/CompStat/maxLik.pdf?revision=1114&root=maxlik&pathrev=1114
). 
 
 

