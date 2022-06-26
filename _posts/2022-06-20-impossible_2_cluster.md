---
layout: post
title: You can't satisfy three simple desiderata for a clustering algorithm.
math: true
permalink: impossible_2
tags: stat_ml
---

So you want to cluster your data. And you want to use a good algorithm for clustering. What makes a clustering algorithm "good"? The work I'll discuss mentions three desirable properties. 

- isometry-invariant: if you rotate or reflect your dataset, your should get the same result. 
- consistent: if two samples are assigned the same cluster, and you move them closer while keeping all else the same, then the result shouldn't change. Same if they're in different clusters and you move them farther apart. 
- expressive: any partition of the samples should be achievable.

Frankly, these criteria are not well-motivated based on my experience in single-cell RNA analysis. Your mileage may vary, especially if you work in a different application or if your definition of a "cell type" differs from mine. Nonetheless, it's interesting you can't have these properties all at once, and the counterexamples are very similar to a couple of particular single-cell RNA datasets. These datasets are interesting because people could reasonably disagree over what they want from clustering, and not just how to get it.

- isometry-invariant: if you rotate or reflect your dataset, your should get the same result. In terms of log-scale gene expression data, this implies you should get the same result if you relabel all the genes and flip the sign of any gene (change all fold increases to fold decreases). This is fairly intuitive to me, except for the part where going from "barely detected" to "not detected" is a fold change of $-\infty$. Usually people add a pseudocount before the log to avoid that issue, which seems better than nothing but doesn't entirely help me understand the biological meaning of isometry invariance. 

    Isometry invariance also demands the same behavior when using weird combinations of genes, which is not intuitive. If the isometry is in the L1 norm, then does a log fold change of $\pm 0.001$ in 1000 genes mean the same thing as a log fold change of 1 in one gene? 
- consistent: if two samples are assigned the same cluster, and you move them closer while keeping all else the same, then the result shouldn't change. Same if they're in different clusters and you move them farther apart. This seems too extreme because you can use this type of operation to introduce obvious sub-clusters, and it would be reasonable for the algorithm to either keep the same clustering, OR  react to the hierarchical structure. I think of this when I see Davi Sidarta-Oliveira's CD4 T-cell results [(preprint, fig 2)](https://www.biorxiv.org/content/10.1101/2022.03.14.484134v1.full) or the [ongoing discovery of new specialized subsets of the thymic medulla](https://www.nature.com/articles/s41467-021-21346-6). Yes, it's reasonable to put the whole thymic medulla or all CD4+ cells in one cluster, and it's also reasonable to split them up.
- expressive: any partition of the samples should be achievable. For single cell genomics, I couldn't name anyone who thinks any organism has more than 10,000 cell types, whereas the datasets are sometimes in the millions of cells now. That severely limits the number of partitions that need to be achievable. 

If you find these caveats inapplicable to your work, then a natural question is: can any clustering algorithm be isometry-invariant, consistent, and expressive in the above sense?

![The meme where Bugs Bunny smugly says "No."](images/BugsBunnyNo.jpg)

This result is explained elsewhere better than I can explain it, both formally and informally. Jon Kleinberg at Cornell sets out an initial version of the result in an influential paper [(pdf)](https://www.cs.cornell.edu/home/kleinber/nips15.pdf). That paper uses the term "richness" for what I call "expressive" methods, and it uses scale invariance in place of isometry invariance. This [CV thread](https://stats.stackexchange.com/questions/173313/) gives really nice plots illustrating Kleinberg's results and describes a way to replace scale invariance with isometry invariance. Since I find Kleinberg's axioms dubious, I'd like to also link to [this counterpoint](https://proceedings.neurips.cc/paper/2008/hash/beed13602b9b0e6ecb5b568ff5058f07-Abstract.html), which reconciles Kleinberg's three axioms in a more forgiving framework.

![Another Bugs Bunny meme where Bugs Bunny nicely says "Yes."](images/BugsBunnyYes.jpg)

This is part of a series on [disturbing impossibility theorems](impossible_0).
