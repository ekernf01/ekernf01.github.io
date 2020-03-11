---
layout: post
title: On brute-force reprogramming
permalink: /GRN_brute_force_reprogramming/
math: true
---

A recent FANTOM5 satellite paper provides computational predictions for all pairs of cell types. 

> Rackham, O. J., Firas, J., Fang, H., Oates, M. E., Holmes, M. L., Knaupp, A. S., ... & Petretto, E. (2016). A predictive computational framework for direct reprogramming between human cell types. Nature genetics, 48(3), 331.

Part of their rationale is that brute-force reprogramming is impractical. Citing [this](doi:10.1017/S1464793106007068) paper, which uses a very rigid concept of a cell type, they begin a simple calculation by claiming that humans have about 400 cell types. They also use 2,000 as the number of transcription factors, and they consider a screen in which all sets of 3 factors are tested in every cell type. This would total over $10^{11}$ trials, which is obviously not practical. 

This is a straw-man: reprogramming factors are actually discovered using much more efficient screens. The [Yamanaka factors](https://doi.org/10.1016/j.cell.2006.07.024) for induced pluripotent stem cells were discovered starting with 24 manually selected candidates, not beginning with all 2000 human TF's. The screen found a positive result for those 24 factors together, and then used a leave-one-out approach to find 10 factors that were indispensible in that context. They then left each of the 10 out, leaving four that were truly indispensible. Furthermore, there is no reason to reprogram from every cell type to every other cell type; Takahashi and Yamanaka just used a few kinds of fibroblast. Obviously, what Rackham et al. have done is valuable and important, and it could substantially lower the burden of reprogramming to a given cell type. But, it's not the only solution to this problem.
