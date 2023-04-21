---
layout: post
title: What FDR control doesn't do
math: true
permalink: fdr_disclaimers
tags: stat_ml
---

Working on transcriptome data, I use FDR control methods constantly, and I've run into a couple of unexpected types of situations where it's easy to assume they will behave well... but they don't. 

False discovery rate (FDR) control is useful and standard in genomics for dealing with screens such as eQTL analysis or differential expression testing. If a study is returns R findings, of which F are incorrect and T are correct, the idea is to control F/R. This is called the false discovery proportion, and its expected value is called the FDR. There are many methods for FDR control; as input, they usually want a list of p-values and a desired FDR, and as output, they return a set of discoveries. 

There is a ton of literature on this topic. If you want to bone up on it, I can make a recommendation about where to start: Storey and Tibshirani's 2003 work ["Statistical significance for genomewide studies"](https://www.pnas.org/doi/10.1073/pnas.1530509100) is very clearly explained and that would make it a useful first stop. But, introducing FDR is not the purpose of this post. Rather, I'll assume you know generally what it is, and you've used it in practice at least once. I want to discuss some properties that you might assume FDR control methods provide for you, and I'll give examples where those properties break down very badly. 

### FDR control addresses the expected value of F/R, but not the **variance**

FDR control methods are often phrased in terms of a bunch of *independent* tests. Sometimes they can also be proven to work for dependent tests. Buuuuut, the result can be highly volatile, even when everything formally works as claimed. A extreme example is when all the p-values are equal. Run this R code to see how controlling FDR at 10% behaves under extremely correlated p-values. You get nothing 90% of the time, and then 10% of the time, you get everything. This behavior is technically correct.

    num_significant = c()
    for(i in 1:1000){
        num_significant[i] = sum(p.adjust(rep(runif(1), 1000), method = "BH") < 0.10)
    }
    table(num_significant)

This means that certain studies with lots of unexpected findings should be valued or weighed as if they found just a few unexpected findings. This is especially true in transcriptomics, where measurement errors or changes in cell state can manifest in tons of genes at once.

If you are like me, you'll hate this. To avoid getting bitten by this, you could try reducing correlations in your tests by addressing confounding. Check out Jeff Leek's papers on SVA. 

### FDR control is not preserved when you take unions or intersections of sets

A common situation: I run tests from comparison A, obtaining a set of discoveries S at 10% FDR. Then I do more tests from comparison B, obtaining set T at 10% FDR. If I combine S and T, I would have thought the result has 10% FDR. 

![The meme where Bugs Bunny smugly says "No."](images/BugsBunnyNo.jpg)

Not so. Here's the intuition for why this fails. Whichever of S and T is bigger will usually dominate the combined results. The bigger one is often bigger because it contains a bunch of extra false crap. Run this R code to see it happen.


    # 10% of hypotheses are true. 
    # FDR cutoff is set at 10%.
    is_false = c(rep(1, 90), rep(0, 10))
    run_tests = function(){
    return(p.adjust(c(runif(90), 0.1*runif(10)), method = "BH")<0.1)
    } 
    # We'll record the false discovery fraction at each of 1000 trials
    fdp = data.frame(s=rep(0, 1000), t=rep(0, 1000), union=rep(0, 1000))
    for(i in 1:1000){
    S = run_tests()
    T = run_tests()
    fdp[i,"s"] = mean(is_false[S])
    fdp[i,"t"] = mean(is_false[T])
    fdp[i,"union"] =  mean(c(is_false[S],  is_false[T]))
    # When there's no discoveries, I count it as false discovery proportion of 0.
    fdp[i,is.na(fdp[i, ])] = 0
    }
    # FDR in union: ~0.16.
    colMeans(fdp)
