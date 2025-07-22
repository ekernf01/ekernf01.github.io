---
layout: post
title: What should we do once the virtual cells work?
math: true
tags: stat_ml grn
permalink: virtual-cell-saturation
---

The rate of virtual-cell publications seems to be hitting an inflection point. My [list from late 2024](perturbation-methods) feels hopelessly out of date after [recent huge model releases](virtual-cell-june-2025) from well-resourced organizations with elite ML talent. One could be forgiven for thinking there's no room to contribute and every attempt will get out-performed, scooped, or otherwise forgotten. This blog post explores career strategy for the forlorn functional genomics analyst in a post-virtual-cell era. 

### Unravel a mechanism

High-performance virtual cells will be deep neural network models that follow Sutton's bitter lesson. They will not literally encode specific mechanisms of the type you see when you google "Wnt pathway". It will be of practical and scientific use to gradually supplement empirical findings and virtual cell claims with mechanistic models. Perhaps this could be fully automated, but for now, it is still useful to have a human analyst sketch out the simplest set of interactions compatible with the observed and predicted system behavior, then plan experiments needed to test the model. 

- Interpretability tool: a model emulator that converts a virtual cell into a GRN-type model, or an ensemble of them?
- Generalize across cell types so that a single model can reflect an ENTIRE reprogramming trajectory with CONSISTENT mechanisms.
- Model both cis- and trans-regulation. Like [CORGI](https://www.biorxiv.org/content/10.1101/2025.06.25.661447v1) or Anshul's Sox9 transfer learning work.
- Discuss identifiability. 

### Extend to a new phenotype

Transcriptomics is useful for initial guesses about cell function and optimization thereof, but for cell therapy and faithful model systems, the crucial readout is often posttranscriptional: insulin release, toxin metabolism, ECM remodeling, degranulation, O2 transport, or sheer size. Virtual cells may offer new possibilities for few-shot prediction or causal modeling of diverse phenotypes, but this will need to be validated on a case-by-case basis. 

### Extend to a new cell type

Virtual cell performance will lag behind on cell types that are hard to isolate (neutrophil) or that have no corresponding cancer cell lines. Specialist labs or companies with unique  will need analysts to adapt virtual cell models to their new contexts.

### Build integrative models

Maybe you study pancreatic cancer organoids

### Validate or refine prior findings about "stemness"

Methods like CytoTrace and StemFinder showed that simple properties of the transcriptome correlate with differentiation potential. Do virtual cell models reflect this potential? For example, do random perturbations yield more varied (predicted) outcomes in cells with higher Cytotrace potential? 

### Make harder benchmarks

Here are some things that will take longer. 

- From the Waddington-OT paper, two difficult prediction tasks from PSC reprogramming. 
    - Long-term evolution of cell state. After receiving OSKM, cells undergo a complex sequence of states over the span of a couple of weeks. 
    - Stochastic outcomes. Most cells receiving OSKM overexpression do NOT become pluripotent. They die or turn into weird fibroblasts. 
- 