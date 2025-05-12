---
layout: post
title: Multiplexed perturbations enable massive scale ... but how big can we go?
math: true
---

In molecular biology, most molecules are irrelevant to most phenotypes, and it is terribly difficult to guess a mechanism a priori. This leads to [bad problems](https://slatestarcodex.com/2019/05/07/5-httlpr-a-pointed-review/). 

The answer is large-scale screening. Genetic screens are often made economical by these steps: 

1. identify or create a genetically diverse collection, 
2. find a cheap way to select samples exhibiting the phenotype of interest,
3. genotype those with a few controls.

For example:

- Example (metabolism): CRISRP-perturb many cells. Mark and bead-select [cells that die in one sugar but not another](https://pmc.ncbi.nlm.nih.gov/articles/PMC5474757/). Genotype the guide RNA's in the galatose-enjoyers and the galatose-makes-us-die group.
- Example (epidemiology): identify cases of pediatric postural orthostatic tachycardia syndrome alongside unaffected family members or ethnicity-matched controls. [Sequence their exomes](https://link.springer.com/article/10.1007/s10286-025-01110-2). 

But, not every question has a simple yes-no answer. It would be really cool if we could screen large numbers of treatment conditions using a detailed readout such as RNA-seq or Cell Painting. 

### Fractional factorial designs and compressed screening

One way to do this is to stack treatments on top of each other, measuring many effects per sample. You can do this with combinatorics, and Lior Pachter [wrote about this](https://liorpachter.wordpress.com/tag/partially-balanced-incomplete-block-design/). If you're like me and you are bad at discrete math, well, you can assign treatment by flipping coins and the effects can still be distinguished [pretty well](https://math.stackexchange.com/questions/995623/why-are-randomly-drawn-vectors-nearly-perpendicular-in-high-dimensions). Cleary and Regev [write about this](https://arxiv.org/abs/2012.12961) from the perspective of compressed sensing, and some beautiful examples have been published.

- [Liu et al.](https://www.nature.com/articles/s41587-024-02403-z) drug up their U2OS cells with 3 to 80 different small molecules each, achieving large cost savings with a Cell Painting readout.
- [Gasperini et al.](https://pubmed.ncbi.nlm.nih.gov/30612741/) stack up about 28 CRISPRi enhancer perturbations per cell, providing an essential resource for later [benchmarks of enhancer-to-gene pairing](https://pmc.ncbi.nlm.nih.gov/articles/PMC10680627/).
- [Yao et al.](https://www.nature.com/articles/s41587-023-01964-9) overloaded a single 10X lane with 250k cells, reducing costs by about a factor of 8. 

These are really, really, cool... but 3 drugs per cell versus 80 is a big difference. Are we leaving a lot of power untapped by applying only 3 drugs when we could dump in 80 per pool? Let's talk optimality.

### A weird optimality finding

Let's consider three progressively more complex scenarios. 

#### Simple model

Suppose that: 

- perturbations do not interact, 
- perturbations do not affect noise variance
- perturbations do not cause catastrophies, 
- perturbations do not pass GO and do not collect $200. 

In this case, we should assign each perturbation to about half of our samples. 

#### Burden model 

If you stack too many perturbations, it can kill your samples. 

- With CRISPR: too much DNA damage [can cause death](https://pmc.ncbi.nlm.nih.gov/articles/PMC2626635/), and this sets in at [fairly low numbers of target sites](https://pmc.ncbi.nlm.nih.gov/articles/PMC10103988/). This constrains each perturbation to far fewer than half the samples. (Note that Gasperini et al. used CRISPRi, not CRISPR, which avoids DNA damage by using a deactivated Cas9 tethered to a nice, polite epigenetic repressor. Otherwise, 28 targets per cell would have gone poorly for them.)
- Lentiviruses also mangle the host cell genome. MOI is [frequently recommended to be kept at 10 or below](https://cdn.origene.com/assets/documents/lentiviral/recommended_lentivirus_moi_for_common_cell_lines.pdf).
- Most studies keep their total siRNA concentration well under 100nM and I'm afraid to ask what happens if you go higher. Maybe if you saturate the RISC, it stops helping you.

Even if the samples don't die, burden effects could still disrupt a pooled screen by increasing volatility or variation. Speaking just in terms of statistical power, a drastic increase in noise variance is a fate akin to death. Insert scary noises here, but I think the power-maxxing strategy is to push your multiplexing as high as it goes without killing stuff.

#### Sparse death model

Even individually, some of the perturbations might kill your samples or severely limit proliferation. We saw this when we knocked down EOMES, CDC5L, and MYBL2 in PSC-to-endoderm differentiation; see Fig. S2j ([paper](https://www.cell.com/cell-reports/fulltext/S2211-1247(19)30406-1), [pdf supp](https://www.cell.com/cms/10.1016/j.celrep.2019.03.076/attachment/bdc62ae0-3dde-46aa-a6f6-1f3b6e3abe4b/mmc1.pdf)). Note: that was an arrayed screen, not pooled. But it's part of a general trend in stem cell and cancer biology where the most interesting and valuable perturbations can cause differentiation and growth arrest or can otherwise lead to far fewer cells.

So, suppose you apply 1,000 perturbations, and each sample has an independent 50% chance to receive each perturbation. Suppose 10 of the perturbations (1%) will each kill whatever sample they are applied to. How many samples are expected to survive? 

**Only 1/1024 survives**. So this case is pretty harsh. What are your options?

- If the perturbation and cell culture is cheap and the readout is expensive, then you could just apply the perturbation, and filter out dead samples prior to the readout. In a well-based assay, don't bother imaging or sequencing the contents of the well if it looks dead. In a droplet-based assay, it's common to remove dead cells by FACS.
- You could allocate each treatment to fewer cells. If you allocate each treatment to 10% of the cells, then the probability of survival is 0.9^10, which is about 35%. This is much, much better than 1/1024. 

These kinds of considerations are unlikely to be resolved by statistical optimality criteria ... but just for funsies, let's:

- minimize the expected variance of the treatment mean minus control mean,
- with respect to the fraction of samples NOT assigned to each treatment, $p$,
- under the constraint that $k$ treatments are lethal and we don't know which ones.

For one of the non-lethal treatments, we will start with $(1-p)N$ treated samples and $pN$ not treated (not with this treatment). After the lethal treatments have taken their toll, we expect to end up with $p^{k+1}N$ treated samples and $p^k(1-p)N$ controls. If the error variance is $\sigma^2$ and is the same between treatment and control, the difference in means will have sampling variance $\frac{\sigma^2}{p^{k+1}N} + \frac{\sigma^2}{p^k(1-p)N}$. This function approaches infinity at p=0 and p=1. 

Wolfram Alpha says the best power is achieved at $$p = \frac{k+1}{k+2}$$, which gets closer to p=1 (more controls) as k increases (more lethality). Fun fact: this formula even works when $k=0$ and it gives the usual design of half-controls, half-perturbed.

### Recap

- Screens are cool and good.
- Pooled screens with rich phenotypic readouts are cool and good.
- If you're planning a pooled screen, run a pilot experiment to avoid risk of killing the vast majority your samples.
- If you are still worried that your screen might include some lethal treatments, then limit your multiplexing and assign each treatment not to half the samples but rather to 1/(NUM_LETHAL_TREATMENTS+2).