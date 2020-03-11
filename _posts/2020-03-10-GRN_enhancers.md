---
layout: post
title: Enhancer integration (gene regulatory network post series)
permalink: /GRN_enhancers/
math: true
---

This is not a standalone post. Check out the [intro](https://ekernf01.github.io/GRN_intro) to this series.

--

#### Why go beyond RNA?

Other posts in this series mostly deal with measuring and predicting RNA levels. But, we know that important parts of the human regulatory network are contained in other types of molecules: for example, of all mutations related to autoimmunity, [90% are not in a coding region](https://www.nature.com/articles/nature13835#close). This post discusses a class of gene-like entities called *enhancers* that have recently emerged as an interesting and potentially useful counterpart to coding genes. Teams are beginning to catalog enhancers and build them into network models. This post will survey how that's being done and will convey one important current question: how do we best connect each enhancer with the gene(s) it helps control?

#### The technologies

Technologies for measuring the global state of DNA packaging (a.k.a. "chromatin") are now quite mature. The technologies have Big Fancy Names such as:

- ChIP-seq: Chromatin Immuno-Precipitation followed by Sequencing
- ATAC-seq: Assay for Transposase-Accessible Sequencing

They use specially selected molecules that home in on interesting regions of DNA, enriching those regions for sequencing and leading to "peaks" of activity that can be displayed according to their location of the genome. (Examples below.) In this post, I'll talk mostly about ATAC-seq.
 
#### What does ATAC-seq show?

[ATAC-seq](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4374986/) measures whether DNA is "open" enough for proteins to bind it, and it does this by sending in a protein called a transposase that can cut and mark those regions. Publicly or commercially available variants of that assay can now measure DNA accessibility in [thousands](https://www.10xgenomics.com/solutions/single-cell-atac/#application-notes) of [single cells](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6297232/), sometimes [paired with RNA measurements](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6571013/) or [genetic perturbations](https://ekernf01.github.io/genetic_interactions/). This post outlines ATAC-seq and how the results might be incorporated in network inference.


![](/Users/erickernfeld/Dropbox/blog posts/ekernf01.github.io/images/GRN_graphics/atac_cartoon.jpg)
![](/images/GRN_graphics/atac_cartoon.jpg)

> How ATAC-seq finds accessible DNA. This is from the original ATAC-seq paper, [Buenrostro et al 2013](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3959825/).

The main output of ATAC-seq and related technologies is a set of "peaks": spots on the genome with much higher signal than the surrounding areas. Here's what this looks like (alongside competing technologies called FAIRE-seq and DNase-seq).

![](/Users/erickernfeld/Dropbox/blog posts/ekernf01.github.io/images/GRN_graphics/peaks.png)
![](/images/GRN_graphics/peaks.png)


These peaks often occur at genes that are either transcriptionally active, or ready to become active. They also occur at small, discrete sites not located in genes, and these are often called *enhancers*. Enhancers are thought to serve as a landing pad for factors influencing transcription at nearby genes, and they are thought to contact genes in 3d, pinching off a loop of intervening DNA. [There are millions](https://academic.oup.com/nar/article/48/D1/D58/5628925) of regions in the human genome that some people call enhancers. (I need to read more before I form an opinion about these figures.)

#### Associating enhancers with the genes they regulate

To include enhancers in GRN inference, you have to somehow determine which gene each enhancer regulates. There are various ways of doing this.

- **Perturbation**: Some natural or CRISPR-induced genetic variants in enhancers can affect transcription. This is the topic of one of my all-time favorite studies, a [highly multiplexed CRISPR enhancer screen by Gasperini and coauthors](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6690346/). The study found 664 high-confidence gene-enhancer pairs.
- **Correlation**: If enhancer A regulates gene B, then they should be correlated, and this requirement can pinpoint a few models that are compatible with the data. This is the idea behind [CICERO](https://pubmed.ncbi.nlm.nih.gov/30078726-cicero-predicts-cis-regulatory-dna-interactions-from-single-cell-chromatin-accessibility-data/), a single-cell ATAC analysis package built around its popular RNA counterpart, Monocle. Correlation-based linking of enhancers and genes is also used in a recent [immgen consortium atlas of chromatin accessibility in the mouse immune system](https://doi.org/10.1016/j.cell.2018.12.036).
- **Looping**: There are now many technologies that directly measure DNA looping, with names like 4C, 5C, Hi-C, Micro-C, and PLAC-seq. The general principle behind these techniques is to shear and re-ligate DNA while preserving its 3d structure. This yields fragments that are not contiguous in the linear genome sequence, but are nearby one another in 3d; sequencing can detect this as a way to infer 3d structure. These techniques could potentially help associate enhancers with the genes they regulate. 

 Note that existing DNA looping literature is mostly concerned with big questions about principles of genome organization (such as [during the cell cycle](https://genome.cshlp.org/content/29/2/236.long)), rather than assigning specific regulatory elements to specific genes en masse. The one exception I have seen (so far) is [this](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3339270/), which provides thousands of high-confidence gene-enhancer loops in table S6. There have also been detailed studies of the HoxD cluster and the beta-globin locus.
- **Proximity**: Most enhancers regulate a nearby gene. According to [that same ImmGen paper I mentioned above](https://doi.org/10.1016/j.cell.2018.12.036), the decay in rates of interaction is fast (exponential with genomic distance). In that study, many enhancers are within ???kb of (their target gene? the nearest gene?), and very few are outside $5 \times 10^5$ basepairs (500kb). Likewise CICERO only bothers testing for links at a distance of $5 \times 10^5$ basepairs (500kb). According to [Gasperini et al's multiplexed CRISPR enhancer screen](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6690346/), the median distance across high-confidence gene-enhancer pairs is about $2.4 \times 10^4$ basepairs (24kb). The looping paper mentioned above  finds that 27% of enhancers interact with the nearest TSS, and 47% of elements have interactions with the nearest expressed TSS. Some tools that need to connect enhancers with their targets simply take the nearest gene -- for example, [GREAT](https://pubmed.ncbi.nlm.nih.gov/20436461-great-improves-functional-interpretation-of-cis-regulatory-regions/) does this. This won't work if you need a high fraction of correct pairings, but it's OK in situations where you only need to enrich for correct answers. 


All of the techniques mentioned above are limited in different ways. 

- Correlation-based analysis very promising, but doesn't give clear answers about causality. 
- Proximity-based pairing is only a heuristic; studies based on looping, correlation, and perturbation have all found that pairing each enhancer with the nearest gene is wrong most of the time (see below). 
- Perturbation-based pairing has a long way to go. CRISPR-perturbed single-cell RNA-seq is notoriously noisy, and the natural alternatives are limited. Gasperini et al's screen sequenced 250k cells and found only 664 enhancer-gene pairs. There are hundreds of thousands of enhancers in the genome, so to scale up that tactic naively, we'd need to sequence hundreds of millions of cells. This may be affordable with some variant of the incredible [MERFISH](https://science.sciencemag.org/content/362/6416/eaau5324), but we're not there yet.
- Looping assays have very high background signal at short distances due to random polymer looping. Inside $10^6$ basepairs (1Mb), it wouldn't be unusual to see interaction rates increase (very roughly) 10-fold with every 10-fold decrease in linear distance, [e.g. in fig 1 here](https://www.biorxiv.org/content/10.1101/639922v1.full.pdf). This makes it really hard to separate noise from individual enhancer-gene interactions -- though the overall enrichment is clear from [the supplemental PDF (fig S10)](https://www.biorxiv.org/content/10.1101/639922v1.supplementary-material). 

 It also raises a point about physical proximity versus functional relevance. Nearby genes and enhancers may scrape past each other regularly at random, but does that mean that they share transcriptional machinery or that perturbations of the enhancer will affect expression of the gene? 
 
For my interests, an enhancer is no use unless it can influence cell state, so the gold standard for gene-enhancer pairing is perturbation of the enhancer with an RNA readout. Because of this, I judge each method by how well it can mimic perturbation data. 

To understand how well the looping agrees with perturbation-based pairing, we can return to Gasperini et al's CRISPR screen. They find that their high-confidence gene-enhancer pairs are enriched for interactions from DNA looping assays overall, but only 71% of their pairs fall in the same looping compartment (for looping-savvy readers, the same TAD), and only a minority of their enhancer hits are correctly paired with a gene by finding the maximum signal from a looping data. I'd like to read more about this, but I am currently not optimistic about looping assays for clean functional gene-enhancer pairing. Looping will at best generate incomplete short-lists of candidates that will need to be refined by other methods.

I know of no work assessing how well correlation-based approaches match perturbation-based enhancer-gene pairing. Correlation-based pairing is by far the easiest method to generate and analyze data for, so it would be great to know how well it can substitute for perturbation approaches.

#### What regulates enhancers?

To integrate a new class of elements into a GRN model, you need to know the outgoing links, the incoming links, and maybe some internal links. The section above details many approaches to inference of outgoing links: how enhancers regulate genes. Most of these are applicable to internal links as well (how enhancers regulate enhancers). 

Unfortunately, it is more difficult to assess incoming links (how genes regulate enhancers). There are technologies to measure this directly: for example, transcription factor ChIP-seq shows where each individual TF binds, but it requires additional data on top of what was just discussed, and it can only check one TF at a time. 

ATAC-seq and DNase-seq data can be analyzed for TF binding motifs, but this type of analysis is very prone to false positives. The lowest q-value I have ever seen when looking for [the Foxn1 motif](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5033077/) is about 0.4, meaning this motif is very difficult to distinguish from typical strings of nucleotides. Even if the motif is detected in a region of open chromatin, the factor is not bound; there are [other mechanisms to consider](https://pubmed.ncbi.nlm.nih.gov/26550823-dna-dependent-formation-of-transcription-factor-pairs-alters-their-binding-specificity/?dopt=Abstract). This method does not give clean enough results to confirm individual TF-target pairs, so most practitioners clean up the signal either by averaging across many loci (as in [TERA analysis](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4336237/)) or by filtering with transcriptome data (as in [SCENIC](https://www.nature.com/articles/nmeth.4463) and [CellOracle](https://github.com/morris-lab/CellOracle/)). To infer incoming arrows, motif analysis could provide an initial boost, but I suspect the heavy lifting will have to be done by perturbation screens or correlation analysis rather than direct binding.

### Fragments

- I discussed chromatin data in the context of this grand endeavor to model the human (gen-, epigen-, transcript-)ome, but another important advantage of including chromatin state in models is that it can help integrate information from genetic variants. This can be a nice way to tease out cause and effect. For a simple, made-up example, if you're not sure whether SIX1 regulates EYA1 or the other way around, you can look for variants near SIX1 that affect its expression levels. Do they also affect EYA1 expression? If yes, then it's more likely that SIX1 regulates EYA1. This idea is called an "expression quantitative trait locus" or "eQTL".

- This paper from the FANTOM5 folks gives nice background/contribution regarding enhancers in GRN inference. 

 > Vipin, D., Wang, L., Devailly, G., Michoel, T., & Joshi, A. (2018). Causal Transcription Regulatory Network Inference Using Enhancer Activity as a Causal Anchor. International journal of molecular sciences, 19(11), 3609.




### References

- Cell Biology by the Numbers, http://book.bionumbers.org/how-many-mrnas-are-in-a-cell/
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
