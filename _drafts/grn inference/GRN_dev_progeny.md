---
layout: post
title: Inferring developmental pathways from RNA-seq data
permalink: /GRN_dev_progeny/
math: true
---

A small number of "pathways" -- Wnt, BMP, FGF, SHH, retinoic acid, TGF-beta, NF-kappa B, Notch, and others -- are reused frequently throughout stem cell biology and embryonic development. (If you're not familiar with developmental pathways, skip to the appendix for a quick explanation.) Typically, stem cell biologists will screen, *en masse*, collections of stimuli related to these pathways. They are especially keen on testing pathways that have been shown to play a role in embryonic development of the cell type they are trying to differentiate their stem cells towards. Collectively, it is a major project of stem cell biology and embryology to explain development via these pathways and others like them.

Thus, one very common approach in RNA-seq analysis is to find a set of genes that change between cell types or conditions, and plug them into a giant database to see if anything comes up. Often, the most exciting hits -- the ones that are clear and actionable -- are related to developmental pathways. This process could stand to be improved. First, commonly used databases often contain a bunch of other stuff that doesn't help plan a follow-up experiment -- things like "glycogen synthesis". Second, the multiple testing burden of including tens of thousands of (mostly non-actionable?) query terms is horrendous, and the null hypotheses are questionable, so the p-values are not trustworthy. Third, these tools require a comparison: cell type A versus cell type B. They can't just look at an expression profile and tell you whether the pathway seems to be active.

A lovely tool called PRoGeny ([paper](http://doi.org/10.1038/s41467-017-02391-6)) has made progress on these issues. It has a small set of cancer-relevant pathways. With only those pathways, the authors could use well-understood cancer mutations to validate it. It is set up to predict which ones are active given any single RNA-seq sample. An extension of this tool to cover developmental pathways would be tremendously useful. Single-cell RNA datasets on stem cells and embryonic development could be automatically supplemented with reasonable and readily testable hypotheses about relevant pathways. This could even lead to new findings about cell fate control.

What would this require? In terms of datasets, the PRoGeny folks used 208 public datasets from GEO (568 experiments, 2652 microarrays). This was a ton of work; their supplement is ... voluminous. Their search terms included the pathway itself (e.g. "egf") plus related terms (e.g. "growth factor", "epiregulin"), and then they read every study and decided whether to use it or not. That's a pretty stiff barrier to entry. Other than that, the coding seems simple enough for one person to implement in R. It could be interesting to try a non-exhaustive version of this approach: rather than using every microarray study of Wnt (yikes), you could choose the first 10 or 15 that fit your criteria. 

### Appendix with an example "pathway"

Here's a great overview of "the Wnt pathway" ([page](http://web.stanford.edu/group/nusselab/cgi-bin/wnt/), [paper](http://www.doi.org/10.1016/j.cell.2012.05.012)). Wnt1 is a secreted factor (a protein) discovered independently in cancer biology and developmental biology. Like all developmentally important factors, it interacts with a bunch of other molecules that have bizarre names, and it is highly evolutionarily conserved. The proteins it acts through (such as cell surface receptors and transcription factors) have profound, developmentally-related phenotypes when you knock'em out. They can also be [inhibited via small molecules](http://doi.org/10.1002/pro.3122), which is really handy for stem cell biology, because unlike knockout out a gene, it's temporary. There are many related genes in the Wnt family -- Wnt1, Wnt2, Wnt3A, etc. Together, this mess is known as "the Wnt pathway". 

> ![](/Users/erickernfeld/Dropbox/blog posts/ekernf01.github.io/drafts/grn inference/Wntsignaling.png)
> The core of the Wnt pathway.
> 
> ![](/Users/erickernfeld/Dropbox/blog posts/ekernf01.github.io/drafts/grn inference/wnt inhibitors.jpg)> Small molecule inhibitors of a Wnt-related protein.