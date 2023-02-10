---
layout: post
title: You can't satisfy three simple desiderata for a clustering algorithm.
math: true
permalink: impossible_2
tags: stat_ml
---

So you want to cluster your data. And you want to use a "good" algorithm for clustering. What makes a clustering algorithm "good"? 

The work I'll discuss mentions three desirable properties. 

- isometry-invariant: if you rotate or reflect your dataset, your should get the same result. 
- consistent: if two samples are assigned the same cluster, and you move them closer while keeping all else the same, then the result shouldn't change. Same if they're in different clusters and you move them farther apart. 
- expressive: any partition of the samples should be achievable.

If you find these criteria applicable to your work, then a natural question is: can any clustering algorithm be isometry-invariant, consistent, and expressive in the above sense?

![The meme where Bugs Bunny smugly says "No."](images/BugsBunnyNo.jpg)

This result is explained elsewhere better than I can explain it, both formally and informally. Jon Kleinberg at Cornell sets out an initial version of the result in an influential paper [(pdf)](https://www.cs.cornell.edu/home/kleinber/nips15.pdf). That paper uses the term "richness" for what I call "expressive" methods (these are different names for the same thing), and it uses scale invariance in place of isometry invariance (these are different in substance, not just in name). This [CV thread](https://stats.stackexchange.com/questions/173313/) gives really nice plots illustrating Kleinberg's results and describes a way to replace scale invariance with isometry invariance. Since I find Kleinberg's axioms dubious, I'd like to also link to [this counterpoint](https://proceedings.neurips.cc/paper/2008/hash/beed13602b9b0e6ecb5b568ff5058f07-Abstract.html), which reconciles Kleinberg's three axioms in a more forgiving framework.

![Another Bugs Bunny meme where Bugs Bunny nicely says "Yes."](images/BugsBunnyYes.jpg)

#### Implications for single-cell genomics

 I don't lose sleep over this impossibility result, because in single-cell RNA analysis, these criteria don't really make sense. Why would they make sense or not? In order: 

- isometry invariance: (If you rotate or reflect your dataset, your should get the same result.) In terms of log-scale gene expression data, isometry invariance  implies you should get the same result if you relabel all the genes and flip the sign of any gene (change all fold increases to fold decreases). This is fairly intuitive to me, except for the part where going from "barely detected" to "not detected" is a fold change of $-\infty$. Usually people add a pseudocount before the log to avoid that issue, which seems better than nothing but doesn't entirely help me understand the biological meaning of isometry invariance. 

    Isometry invariance also demands the same behavior when replacing individual genes with weird combinations of genes, which is not intuitive. If the isometry is in the L1 norm, you assert that a log fold change of $\pm 0.001$ in 1000 genes means the same thing as a log fold change of 1 in one gene. Why should it mean the same thing? 
- consistency: (If two samples are assigned the same cluster, and you move them closer while keeping all else the same, then the result shouldn't change. Same if they're in different clusters and you move them farther apart.) This seems too extreme because you can use this type of operation to introduce obvious sub-clusters, and it would be reasonable for the algorithm to either keep the same clustering, OR react to the hierarchical structure. 
- expressiveness: (Any partition of the samples should be achievable.) For single cell genomics, I couldn't name anyone who thinks any organism has more than 10,000 cell types, whereas the datasets are sometimes in the millions of cells now. That severely limits the number of partitions that need to be achievable. 

Even if these criteria don't make sense, it's interesting you can't have all three properties at once, because the counterexamples are very similar to a couple of particular single-cell RNA datasets I know of. Qualitatively, the counterexamples come down to handling of hierarchical structure. What should you do if you zoom in on a cluster and see more clusters inside of it? Scale invariance makes this especially tricky. This seems to come up in, for example, Davi Sidarta-Oliveira's CD4 T-cell results [(preprint, fig 2)](https://www.biorxiv.org/content/10.1101/2022.03.14.484134v1.full) or the [ongoing discovery of new specialized subsets of the thymic medulla](https://www.nature.com/articles/s41467-021-21346-6). Biologically, it's reasonable to put the whole thymic medulla or all CD4+ T cells in one cluster, and it's also reasonable to split them up. Neither behavior indicates a fundamental deficiency of a clustering algorithm. It's (GASP) subjective. Some decisions still require a human in the loop `¯\_(ツ)_/¯`.

#### Coda

This is part of a series on [disturbing impossibility theorems](impossible_0).
