---
layout: post
title: Expression forecasting benchmarks
math: true
permalink: perturbation-benchmarks
tags: grn
---

I wrote about the [boom of new perturbation prediction methods](perturbation-methods). The natural predator of the methods developer is the benchmark developer, and a population boom of methods is naturally followed by a boom of benchmarks. (The usual prediction about what happens after the booms is left as an [exercise to the reader](https://en.wikipedia.org/wiki/Lotka%E2%80%93Volterra_equations).) Here are some benchmark studies that evaluate perturbation prediction methods. For each one, I will prioritize four questions:

- What's the prediction task?
- What is the overall message of this benchmark?
- What are this benchmark's distinctive advantages? 
- Is the code intended to be reused? If I have a new method, should I test it with this benchmark?

I hope this will be a useful gathering place for people to find related work. UPDATE 2025 July: I am retconning this post into a series on virtual cell modeling.

- [Episode 1](perturbation-methods): methods circa mid-2024
- [Episode 2](perturbation-benchmarks): benchmarks circa early 2025 (this post)
- [Episode 3](FM-refs-2025): a broader look at genomic foundation models
- [Episode 4](virtual-cell-june-2025): new developments circa June 2025 

Evals:

- PEREGGRN ([code](https://github.com/ekernf01/perturbation_benchmarking), [paper](https://www.biorxiv.org/content/10.1101/2023.07.28.551039v2)) constitutes the bulk of my PhD work, and therefore I cannot discuss it objectively. If you want my take anyway:
    - Task: predict gene expression for new perturbations not seen during training, or new combinations of perturbations. The post-perturbation expression level is revealed only for the directly perturbed gene. 
    - Message: Judging by most evaluation metrics, on most datasets, the mean and median perform better than most methods. Examples where published methods beat simple baselines occur more often for the specific combination of method, dataset, and eval metric that was used in the original publication. 
    - Advantages: A distinctive advantage is that we include many different cell types and many ways of inducing GoF/LoF. Overexpressing developmentally relevant transcription factors in pluripotent stem cells is very different from knocking out heat-shock proteins in a cancer cell line, so this biological diversity is a big plus.
    - Code: The code is designed for extensibility: new methods can be [added in Docker containers](https://github.com/ekernf01/pereggrn/blob/main/docs/how_to.md#how-to-evaluate-a-new-method), so you can use R, Python, Julia, or anything else. We have instructions to let users to add their own datasets, add their own draft causal network structures, compute new evaluation metrics, or choose among several types of data split that emphasize different tasks.
- [Ahlmann-Eltze et al](https://www.biorxiv.org/content/10.1101/2024.09.16.613342v3) focuses on comparing foundation models to simple baselines. 
    - Task: predict gene expression for new perturbations not seen during training, or new combinations of perturbations. Only the name of the perturbed gene is revealed at test time.
    - Message: This study includes a peculiar linear baseline that beats GEARS, scGPT, and scFoundation almost uniformly when predicting genetic interactions on the Norman data or predicting novel perturbation outcomes on other perturb-seq datasets. This is an important finding that casts doubt on the value of pretrained foundation models or Gene Ontology for these tasks. 
    - Advantages: The clear advantage of this study is their clever, unique linear baseline. 
    - Code: I don't think this work is intended to be re-used and extended by other teams aside from the authors, so my advice would be: read it; heed it; don't need to repeat it. If I hear otherwise I'll update this post.
- [PerturBench](https://arxiv.org/abs/2408.10609v1) targets slightly different tasks but uses a lot of the same ingredients. 
    - Task: They focus on transfer learning across cell types or experimental conditions: if you know how a perturbation affects gene expression in one cell type, can you predict what would happen in a different cell type? They also have a separate genetic interaction prediction task.
    - Message: They find leading performance using simple, but nonlinear, latent-space arithmetic. 
    - Advantages: This work took thousands of GPU hours and is distinguished by the breadth of coverage over deep-learning methods. 
    - Code: Their work is very clearly meant to be reused, so if you're a methods developer looking for a quick way to access a lot of results, you should take a look. Their framework seems to be highly flexible, especially the data splitting: you can manually specify what goes in the test set. Their way of incoporating new methods seems to be python-only, but if your method is written in R, Julia, or something else, maybe you can rig it up to call your method using a subprocess. I am not sure how to add new datasets -- I think that's a work in progress. 
- [CausalBench](https://arxiv.org/abs/2210.17283) is mostly geared towards fancy causal DAG structure inference methods and towards network structure recovery, but they do sometimes test on held-out interventions like the rest of the projects listed here. 
    - Task:  I don't understand the data split or the evaluation methods well enough to comment.
    - Message: The authors' own takeaway is that causal inference methods do not necessarily make better predictions than alternative methods with no underlying causal theory or no way of handling interventions in the training data. 
    - Advantages: This benchmark is one of the pioneers in this space and it brings together algorithms from somewhat-disparate communities working on causal statistics and gene regulation.
    - Code: This work is from an open challenge by GSK that is now over. It is not clear to me whether it is intended to still be used, but I'm optimistic about this: the interface looks very convenient, and since it was for a competition, you can be sure the interface has been tested by several independent teams. Their way of incoporating new methods seems to be python-only, but if your method is written in R, Julia, or something else, maybe you can rig it up to call your method using a subprocess. This framework offers two datasets and I am not sure how to add new datasets.
- Edit 2024 Oct 14: [PertEval-scFM](https://www.biorxiv.org/content/10.1101/2024.10.02.616248v1) compares perturbation prediction performance by using a variety of foundation models. 
    - Task: This set of benchmarks is based on the Norman 2019 CRISPRa data. It focuses on the information content of latent embeddings. All models are used in a way that is similar to GeneFormer's setup: they obtain a perturbed embedding by zeroing out the targeted gene (regardless of KO vs OE), and they learn to predict training-set post-perturbation expression from the perturbed embedding. Only methods producing embeddings are included, and the same decoder architecture is used across all models.
    - Message: They state it super clearly, so I'll quote. "Our results show that [single-cell RNA-seq foundation model] embeddings do not provide consistent improvements over baseline models... Additionally, all models struggle with predicting strong or atypical perturbation effects." 
    - Advantages: This work includes an impressive variety of foundation models. 
    - Code: I am not sure whether they intend to make this work extensible by outside developers. 
- Edit 2024 Oct 16: [This brief benchmark](https://www.biorxiv.org/content/10.1101/2024.09.30.615843v1.full) ...
    - Task: ... uses the same data splits as the initial scGPT demos on the Adamson 2016 perturb-seq data, with new metrics and new baselines. 
    - Message: I'll quote. "[W]e found that even the simplest baseline model - taking the mean of training examples - outperformed scGPT." They interpret: "In the Adamson dataset, we observed high similarity between the perturbation profiles, with a median Pearson correlation of 0.662. This result is not entirely unexpected, given that the Adamson study focused on perturbations specifically targeting endoplasmic reticulum homeostasis, where similar transcriptional responses might be expected. Only a few genes exhibited anti-correlated expression profiles. Similarly, in the Norman dataset, there was a high degree of similarity between perturbation profiles, with a median Pearson correlation of 0.273." 
    - Advantages: The advantage of this study is a careful, skeptical look at the scGPT evals and the info content of the data.
    - Code: The infrastructure doesn't look like this is meant to be extended to new methods and datasets by third parties. 
- Edit 2024 Dec 12: [scEval v7](https://www.biorxiv.org/content/10.1101/2023.09.08.555192v7) includes perturbation prediction evals of scGPT, Geneformer, tGPT, SCimilarity, UCE, scFoundation, and GEARS on the Norman, Adamson, and Dixit datasets. 
    - Task: similar to GEARS, they split perturb-seq datasets so that some perturbations or combinations thereof are not present in the training data.
    - Message: They did not see improvement of foundation models over GEARS: "Since GEARS has robust performance, the requirement of developing FMs for handling such task is not clear."
    - Advantages: This is a huge project with evaluation of foundation models on many other types of task. I have not fully digested it yet so I can't comment on specific advantages, but if you are working on gene expression foundation models, it's definitely worth a detailed look at this work. 
    - Code: This work is clearly intended to be re-used and indeed it is [already being adopted by developers of new methods](https://www.nature.com/articles/s41467-025-59926-5).
- Edit 2025 Jan 24: [C. Li et al.](https://www.biorxiv.org/content/10.1101/2024.12.20.629581v1.full) includes evaluations of linear models, linear models of scGPT embeddings, CellOracle, GEARS, scGPT, scFoundation, and the mean of the training data (called "KnownAverage"). They use the pre-existing [scPerturb](https://www.biorxiv.org/content/10.1101/2022.08.20.504663v3) collection. There are several tasks shown in this work, but I'll focus on the theme of this blogpost series, which is ...
    - Task: ... training on perturbation transcriptomics data and predicting differential expression in response to new genetic perturbations that were not seen during training.
    - Message: "Notably, the KnownAverage method consistently demonstrated some of the best overall performance across all four types of metrics."
    - Advantages: This work uses a large, diverse collection of data that I have not seen used in any similar benchmarks, and the biological diversity is a key advantage.
    - Code: As of 2025 jan 24, the code is on [github](https://github.com/Chen-Li-17/CellPB/tree/main), but perusing the repo, there are no installation or usage instructions linked in the README. The code itself is almost all in notebooks, which [are notorious](https://academic.oup.com/gigascience/article/doi/10.1093/gigascience/giad113/7516267) for poor reproducibility, so I would not currently recommend this framework for third-party reuse.
- Edit 2025 May 25: [L. Li et al.](https://www.biorxiv.org/content/10.1101/2024.12.23.630036v1#libraryItemId=17605488) provide a systematic benchmarking framework for perturbation predictions including diverse data and algorithms across three different tasks. They evaluate (among others) scGPT, scFoundation, GEARS, scELMo, and an MLP baseline.
    - Task: They include cell-type transfer and interaction prediction, but here I'll focus on within-cell-type prediction of unseen genetic perturbations. They use 10 perturb-seq datasets and they use a GEARS-like split where some perturbations are reserved for the test set and only the name of the perturbed gene is revealed at test time.
    - Message: They write "[W]hile advanced models outperform simple baselines and better capture targeted perturbation signals, challenges in generalization and distributional fidelity persist." However, I believe that omitting the training-data-mean baseline is a crucial gap in this study, and they even wrote "[W]hile foundation models frequently outperform simpler methods, they tend to converge on population averages[.]"
    - Advantages: The biological diversity of the benchmark data is a strong point of this study. The authors also provide some nice follow-up to test different types of generalization.  
    - Code: The code does not look like it is intended to be extended by third-party developers. 
- Edit 2025 May 25: [Wong et al.](https://www.biorxiv.org/content/10.1101/2025.01.06.631555v3#libraryItemId=17605840) include evaluations of scGPT and GEARS on the Adamson, Norman, and K562 essential-gene perturb-seqs.
    - Task: They use a GEARS-like split, leaving some perturbations out of the training data and at test time revealing only the name of the perturbed gene. 
    - Message: "[A] simple baseline method ... outperforms both state of the art (SOTA) in DL and other proposed simpler neural architectures, setting a necessary benchmark to evaluate in the field of post-perturbation prediction."
    - Advantages: One factor distinctive in this study and uncommon elsewhere is that they talk explicitly what happens when you focus too much on the directly perturbed gene in your evals. That's really a technical effect relating to whatever flavor of OE or CRISPR was used, not the biological effect of primary interest. This study also compares fine-tuned scGPT with either weights from pretraining or randomly initialized weights, which is a really cool way to determine how much info is contributed by pretraining.  
    - Code: I don't think the code is intended to be extended by third-party developers. 
- Edit 2025 May: geneRNIB ([paper](https://www.biorxiv.org/content/10.1101/2025.02.25.640181v1.full), [docs](https://genernib-documentation.readthedocs.io/en/latest/)) compares gene regulatory network inference methods including SCENIC, GRNBoost2, scPRINT, PPCOR, FigR, and CellOracle on the basis of their ability to help predict perturbation responses. 
    - Task: there's a couple of different tasks, but most similar to the other work on this page is what they call "R2". In R2, they hold out some perturbations, using some for training and others for evaluation. They train ridge regression models to predict gene expression from TF expression. The relevant TF's are selected using the competing GRNs. During evaluation, they reveal expression for all TF's. 
        - This is easier than PEREGGRN's prediction task, which reveals the expression of only the perturbed genes at test time, and as a consequence they see more meaningful differences across methods instead of everything getting crushed by a causally vacuous baseline.
        - This could in principle allow algorithms to win based on non-causal effects. For example, the microRNA hsa-miR-876-5p [targets both FOXA2 and FAXC](https://mirdb.org/cgi-bin/search.cgi?searchType=miRNA&searchBox=hsa-miR-876-5p&full=1), so a model could benefit from saying FOXA2 binds FAXC, even though [FOXA2 does not bind FAXC](https://chip-atlas.dbcls.jp/data/hg38/target/FOXA2.10.html).
    - Message: "[S]imple models with fewer assumptions often outperformed more complex pipelines. Notably, gene expression-based correlation algorithms yielded better results than more advanced approaches incorporating prior datasets or pre-trained on large datasets."
    - Advantages: This work allows head-to-head comparison of networks or network inference methods in a way that has been difficult historically. It also uses biologically diverse data, including the Nakatake PSC data. 
    - Code: This work has outstanding extensibility and durability as a part of the Single Cell OpenProblems umbrella.
