---
layout: post
title: Simple isoform abundance estimation
permalink: /GRN_isoforms/
math: true
---


##### Problem

Most single cell RNA-seq data measures only the end of the transcript, meaning it's impossible to get full information about alternative transcript splicing (e.g. skipping a segment in the middle). Often there is full-length transcript data available from bulk RNA-seq datasets on similar mixtures of tissues, and these datasets can measure each isoform separately (e.g. using a sequencing read that omits or includes that segment). How much can we learn from combining these types of data?

##### Example

Suppose you are studying the thymus and you have single-cell RNA data, bulk data, and an estimate of the mixture fraction in the bulk data. For instance, suppose you have a sample that is 95% blood, 2% mesenchyme, and 3% epithelium, and these cell types are resolved in the single-cell data but averaged in the bulk data. My favorite gene, Foxn1, should appear only in the epithelium, which we can tell from the single-cell data. Furthermore, only one isoform should be present when we look at the bulk data. Therefore, we can infer that the epithelium expresses only that isoform. 

##### General statement

Suppose gene $G$ has $I$ isoforms, present in the bulk data in amounts $\{b_i\}_{i=1}^I$. In the single cell data, they'll be present in the $J$ cell types in amounts $s_{ij}$ for isoform $i$ in cell type $j$. (Instead of a gene, one could be more precise by using an equivalence class as from Kallisto.)

We don't observe $s_{ij}$, but we do have gene-level totals $t_j$ for each cell type, and we know $b_i = \sum_j p_j s_{ij}$ (where $p_j$ is the fraction of cell type $J$ in the bulk sample, which is assumed to be known or easy to estimate). 

So, we have IJ unknowns and I+J equations (one per cell type and one per isoform). For certain cases, such as a single cell type or a single isoform, we can just solve the system. For larger $I$ and $J$, we don't have enough information to solve the system as presented so far. But, unlike a garden variety linear system, we have one more piece of information: we know all the quantities $s_{ij}$ are non-negative. Thus, we can find upper and lower bounds on our unknowns. Sometimes the upper bound is zero -- as for the non-expressed isoform in the thymus -- and we can make a clean inference. Otherwise, we wish to find the upper and lower bounds.

##### Mathematical summary:

- $t_j = \sum_i s_{ij}$
- $b_i = \sum_j p_j s_{ij}$
- $s_{ij} > 0$
- $t$ and $b$ are measured (with overdispersed Poisson-like errors)
- $p$ is known or easily estimated
- Goal: infer the narrowest interval $A$ guaranteed to contain $s_{ij}$ for all $i$, $j$ in order to account for non-random uncertainty
- Optional second goal: consider an additive error term on all measurements. Can we form confidence intervals for the endpoints of $A$ to account for random measurement error?

##### N.B. 

The exact same mathematical problem arises in causal statistics. In the "binary instrumental variables model", hidden quantities that count up counterfactual outcomes can be inferred from observed quantities. For instance, suppose 54 people receiving a treatment have a positive outcome. How many people would have had a poor outcome without treatment, and how many would have had a good outcome without treatment? Those two hidden quantities are both zero or greater, and they sum to 54. Inference of upper and lower bounds based on this and similar information is used to narrow down the range of possible values for the average causal effect. 

##### Solution

I posted and answered the math problem on Stats SE as [intervals from an underdetermined nonnegative linear system](https://stats.stackexchange.com/questions/442961/intervals-from-an-underdetermined-nonnegative-linear-system/442962#442962). The feasible values of $s$ form a polytope. One solution is to enumerate vertices of this polytope, and there is a C++ library that will enumerate the vertices for you. Then for each coordinate, you can take the maximum and minimum over all vertices.

##### Rationale

Cell-type resolution of isoforms could help model the causes and effects of alternative splicing in diverse situations. For example, Foxn1 has different targets between the thymus (where it activates many genes, including some related to antigen presentation) and the skin (where it helps control terminal differentiation of keratinocytes). It also has additional isoforms expressed in the skin, and this could help explain the different "choice" of targets in skin versus thymus. But, since bulk RNA data on the thymus is >95% blood, it is difficult to directly use that data in mechanistic models of the epithelium. This approach offers to automate and scale up a useful intermediate step towards isoform-conscious mechanistic models.

##### Paper outline

A short paper detailing this approach could outline the software and share results for a collection of cell atlases. One could judge the quality of the results by counting which genes and cell types have strong isoform inferences (narrow intervals or point estimates) and which ones have weak inferences (wide intervals). Perhaps this would suggest additional data to fill in the gaps. One interesting demonstration would be to fit network models or make reprogramming predictions with and without isoform information. Would projects like [MAGNUM](http://regulatorycircuits.org/download.html) or [Mogrify](http://www.mogrify.net/) work just as well with no isoform specificity?

