---
layout: post
title: Data resources for gene regulatory network modeling
permalink: /GRN_datasets/
math: true
---

This is not a standalone post. Check out the [intro](https://ekernf01.github.io/GRN_intro) to this series.


Benchmarking

- The DREAM5 competition data consist of microarray (RNA) data for yeast (Saccharomyces cerevisiae), bacteria (E. coli, S. aureus), and simulated data. This is a popular dataset for benchmarking methods, because it comes with gold-standard sets of known regulatory relationships. Note, however, that the data [may have some batch effects](https://doi.org/10.1111/j.1749-6632.2008.04100.x).
- The [Connectivity Map](https://www.broadinstitute.org/connectivity-map-cmap) at the Broad Institute offers transcriptomic profiles for several cell lines under thousands of different genetic and chemical perturbations. This seems like a gold mine for testing regulatory network models, and I can't figure out why it isn't more heavily used. I am planning to find out the hard way soon.

Chromatin

- The FANTOM5 consortium has gathered CAGE-seq data in a wide array of human tissues and cell lines (about 400 total). CAGE-seq captures enhancers and genes, and it has been used for global network inference based on locations of active transcription factor binding motifs (http://regulatorycircuits.org/). It has also been used for prediction of reprogramming factors (http://www.mogrify.net/). 

- The ENCODE project has produced DNase-seq data on a wide range of human cell types, measuring active transcription factor binding motifs. For more information, visit <http://www.regulatorynetworks.org/>  and look for the "about" page. 
- The [sci-ATAC atlas](http://atlas.gs.washington.edu/mouse-atac/) covers eight organs in the adult mouse.
- The ImmGen consortium has produced a dataset covering chromatin accessibility in 86 mouse immune cell types, discussed [here](https://doi.org/10.1016/j.cell.2018.12.036).
- [ENCODE](<https://www.encodeproject.org/search/?type=experiment&replicates.library.biosample.uuid=d8ca0867-13cd-40df-9de0-29f9da53d935&status!=deleted&status!=revoked&status!=replaced&limit=all>) and [ChEA](<https://www.ncbi.nlm.nih.gov/pubmed/20709693>) have direct measurements of transcription factor binding, though people often prefer the data above because the direct measurements aren't even close to measuring every transcription factor in every cell type, whereas accessibility data can get closer to this ideal.

RNA

- Large, diverse collections of bulk RNA data are available from [the gTEX consortium](https://gtexportal.org/home/) and from the creators of [CellNet](http://pcahan1.github.io/cellnetr/). These have both been used for network modeling.
- Large, diverse collections of single-cell RNA data are emerging very fast right now. Some notable examples done with mice include the [MCA](http://bis.zju.edu.cn/MCA/), the [Tabula Muris](https://tabula-muris.ds.czbiohub.org/), the [sci-RNA embryo data](http://atlas.gs.washington.edu/hub/), the [mouse gastrulation map](https://marionilab.cruk.cam.ac.uk/MouseGastrulation2018/), the [early mouse organogenesis map](https://doi.org/10.1038/s41556-017-0013-z), the [developing endoderm atlas](https://www.nature.com/articles/s41586-019-1127-1), and the [entire mouse nervous system](https://www.cell.com/cell/pdf/S0092-8674(18)30789-X.pdf). Similar efforts have mapped out lineage trees in the zebrafish ([1](https://science.sciencemag.org/content/360/6392/eaar3131), [2](https://science.sciencemag.org/content/360/6392/981.abstract), [3](https://www.biorxiv.org/content/10.1101/738344v1.full.pdf)) and the planarium ([1](https://science.sciencemag.org/content/360/6391/eaaq1723), [2](https://science.sciencemag.org/content/360/6391/eaaq1736)). Of course, the most thorough ambitions are inspired by the need to understand [humans](https://elifesciences.org/articles/27041.pdf).
