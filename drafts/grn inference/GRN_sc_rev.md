---
layout: post
title: What you should know about the single-cell genomics revolution
permalink: /GRN_sc_rev/
math: true
---

This is not a standalone post. Check out the [intro](https://ekernf01.github.io/GRN_intro) to this series.

-

The 2010s saw the rise of [ubiquitous smartphones](https://www.statista.com/statistics/201183/forecast-of-smartphone-penetration-in-the-us/), [internet from the sky](https://caseyhandmer.wordpress.com/2019/11/02/starlink-is-a-very-big-deal/), [mass-market electric cars](https://en.wikipedia.org/wiki/Tesla,_Inc.#History), superhuman [Go](https://en.wikipedia.org/wiki/AlphaGo) and [StarCraft](https://deepmind.com/blog/article/alphastar-mastering-real-time-strategy-game-starcraft-ii) AI's, [deepfakes](https://en.wikipedia.org/wiki/Deepfake) and [photorealistic image synthesis](https://www.youtube.com/watch?time_continue=27&v=kSLJriaOumA&feature=emb_logo), [flying rifles](https://www.youtube.com/watch?time_continue=2&v=v5q--PYfs8Q&feature=emb_logo), [expansion microscopy](http://expansionmicroscopy.org/), [superresolution electron microscopy](https://www.frontiersin.org/articles/10.3389/fmolb.2019.00072/full#h1), [CRISPR gene editing](https://en.wikipedia.org/wiki/CRISPR#History), [massive-scale human genetics](https://en.wikipedia.org/wiki/UK_Biobank), and [CAR-T cell therapy](https://www.dana-farber.org/cellular-therapies-program/car-t-cell-therapy/faq-about-car-t-cell-therapy/). Other than smartphones, though, the biggest change in my daily life has come from a different technological revolution.

### Single-cell genomics

Back in 2014, a Stanford team published a paper with RNA sequencing and quantification in 198 individual mouse lung cells from multiple stages of development. This team was able to group cells via unsupervised machine learning, with no strong biological assumptions about what subpopulations are present. The paper was a big hit, coming out in Nature and being cited hundreds of times (as of December 2019). More importantly, it was an indicator of ongoing trends. In 2015, two Boston-area teams came out with microfluidics systems that could individually barcode thousands of cells for sequencing, and the floodgates opened. A droplet-based capture technology was licensed and optimized by a young startup called 10X Genomics, and by 2016, 10X had begun selling instruments and reagents for easier, deeper sequencing of tens of thousands of cells. In 2017, 10X genomics published a [dataset with >1M cells](https://www.10xgenomics.com/blog/our-13-million-single-cell-dataset-is-ready-to-download), and groups in Seattle and elsewhere were extended protocols to include chromatin state. Around 2018, capacity was added to measure limited numbers of genetic perturbations and surface proteins. By 2019, multiple technologies had emerged to facilitate "spatial transcriptomics", measuring gene activity along with shape and relative positions of cells. 

People continue to debate how best to use these new technologies, but there is a broad consensus that they are game-changing for immunology, developmental biology, stem cell biology, and brain science, primarily because of the potential to build relatively unbiased and comprehensive catalogues of cell types. An international consortium, the [human cell atlas](https://www.humancellatlas.org/), is now enacting plans to catalogue all human cell types. The quantity, quality, and diversity of data provides a huge opportunity for regulatory network modeling. Check out the [GRN datasets](https://ekernf01.github.io/GRN_datasets) post for a few more specifics.


