---
layout: post
title: On cellular control networks: enhancer integration
math: true
---

This is not a standalone post. Check out the [intro](https://ekernf01.github.io/GRN_intro) to this series.

--

#### Why go beyond RNA?

Other posts in this series deal with measuring and predicting gene activity via RNA levels. But, there are other important aspects of cell state, like protein levels and DNA modifications. There are $10^5$ to $10^6$ messenger RNA molecules per cell in mammals (ref 1), and one might hope for any important changes to eventually ripple through the transcriptome. Alas, recent work on single-cell RNA-seq coupled with lineage tracing (ref 2) finds that important differences do not appear in the RNA. Specifically, they find these invisible differences can bias hematopoetic progenitor cells towards one fate over another. Molecular mechanisms of cell fate determination are a top priority of the Maehr lab, so we should consider modeling other aspects of cell state besides RNA.

It's difficult to measure proteins en masse the way we measure RNA with deep sequencing. But, technologies for measuring the global state of chromatin (DNA + packaging) are quite mature. In particular, it is possible to measure chromatin accessibility via ATAC-seq (ref 3), and publicly or commercially available variants of that assay can now measure chromatin accessibility in thousands of single cells, sometimes paired with RNA or CRISPR perturbations (refs 4-7). Algorithmic advances claim to allow coupling of independent single cell RNA-seq and ATAC-seq measurements on similar samples (ref 8), though I can't vouch for the performance without trying this out myself. Furthermore, initial work claims that ATAC-seq does capture features correlated with cell fate (ref 9). Below is an illustration of ATAC-seq.

> ![](/Users/erickernfeld/Dropbox/blog posts/ekernf01.github.io/images/atac_cartoon.jpg)
> ![](/images/atac_cartoon.jpg)
> 
> This image shows how ATAC-seq finds accessible DNA. It is from the original ATAC-seq paper, [Buenrostro et al 2015](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4374986/).


#### What does ATAC-seq show?

The main output of ATAC-seq and related technologies is a set of "peaks": spots on the genome with much higher signal than the surrounding areas. Here's what this looks like:

IGV TRACK HERE

These peaks often occur at genes that are either transcriptionally active, or ready to become active (CITATION NEEDED). They also occur at small, discrete sites not located in genes. Non-gene sites that reproducibly appear in ATAC-seq or related datasets are often called *enhancers*. Enhancers are thought to serve as a landing pad for factors influencing transcription at nearby genes, and they are thought to contact genes in 3d, pinching off a loop of intervening DNA. There are hundreds of thousands of enhancers in the human genome (reference???).

#### Associating enhancers with the genes they regulate

To include enhancers in GRN inference, you have to somehow determine which gene each enhancer regulates. There are various ways of doing this.

- **Perturbation**: Some natural or CRISPR-induced genetic variants in enhancers can affect transcription. This is the topic of one of my all-time favorite studies, a highly efficient CRISPR enhancer screen (ref 10). The study found 664 high-confidence gene-enhancer pairs.
- **Correlation**: If enhancer A regulates gene B, then they should be correlated, and this requirement can pinpoint a few models that are compatible with the data. This is the idea behind CICERO (ref 11), a single-cell ATAC analysis package built around its popular RNA counterpart, Monocle. Correlation-based linking of enhancers and genes is also used in a recent immgen consortium atlas of chromatin accessibility in the murine immune system (ref 12).
- **Looping**: There are now many technologies that directly measure DNA looping, with names like 4C, 5C, Hi-C, Micro-C, and PLAC-seq. The general principle behind these techniques is to shear and re-ligate DNA while preserving its 3d structure. This yields chimeric fragments: fragments that are not contiguous in the linear genome sequence, but are nearby one another in 3d. These techniques could potentially help associate enhancers with the genes they regulate. 

 But, existing DNA looping literature is mostly concerned with big questions about principles of genome regulation, not assigning specific regulatory elements to specific genes en masse (e.g. CITE DEKKER CELL CYCLE). The one exception I have seen (so far) is ref 14, which provides thousands of high-confidence gene-enhancer loops in table S6. There have also been detailed studies of the HoxD cluster and the beta-globin locus.
- **Proximity**: Most enhancers regulate a nearby gene. According to ref 12 (the immgen paper), the decay in rates of interaction is exponential with genomic distance. Many enhancers are within ???kb of (their target gene? the nearest gene?), and very few are outside $5 \times 10^5$ basepairs (500kb). Likewise CICERO (ref 11) only bothers testing for links at a distance of $5 \times 10^5$ basepairs (500kb). According to another work (ref 10), the median distance across high-confidence gene-enhancer pairs is about $2.4 \times 10^4$ basepairs (24kb). Ref 13 finds that 27% of enhancers interact with the nearest TSS, and 47% of elements have interactions with the nearest expressed TSS. 


All of the techniques mentioned above are limited in different ways. Often, the problem boils down to low power. 

- Correlation-based analysis is unable to consider long range interactions because the burden of multiple testing is too great. 
- Proximity-based pairing is only a heuristic; studies based on looping, correlation, and perturbation have all found that pairing each enhancer with the nearest gene is wrong most of the time. 
- Perturbation-based pairing has a long way to go. CRISPR-perturbed single-cell RNA-seq is notoriously noisy, and the natural alternatives are limited. 
- Looping assays have very high background signal at short distances due to random polymer looping. Inside $10^6$ basepairs (1Mb), it wouldn't be unusual to see interaction rates increase 10-fold with every 10-fold decrease in linear distance.

For an individual gene and its candidate enhancers, these methods may disagree both systematically and at random. To evaluate them, we need to consider our biological priorities. For my interests, an enhancer is no use unless it can influence cell state, so the most relevant method for gene-enhancer pairing is perturbation with an RNA readout. 

To understand how well the looping agrees with perturbation-based pairing, we can return to ref 10 (Gasperini et al's CRISPR screen). They find that their high-confidence gene-enhancer pairs are enriched for interactions from DNA looping assays overall, but only 71% of their pairs fall in the same looping compartment (for looping-savvy readers, the same TAD), and only a minority of their enhancer hits are correctly paired with a gene by finding the maximum signal from a looping data. I know of no work assessing how well correlation-based approaches match perturbation-based enhancer-gene pairing. Correlation-based pairing is by far the easiest method to generate and analyze data for, so it would be great to know how well it can substitute for perturbation approaches.

#### What regulates enhancers?

To integrate a new class of elements into a GRN model, you need to know the outgoing links, the incoming links, and maybe some internal links. The section above details many approaches to inference of outgoing links: how enhancers regulate genes. Most of these are applicable to internal links as well (how enhancers regulate enhancers). 

Unfortunately, it is more difficult to assess incoming links (how genes regulate enhancers). There are technologies to measure this directly: for example, transcription factor ChIP-seq shows where each individual TF binds, but it requires additional data on top of what was just discussed, and it can only check one TF at a time. ATAC-seq data can be analyzed for TF binding motifs, but this type of analysis is very prone to false positives, and it does not give clean enough results to confirm individual TF-target pairs. Most practitioners use motif analysis by averaging signal across many loci. To infer incoming arrows, motif analysis could provide an initial boost, but the heavy lifting would have to be done by correlation-based analysis, just as in modeling of GRN's using only RNA-seq data.

#### Fragments

Another important advantage of including chromatin state in models is that it can help integrate information from genetic variants. This can be a nice way to tease out cause and effect. For a simple, made-up example, if you're not sure whether SIX1 regulates EYA1 or the other way around, you can look for variants near SIX1 that affect its expression levels. Do they also affect EYA1 expression? If yes, then it's more likely that SIX1 regulates EYA1. 

This paper from FANTOM5 folks gives nice background/contribution regarding enhancers in GRN inference. 

Vipin, D., Wang, L., Devailly, G., Michoel, T., & Joshi, A. (2018). Causal Transcription Regulatory Network Inference Using Enhancer Activity as a Causal Anchor. International journal of molecular sciences, 19(11), 3609.

#### References

1. Cell Biology by the Numbers, http://book.bionumbers.org/how-many-mrnas-are-in-a-cell/
- Lineage tracing on transcriptional landscapes links state to fate during differentiation. Caleb Weinreb, Alejo E Rodriguez-Fraticelli, Fernando D Camargo, Allon M Klein. bioRxiv 467886; doi: https://doi.org/10.1101/467886
- Buenrostro, J. D., Wu, B., Chang, H. Y., & Greenleaf, W. J. (2015). ATAC-seq: A Method for Assaying Chromatin Accessibility Genome-Wide. Current protocols in molecular biology, 109, 21.29.1-9. doi:10.1002/0471142727.mb2129s109
- Chen, X., Miragaia, R. J., Natarajan, K. N., & Teichmann, S. A. (2018). A rapid and robust method for single cell chromatin accessibility profiling. Nature Communications, 9(1), 5345.
- 10X genomics application notes for single-cell ATAC-seq. https://www.10xgenomics.com/solutions/single-cell-atac/#application-notes
- Rubin, A. J., Parker, K. R., Satpathy, A. T., Qi, Y., Wu, B., Ong, A. J., ... & Zarnegar, B. J. (2019). Coupled single-cell CRISPR screening and epigenomic profiling reveals causal gene regulatory networks. Cell, 176(1-2), 361-376. doi: 10.1016/j.cell.2018.11.022
- Cao, J., Cusanovich, D. A., Ramani, V., Aghamirzaie, D., Pliner, H. A., Hill, A. J., ... & Steemers, F. J. (2018). Joint profiling of chromatin accessibility and gene expression in thousands of single cells. Science, 361(6409), 1380-1385.
- Duren, Z., Chen, X., Zamanighomi, M., Zeng, W., Satpathy, A. T., Chang, H. Y., ... & Wong, W. H. (2018). Integrative analysis of single-cell genomics data by coupled nonnegative matrix factorizations. Proceedings of the National Academy of Sciences, 115(30), 7723-7728.
- Cusanovich, D. A., Reddington, J. P., Garfield, D. A., Daza, R. M., Aghamirzaie, D., Marco-Ferreres, R., ... & Trapnell, C. (2018). The cis-regulatory dynamics of embryonic development at single-cell resolution. Nature, 555(7697), 538. PMID: PMC5866720. doi: 10.1038/nature25981.
- Gasperini, M., Hill, A. J., McFaline-Figueroa, J. L., Martin, B., Kim, S., Zhang, M. D., ... & Trapnell, C. (2019). A Genome-wide Framework for Mapping Gene Regulation via Cellular Genetic Screens. Cell, 176(1-2), 377-390.
- Pliner, H. A., Packer, J. S., McFaline-Figueroa, J. L., Cusanovich, D. A., Daza, R. M., Aghamirzaie, D., ... & Adey, A. C. (2018). Cicero predicts cis-regulatory DNA Interactions from single-cell chromatin accessibility data. Molecular cell, 71(5), 858-871.
- Yoshida, H., Lareau, C. A., Ramirez, R. N., Rose, S. A., Maier, B., Wroblewska, A., ... & Tellier, J. (2019). The cis-Regulatory Atlas of the Mouse Immune System. Cell. DOI:https://doi.org/10.1016/j.cell.2018.12.036
- Sanyal, A., Lajoie, B. R., Jain, G., & Dekker, J. (2012). The long-range interaction landscape of gene promoters. Nature, 489(7414), 109.
- Li, G., Ruan, X., Auerbach, R. K., Sandhu, K. S., Zheng, M., Wang, P., ... & Sim, H. S. (2012). Extensive promoter-centered chromatin interactions provide a topological basis for transcription regulation. Cell, 148(1-2), 84-98.