---
layout: post
title: Contra Rubin et al on genetic interations 
math: true
---

In the Maehr lab's regular journal club, we recently discussed a *Cell* paper from the research groups of Howard Chang, Will Greenleaf, and Paul Khavari (henceforth "Rubin et al.").

> Rubin, A. J., Parker, K. R., Satpathy, A. T., Qi, Y., Wu, B., Ong, A. J., ... & Zarnegar, B. J. (2019). Coupled single-cell CRISPR screening and epigenomic profiling reveals causal gene regulatory networks. Cell, 176(1-2), 361-376.

It's an impressive technical feat. They combine pooled CRISPR knockdowns and knockouts with an ATAC-seq chromatin readout. In non-technical terms, they can study the accessibility of DNA packaging in individual cells under a variety of artificially manipulated conditions. It's a whopper of a paper, with tons of information and very complicated analyses. 

Their figures 4 and 7 are themed around genetic interactions. They knock down Gene A and Gene B separately, then predict what the joint effects would be. Then they test their predictions by knocking down A and B in the same set of cells. Here is an example (their figure 4B).

![EBER1 and TET2 interact ... or do they?](/Users/erickernfeld/Dropbox/blog posts/ekernf01.github.io/images/interaction_example.png)

They describe this as an interaction. Unfortunately, "interaction" means one thing when you're writing down regression models and another when you're drawing biochemical networks. In the regression modeling sense, a model of EBER1 and TET2 won't accomodate the data, and an "interaction term" is needed.

$$\beta_0 + \beta_{EBER1} + \beta_{TET2} \not\approx Y_{both}$$
$$\beta_0 + \beta_{EBER1} + \beta_{TET2} + \beta_{EBER1, TET2} \approx Y_{both}$$

In the regression model, EBER1 and TET2 are just very weird names for regression coefficients. In a biochemical sense, EBER1 is a non-coding RNA, and TET2 is a protein. The simplest biological model compatible with the data does *not* require any physical interaction between them. To elaborate using the typical language of gene knockouts, TET2 and EBER1 are *redundant*. Successful repression of the loci in question can be carried out by EBER1, even when TET2 is gone, and by TET2, even without EBER1. Repression fails only when both EBER1 and TET2 are removed. If each one works without the other present, this actually argues *against* physical binding between them.

Rubin et al repeat this mistake further down when discussing EZH2, saying it "cooperates" with EBF1, IRF8, and RELA to prevent stem cells from entering certain specialized lineages. In fact, their evidence indicates that each of these extra factors has an additional effect that works even in the absense of EZH2. Their figure specifically indicates differences observed between two groups that both have EZH2 knockdowns.

![EBF1, IRF8, and RELA repress non-B-cell lineages even in the absence of EZH2.](/Users/erickernfeld/Dropbox/blog posts/ekernf01.github.io/images/interaction_example_EZH2.png)

#### An improved set of concepts to relate multiple perturbations with biochemical interactions

In figure 7, Rubin et al go on to classify dozens of pairs of knockouts by the (statistical) interactions or lack thereof. 

![A snippet of Rubin et al's catalogue of genetic interactions relevant to keratinocyte differentiation.](/Users/erickernfeld/Dropbox/blog posts/ekernf01.github.io/images/genetic_interaction_keratinocytes.png)

They seem to borrow terminology from [Dixit et al 2016](https://www.cell.com/cell/fulltext/S0092-8674(16)31610-5?_returnURL=https%3A%2F%2Flinkinghub.elsevier.com%2Fretrieve%2Fpii%2FS0092867416316105%3Fshowall%3Dtrue), who write:

> For each pair of perturbed TFs, we assessed the relative proportion of target genes where their relation is additive (no interaction), synergistic, buffering (antagonistic), or dominant (when the two factors have opposing effects and the interaction term enhances one of them).

These terms are a creative, quick way to give practical meaning to regression results that are otherwise biologically opaque. But, if we are going to start cataloguing genetic interations, it's time to replace them with something more detailed and mechanistic. 

How? First, we need to stop using only the interaction term of the regression. We must consider activity in all four settings: the control, knockdown of gene A alone, knockdown of of gene B alone, and knockdown of both genes together. Once we have all the information, we can posit mechanistic models and see which ones fit the data.

 Model     | Ctrl | KD A | KD B | KD both
-------------------------------------------|---------|-------------|-------------|-----
A and B form a complex activating the target. The complex require both pieces to work.   | + | -    | -    | -
B maintains the target's activity alone.        | + | +    | -    | -
A maintains the target's activity alone.        | + | -    | +    | -
???    | + | -    | -    | +
A and B are redundant: either alone is sufficient to maintain target activity. This means they will share targets, but they do not depend on one another to work, so they probably do not form a physical complex.    | + | +    | +    | -
???    | + | +    | -    | +
???    | + | -   | +    | +

If you see the inverse of a pattern from the table, such as the inverse of the to row `+ - - - ==> - + + +`, just replace "activating" or "activity" with "repressing" or "repression".

#### Fin

Does anyone have biological examples of behavior falling under the "???" categories? Drop me a line and explain what you think is going on.
