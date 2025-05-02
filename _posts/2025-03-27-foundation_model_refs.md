---
layout: post
title: Some references on genomic foundation models
math: true
tags: misc
---

I recently offered to swap bibliographies with the folks at [Tabula Bio](https://www.lesswrong.com/posts/SsLkxCxmkbBudLHQr/tabula-bio-towards-a-future-free-of-disease-and-looking-for), so I put together a haphazard list of recent work on foundation models in genomics. I always want to know what are the limits of the latest data and how far we can generalize, so this discussion is a great opportunity to explore where Tabula's interests and mine overlap. For three model classes defined by the general type of training data, here are some pointers to a sampling of existing work, plus a brief comment on where these models seem to hit a wall. Read it quick before the SOTA gets up and walks away!

#### Seq2function

Increasingly large models have successfully predicted chromatin state or gene expression from DNA sequence.

- [Basset](https://pmc.ncbi.nlm.nih.gov/articles/PMC4937568/), [Basenji](https://pmc.ncbi.nlm.nih.gov/articles/PMC5932613/), [Enformer](https://www.nature.com/articles/s41592-021-01252-x), [Holmes et al. benchmark](https://www.biorxiv.org/content/10.1101/2025.02.13.638190v1.full.pdf), [DeepSTARR](https://pubmed.ncbi.nlm.nih.gov/35551305/), [DeepFlyBrain](https://www.nature.com/articles/s41586-021-04262-z)

They are good at designing sequences that will be transcribed in specific cell types. But, they struggle with novel alleles, person-to-person variation, and distal enhancers. 

- [Performer](https://www.biorxiv.org/content/10.1101/2024.07.27.605449v1.full), [Ramprasad et al.](https://pmc.ncbi.nlm.nih.gov/articles/PMC11416237/), [Karollus et al.](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-023-02899-9)

In a recent [Very Large Benchmark of enhancer-to-gene pairing](https://www.biorxiv.org/content/10.1101/2023.11.09.563812v1.full.pdf), Enformer is outperformed by task-specific models.

#### seq2seq

I don't know as much about models of DNA sequence alone -- mostly just what the [Owl posts](https://www.owlposting.com/p/a-socratic-dialogue-over-the-utility). 

- [Evo2](https://arcinstitute.org/news/blog/evo2), [DNABERT](https://academic.oup.com/bioinformatics/article/37/15/2112/6128680), [Feng et al. benchmark](https://www.biorxiv.org/content/10.1101/2024.08.16.608288v1)

Even self-supervised, these things can clearly find interesting real biology, like RNA secondary structure.

- [da Silva et al. conference poster](https://iscb.junolive.co/ISMB24/live/exhibitor/ismb2024_poster_1228)

But, some work claims that for a lot of demo tasks, the pretraining isn't helping and non-FM baselines or task-specific models often perform better than the pretrained FM's.

- [Tang et al. benchmark](https://www.biorxiv.org/content/10.1101/2024.02.29.582810v2.full), [BEND benchmarks (pdf; see Table 3)](https://dp-ai-application.oss-cn-zhangjiakou.aliyuncs.com/arxiv/pdf/2311.12570v4.pdf), [Vishniako et al. benchmark](https://www.biorxiv.org/content/10.1101/2024.12.18.628606v1)

#### Transcriptome only

People also train foundation models on transcriptome data without using any DNA sequence information.

- [scFoundation](https://www.nature.com/articles/s41592-024-02305-7), [AIDO-cell](https://www.biorxiv.org/content/10.1101/2024.11.28.625303v1.full), [GeneFormer](https://www.nature.com/articles/s41586-023-06139-9), [scGPT](https://www.nature.com/articles/s41592-024-02201-0#Sec14) 

So far, simple baselines, or task-specific models, or completely different strategies such as learning gene embeddings from text and scientific literature, almost always perform on par with or better than these models. Some examples of studies with this type of finding:

- [Ahlmann-Eltze et al.](https://www.biorxiv.org/content/10.1101/2024.09.16.613342v3)
- [PerturBench](https://arxiv.org/abs/2408.10609v1)
- [PertEval-scFM](https://www.biorxiv.org/content/10.1101/2024.10.02.616248v1) 
- [Csendes et al.](https://www.biorxiv.org/content/10.1101/2024.09.30.615843v1.full) 
- [scEval v7](https://www.biorxiv.org/content/10.1101/2023.09.08.555192v7)
- [Bendidi et al.](https://arxiv.org/html/2410.13956v1)
- [Zhong et al.](https://www.biorxiv.org/content/10.1101/2025.01.29.635607v1)
- (Edit 2025 May 1) [Boiarsky et al.](https://www.biorxiv.org/content/10.1101/2023.10.19.563100v1.full)

I'm a huge Debbie Downer most of the time, so let me clarify something here. I am optimistic about transcriptome foundation models in the long run, but I think we will need richer training data with orders of magnitude more perturbations, like [Tahoe-100M](https://www.biorxiv.org/content/10.1101/2025.02.20.639398v1), [CMAP](https://pubmed.ncbi.nlm.nih.gov/29195078/), the [Cellarity](https://cellarity.com/platform/) Intervention Library, or data internal to [New Limit](https://blog.newlimit.com/p/2025-newlimit-progress-update), [Verge](https://www.vergegenomics.com/approach), or big biotechs. I am also optimistic about [pairing perturbation transcriptomics with DNA sequence models.](https://pmc.ncbi.nlm.nih.gov/articles/PMC11160683/.)