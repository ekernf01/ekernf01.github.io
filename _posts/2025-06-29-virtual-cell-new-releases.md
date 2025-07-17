---
layout: post
title: A recap of virtual cell releases circa June 2025
math: true
tags: grn
permalink: virtual-cell-june-2025
---

In October 2024, I [twote](https://x.com/ekernf01/status/1845809278197567542) that "something is deeply wrong" with what we now call virtual cell models. A lot has happened since then: modelers are advancing new architectures and sources of information; evaluators are probing results more deeply; and synthetic biology wizards are building new datasets. Here is a recap of some important new modeling and evaluation work.

For context, this post is part of an erstwhile series dedicated to computational prediction of gene expression in response to perturbations, which is often called virtual cell modeling.

- [Episode 1](perturbation-methods): methods circa mid-2024
- [Episode 2](perturbation-benchmarks): benchmarks circa early 2025
- [Episode 3](FM-refs-2025): a broader look at genomic foundation models
- [Episode 4](virtual-cell-june-2025): new developments circa June 2025 (this post)

### Contents

I will discuss some new model releases:

- [Genentech](https://arxiv.org/html/2412.13478v1)
- [GSK](https://arxiv.org/html/2503.23535v1)
- [Valence (txpert)](https://www.valencelabs.com/publications/txpert-leveraging-biochemicalrelationships-for-out-of-distributiontranscriptomic-perturbation-prediction/)
- [Arc (STATE)](https://arcinstitute.org/manuscripts/State)

And some new and new-to-me work relevant to model evaluation:

- [Shift and U. Toronto](https://arxiv.org/pdf/2506.22641)
- [Virtual Cell Challenge](https://www.cell.com/cell/fulltext/S0092-8674(25)00675-0)
- [Ji et al.](https://www.biorxiv.org/content/10.1101/2023.12.26.572833v1.full)
- [Dorrity et al.](https://www.nature.com/articles/s41467-020-15351-4)

I will give some project-by-project details below. But first . . . 

### Mistake bounty

I will pay you 25 USD via Venmo if you can (patiently!) explain to me a significant factual error that affects a substantive claim within this post. 

- This is at my discretion. 
- The maximum number of bounties is 4. The same person may claim multiple bounties.
- I will credit you if you want. You can also remain anonymous.

### Commitment to neutrality

My twittersphere is rapidly resolving (devolving?) into virtual-cell enthusiasts and virtual-cell skeptics. Most people would probably identify me as a skeptic. However, I am both a skeptic and an enthusiast. Let me recap the ways in which my desires might be shaping my remarks, in the hope that you and I can see past my bias. 

- *Skeptic:* The bulk of my Ph.D. is on the PEREGGRN expression forecasting benchmarks. These found largely negative results. We are currently struggling with the peer review process for PEREGGRN. It is in my interest to push a narrative maximizing the relevance of the PEREGGRN work, and especially the "mean" baseline.
- *Enthusiast:* I want the virtual cells to work, and I have wanted this for a long time. Let me quote an application essay draft fished out of a 2019 email.

    > Some older theoretical results indicate that expanding the diversity and quality of available data could rapidly improve [causal gene regulatory] network inference. ... There is also promise in deployment of the deep learning methods that have recently achieved impressive performance leaps in AI and image processing. When I realized this, I became interested in building a causal stem cell simulator by using high-dimensional, non-parametric machine learning techniques to integrate new cell atlases and other public data with sequencing-based profiles of stem cell differentiations.

Also, a spicy li'l note on terminology. Some people want to restrict the term "virtual cell" to mechanistic models. I too would prefer mechanistic models over deep-learning meatgrinders, but my view is that [usage determines meaning](https://en.wikipedia.org/wiki/Philosophical_Investigations#Meaning_as_use), so that ship has sailed. Also, [interpretable network models don't work for the prediction tasks I study](https://www.biorxiv.org/content/10.1101/2023.07.28.551039v2), and it's time to creatively adapt our methods to work best given the limited but incredible datasets currently on offer circa 2025. So I'll talk about these deep learning models as "virtual cells" throughout this post. 

Let's see what's cookin'.

### New model releases

#### Genentech

It's [this](https://arxiv.org/html/2412.13478v1). The core innovation is to pair transcriptome foundation models with a "drug conditional adapter" that fine-tunes them to predict transcriptional responses to *chemical perturbations not seen during training* or *in cell lines not seen during training* (but not both at once). Also, when they say "unseen cell lines (zero-shot)", they mean that control expression is seen in those cell lines, but perturbed expression profiles from that cell line are not available. A crucial ingredient is the molecular embeddings provided by ChemBERTa. 

This work is compatible with different FM's, but the exposition focuses on scGPT. The usual function of scGPT is to convert gene expression measurement into triples (g, x, c) where g is a gene identifier, x is a discretized expression level, and c is a covariate (e.g. name of cell line). Each cell is a collection of these triples. A transformer model is trained to predict held-out triples. The latent space of the transformer consists of gene embeddings, expression level embeddings, and covariate embeddings. These embeddings are added together and transform-ered, making this a type of [latent space arithmetic](https://en.wikipedia.org/wiki/Word2vec).

So what's new? Well, molecular embeddings are new. They would ideally just get added to all the other embeddings. But they are *so* alien to scGPT that it's hard to effectively fine-tune scGPT and make use of them. So actually no, the molecular embeddings don't get added to the other embeddings right away, and no, scGPT is not fine-tuned; the scGPT weights are frozen. Instead, like a turbocharger compressing air headed to an engine, Genentech's **drug-conditional adaptor** transforms the molecular embeddings to be a more useful input to scGPT. 

The experiments focus on the [sciplex3 data](https://pubmed.ncbi.nlm.nih.gov/31806696/), with different data splits corresponding to different prediction scenarios. They show improvements versus a more conventional method of skipping the turbocharger and fine-tuning all the scGPT weights. They also show improvements over competitors chemCPA, BioLORD, and SamsVAE. With scRNA data, gene expression changes often cannot be estimated precisely, and they make the case that scDCA approaches the actual resolution of the data.

So far in this series, I have only been focusing on genetic perturbations, but this method is elegant and the article was enjoyable to read. I have no idea how good the model is in tangible, biological terms. Two easy changes might help:

- Add a simple baseline such as predicting the logFC will be same across all cell lines or the same across all compounds. (Notably, the Arc institute's State model and Recursion's Txpert will each compare to both of these baselines; see below.) Genentech's DCA model beats [a baseline that beats a baseline](https://arxiv.org/pdf/2204.13545) assuming *no change* in gene expression, which seems too weak. 
- It might be useful to see some sort of retrieval metric: e.g. can predictions recover the correct compound within the top 50? Retrieval metrics as in [PerturBench](https://arxiv.org/abs/2408.10609) are gaining popularity, and I will comment on that below. 

#### GSK's Large Perturbation Model (LPM)

It's [this](https://arxiv.org/html/2503.23535v1). They have a perturbation embedding, a readout embedding (gene identifier), and a context embedding, and the model is trained in a supervised manner, predicting the expression level of that gene in that context after that perturbation. I appreciate the simplicity of the model and the presentation. 

Their experiments use the Norman genetic interaction perturb-seq, the Replogle essential-gene perturb-seqs in K562 and RPE-1, and numerous subsets of the CMAP (LINCS) data. The task is to predict outcomes in a combination of cell context and perturbation that was not observed during training, but where the right perturbation was seen in other cell contexts and the right cell context was seen under other perturbations. This task is easier than predicting outcomes of genetic perturbations never seen in any cell type. The baselines include NoPerturb, GEARS, and numerous methods based on prior-knowledge gene embeddings such as GenePT. The NoPerturb baseline predicts the mean of ALL training data, not just the controls, so it's not exactly no perturbation effect as you might think from the name. There is another dumb baseline that others use for this task (see below) but that is missing here, which is to assume that for a given perturbation, the differential expression is the same across all cell contexts.

In addition to relative performance vs baseline methods, the LPM fully revamps the data preprocessing to try to get more realistic absolute performance numbers. 

They have a SPECTACULAR demo in which they discover that statins may be effective against autosomal dominant polycystic kidney disease (ADPKD). ADPKD is thought to be a monogenic disease rooted in LoF mutations of the gene PKD1. A kidney cell line (HA1E) was included in CMAP/LINCS, and that was an essential ingredient of this example. But, the PKD1 gene was neither measured nor perturbed in LINCS, and many chemical perturbations were not applied to HA1E. So the in-silico extension of CMAP was essential to make the initial hypothesis that statins increase PKD1 expression. Furthermore, **they ran a retrospective follow-up study based on EHR** and demonstrated a protective effect of statins against progression to end-stage renal disease in ADPKD patients. 

I am more excited by this demo than I have ever been by any virtual cell finding. This could be tested in an RCT right now, and I cannot wait to see someone unravel the mechanism and design a new drug to nail it harder than the statins did by accident. What are the key ingredients of this demo?

- monogenic disease with known causal gene
- known relevant cell type with some drug and gene perturbations available
- NO REQUIREMENT for the causal gene to be perturbed or measured in the relevant cell type.
- NO REQUIREMENT for the selected drugs to be perturbed or measured in the relevant cell type. 

Certainly a restricted setting, but also it's a difficult, unexpected, valuable extension of the data. 

#### Valence (txpert)

It's [this](https://www.valencelabs.com/publications/txpert-leveraging-biochemicalrelationships-for-out-of-distributiontranscriptomic-perturbation-prediction/). This was the first method I saw directly cite and respond to the finding that the mean of the training data often outperforms deep learning methods for predicting outcomes of novel perturbations. Accordingly, the results *start* by discussing evaluation, not the new model. Some changes:

- They quantify batch effects and they use batch-matched controls throughout.
- They focus on retrieval metrics as from [PerturBench](https://arxiv.org/abs/2408.10609), and (motivated by retrieval) also on Pearson correlations between predicted and observed log fold change. I will write about these below. 

On the methods side, Txpert combines a baseline state embedding with a perturbation embedding, then decodes the summed embeddings into a predicted expression state. Control expression embeddings are learned de novo or borrowed from foundation models. Perturbation embeddings are learned jointly using a graph neural network. The graph structure includes proprietary Recursion assets based on post-perturbation microscopy and transcriptomics, as well as graphs generated from publicly available sources (STRINGdb, GO). They put a lot of work into the specific network architecture used to combine these embeddings. The overall logic encoded by the model is that if perturbations are similar based on internal Recursion screens or curated biological knowledge, then the model should make similar predictions for them. 

The evaluation focuses on 4 large perturb-seqs from the [GWPS paper](https://pubmed.ncbi.nlm.nih.gov/35688146/) and the [TRADE paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC11244993/). As baselines, it includes GEARS, a mean-ish baseline with additional handling of batch and cell-line diversity, and a method based on NLP-derived gene embeddings. Txpert beats all the comparators when predicting unseen perturbations in a task where they can train on other perturbations. They also study a task where the test-data cell type has limited training data, with only control expression and not perturbed expression, but perturbations are seen in other cell types. They include a baseline assuming the log fold change is the same across all cell types, which is the one that I was wanting to see in the Genentech model. Txpert also beats comparators in this setting. Speaking as an acknowledged virtual cell skeptic, these results seem "real" to me, with thoroughly-considered baselines, metrics, and tasks. 

Ablation studies show that:

1. Most of the value is from STRINGdb. (In figure 4d, do note the y-axis.)
2. Recursion datasets do add some new information not found in STRINGdb. 
3. Recursion datasets add information roughly equally across better-known and lesser-understood genes.
4. (I don't fully understand this yet but) scRNA foundation models do not seem to be important to their results.

Given that most of the value in this study comes from the STRINGdb graph, I would love to see results from GEARS with the STRINGdb graph swapped in. To find that so much detailed insight was already sitting in the public domain is a huge win.

#### Arc (State)

It is [here](https://arcinstitute.org/manuscripts/State). The thesis is in line with that of Valence's Txpert: technical confounders and unmodeled basal-state heterogeneity make the prediction task harder, and they must be explicitly modeled. However, Txpert requires explicit labeling of confounding factors such as batch labels, whereas State also handles unlabeled causes of heterogeneity. State handles unlabeled confounders by matching the *distribution* of post-perturbation cells to the *distribution* of basal-state cells during training. The state transition model consists of:

- $X_0$, a random variable whose realizations represent basal states.
- $T_p$, a stochastic process whose realizations represent functions from basal state to perturbation effect.
- $\epsilon$: experiment-specific technical noise that is independent of the basal state.

The state transition model assumes observed perturbed expression state follows the same distribution as $X_0 + T_p(X_0) + \epsilon$. The functional form of $T_p$ is

$$T_p(X) = f_{recon}(resid(f_{ST}, f_{cell}(X) + f_{pert}(Z_p) + f_{batch}(Z_b)))$$ where

- $f_{recon}$ linearly predicts gene expression from transformed embeddings
- $f_{ST}$ is a transformer
- $f_{cell}$ is an MLP taking the initial expression state as input
- $f_{pert}$ is an embedding layer plus an MLP taking the perturbation label $Z_p$ as input
- $f_{batch}$ is an embedding layer plus an MLP taking the batch label $Z_b$ as input
- $resid(f, x) := x + f(x)$ is a decorator that residualizes its first argument applied to its second

The evaluations use Tahoe-100M; the 4 large perturb-seqs from the [GWPS paper](https://pubmed.ncbi.nlm.nih.gov/35688146/) and the [TRADE paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC11244993/); the [Parse PBMC cytokine-response data](https://www.parsebiosciences.com/datasets/10-million-human-pbmcs-in-a-single-experiment/); and several others. I'll start with just Fig. 1 because there's so much to recap here. The task in figure 1 is to train on all perturbations from some cell lines but only some perturbations from a query cell type, then predict the remaining perturbations in the query cell type. Thus, the query perturbations have been seen during training (but in the wrong cell type) and the query cell type have been seen during training (but under the wrong perturbations). There are baselines that predict the mean differential expression from the correct cell type (but other perturbations) and from the correct perturbation (but other cell types). 

This is quite different from the Genentech demo tasks with novel chemicals, or the GEARS demo tasks with novel perturbations or novel combos. It is very similar to the GSK eval tasks one of the Txpert tasks. Because of the type of task selected, there is no need for State to generalize to entirely unseen perturbations, which greatly simplifies the process of learning perturbation embeddings. 

The evaluation metrics are an especially thorough and creative piece of this study:

- Inverse rank, a retrieval metric as from [PerturBench](https://arxiv.org/abs/2408.10609)
- Pearson correlation between predicted and observed differential expression
- Adjusted mutual information, which assesses how well predictions preserve the cluster structure of the real effects
- MAE and MSE
- Overlap or precision-recall in recovering the top differentially expressed genes (observed per-gene effects are filtered on p-value and ranked on effect size)
- Overall (not per-gene) effect size: they compute this as the number of genes with adjusted p-value < 0.05, and they compute a rank correlation to see how well the predictions rank the perturbations from biggest to smallest effect. 
- There's more evals; on this axis, they really left no stone unturned.

State stacks up really well, beating the baselines for most combinations of eval metric and dataset. Genetic perturbations look a little harder to model than chemical perturbations, with the condition-specific mean among top performers on two correlation metrics and the perturbation-specific mean among top performers on the PerturBench-style retrieval metric. For genetic perturbations, State also loses out to the linear baseline of Ahlmann-Eltze et al. when predicting the top differentially expressed genes (strongest per-gene effect). But, State has a huge gain over all competition when predicting which genes will be differentially expressed at all (disregarding per-gene effect size). State is also the best at predicting overall (not per-gene) effect size.

Ok. That was Fig. 1. Beyond that, State also has an extensive zero-shot demo, Fig. 3, where only control data are observed in the query cell type. The strategy here involves a whole separate model component pretrained on hundreds of millions of single-cell transcriptomes. The results outpace the relevant baseline (mean response to the right perturbation in the wrong cell types), although again the genetic perturbations seem a little harder to model and the chemicals a little easier. Fig. 4 highlights an individual finding selected to showcase especially strong relative performance of State over baselines. 

### New benchmarking work

#### Virtual Cell Challenge

The Arc Institute is hosting a [Virtual Cell Challenge](https://www.cell.com/cell/fulltext/S0092-8674(25)00675-0). The task is to predict outcomes of a new combination of cell type and genetic perturbation, where the genetic perturbation has been observed in other cell types and the cell type has been observed under other genetic perturbations. The competition is based on new LoF data in pluripotent stem cells, focusing on a high number of cells per perturbation to get a cleaner differential expression signal. The evaluation metric is a combination of retrieval, differential expression prediction, and mean absolute error. 

This is a really important effort, and if you're thinking about entering a method, I would definitely encourage it! On July 17 at 4:30pm, the second-best out of 164 participants ([leaderboard](https://virtualcellchallenge.org/leaderboard)) was called `random_baseline`. Maybe someone is being cagey and hiding their approach under an innocuous name, or maybe not. Either way, this is a great opportunity for you to make an acknowledged contribution.

#### Shift and U. Toronto

Shift and U. Toronto researchers have put out [new work on benchmarking](https://arxiv.org/pdf/2506.22641). The central argument is that metrics such as mean squared error and Pearson correlation between predicted and observed differential expression are a bad choice because they favor dumb baselines like the mean of the training data. They favor weighted $R^2$ or MSE metrics that emphasize genes with higher deviation from the mean of the training data. They demonstrate that according to their preferred metrics, GEARS out-performs the mean of the training data. They also hack GEARS to change the *training* loss to weighted MSE, and they observe further improved results. 

How should we view this in context of prior results? Well, the weighted MSE emphasizes more differentially expressed genes. And in the [2023 PEREGGRN benchmarks](https://www.biorxiv.org/content/10.1101/2023.07.28.551039v2), the combination of Norman data and the error measured on the top differentially expressed genes also favored GEARS over the mean baseline: this is the top right corner of PEREGGRN figure S6. So on the surface, the new result from Shift et al. seems very similar.

But, there is actually a huge difference under the hood. The weighting is not done by differential expression over controls. It is done by differential expression over the mean baseline. For any prediction P, you can show poor performance of P by up-weighting genes according to their observed distance from P in the test data. Here, P is the mean of the training data, but it could also be the median, or another baseline you want to overcome. Thus, this result is inevitable. 

The author list here includes Bo Wang, creator of scGPT, a method that has been used for perturbation prediction. 

### Outlook

In October 2024, I [twote](https://x.com/ekernf01/status/1845809278197567542) that "something is deeply wrong" with what we now call virtual cell models. A lot has happened since then, so how am I updating?

Well, I think these models are starting to work by leveraging new information and identifying feasible but non-trivial tasks. In particular:

- Numerous models show strong results for transferring observed perturbations to new cellular contexts, which is the most commonly relevant task for near-term academic and industry use. The GSK ADPKD example was especially exciting to see.
- For the harder task of predicting unobserved perturbations without transferring from another cell type, Txpert finds a ton of useful signal in STRINGdb. 

#### Causal networks are down and out, but we still like them and we want them back

Successful strategies tend to not attempt causal inference on the training data. Instead, they learn how to transcriptomically decode existing knowledge of gene function, such as that encoded by STRINGdb or other perturbation data. As an example, look how the understanding has evolved at GSK: the focus circa 2022 was on causal inference with the [CausalBench challenge](https://arxiv.org/abs/2308.15395), but the [current focus is on decoding embeddings](https://arxiv.org/html/2503.23535v1). Likewise at Genentech, the focus has moved from [causal inference with factor graphs](https://arxiv.org/abs/2206.07824) to a [foundation model](https://arxiv.org/html/2412.13478v1). 

But causal networks will not go away; they are just too appealing to us. We already see the GSK paper demo'ing causal network inference using training data augmented with virtual cell predictions. I predict there will be a revival of causal network analysis as a tool for interpreting black-box virtual cell models.

#### Metric flame wars have a prequel favoring UMAP, MSE, and retrieval

If community discussion of UMAP is any indicator, virtual cell enthusiasts and skeptics are about to descend into a couple years of flame wars over what distance metric is most biologically meaningful. So it's interesting to look back at [Dorrity et al.](https://www.nature.com/articles/s41467-020-15351-4) and [Ji et al.](https://www.biorxiv.org/content/10.1101/2023.12.26.572833v1.full), who already studied biological relevance of various metrics. 

Dorrity et al. use UMAP and other methods to embed genetically-perturbed transcriptome data. Their proxy for biological relevance is whether the nearest neighbors are biologically related:

> To assess whether distance in UMAP space captured known interactions as well as pairwise correlation, we used three gold-standard interaction datasets: (1) protein interactions determined by co-immunoprecipitation followed by mass spectrometry; (2) gene interactions from stringDB, which are derived from a probabilistic metric based on multiple evidence channels including yeast two-hybrid, pathway annotations, and co-expression; and (3) interactions from CellMAP, which are derived from an experimental screen for synthetic genetic interactions. 

They find that UMAP outperforms distance in the original space, distance in a subspace learned by PCA, and a correlation-based distance. Work such as [Chari et al.](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1011288) makes a big deal out of the fact that UMAP does not preserve nearest-neighbor relationships. According to Dorrity et al., that's a feature, not a bug. At least for this specific purpose, the neighbors in the UMAP are a better choice, not an imperfect surrogate for the raw data. 

Ji et al. ran a study in a similar spirit, but with very different success criteria. The most interesting of their three criteria was control rank percentile: "the percentage of perturbed conditions with a larger distance to the reference control set than the control sets to each other." No simple summary could accurately convey their findings, but they recommend MSE. They did not consider distance in UMAP or PCA space as far as I can tell.

Both of these studies rely on some type of retrieval to evaluate their notions of distance. Thus, implicitly, they both endorse retrieval. A simple reading of this work would suggest that we evaluate gene expression predictions using MSE, or UMAP embeddings, or retrieval tasks. 

#### Retrieval metrics are reasonable, but they deserve retrieval baselines

Many studies are either including or centering retrieval metrics as a way of measuring performance. With a retrieval metric, predictions don't have to be close to the true outcome. They just have to be closer to the true outcome than the other predictions are. (I don't have to outrun the bear; I just have to outrun you.) In a setting where you have a differential expression profile that you want to mimic (e.g. stem cell versus desired end product or healthy versus disease),

- MSE asks "How thoroughly will my chosen drug or target work on a molecular level?". 
- retrieval metrics ask "Did I pick the best drug or target from my screening library?" 

Both questions matter, and it makes sense to focus on the one that gives our early-discovery algorithms a better chance to demonstrate value. Retrieval metrics will favor biological diversity in predictions. They will screen out baselines whose predictions are constant across perturbations. 

However, if retrieval metrics answer "did I pick the best drug or target from my screening library", then they should be paired with baseline methods focused on retrieval. I don't know exactly what this should be, but maybe something like [CollecTRI](https://github.com/saezlab/CollecTRI) or [SigCom LINCS](https://maayanlab.cloud/sigcom-lincs/#/SignatureSearch/UpDown).


#### The mean baseline contains biologically relevant findings that could trick you if you didn't know they came from a baseline

The Txpert authors write "[T]he strong predictive power of the mean baseline  ... reflects general biological responses to perturbation-induced stress or a reduction in fitness, health or growth due to perturbation of an important cellular component, rather than perturbation-specific effects." Similarly, the eval work from Shift and U Toronto claims "Systematic bias is readily apparent when evaluating DEGs against control. This is illustrated in the Norman19 dataset[.]" I disagree; here's why. 

I averaged together all the perturbation samples in the Norman 2019 data. I computed the log fold change over the control mean. I inspected the top 100 most increased genes. They included the following indicators of erythrocyte differentiation:

- ALAS2, which catalyzes the first step of heme biosynthesis
- biliverdin reductase, which helps catalyze degradation of *fetal* heme
- SLC25A37, which is an iron importer
- Ferritin, which is used for iron storage
- APOE4, which [is essential for iron homeostasis](https://pmc.ncbi.nlm.nih.gov/articles/PMC7823209/)
- PRDX5, which [may have an antioxidant role in erythroid differentiation](https://pmc.ncbi.nlm.nih.gov/articles/PMC6283586/)
- YPEL3, which [is essential for RBC membrane properties](https://www.nature.com/articles/s41598-021-95291-1)
- TXNIP, which [regulates erythroid differentiation](https://pubmed.ncbi.nlm.nih.gov/25600403/)
- CEBPB, which also regulates erythroid differentiation, at least for [some isoforms](https://pubmed.ncbi.nlm.nih.gov/18832658/)
- KLF1, which regulates beta-globin and other erythroid genes [per GeneCards](https://www.genecards.org/cgi-bin/carddisp.pl?gene=KLF1&keywords=KLF1)
- Two [glycophorins](https://en.wikipedia.org/wiki/Glycophorin). Glycophorins are membrane proteins that make up 2% of red blood cell mass.
- Six different hemoglobin genes. Hemoglobin is used by red blood cells to transport oxygen.

Thus, the results are not perturbation-induced stress, nor technical artifacts. They are highly specific to the biological process that drives interest in much other literature on K562 cells: erythroid differentiation. The biological relevance of the "mean" baseline is especially important in light of how deep learning model results are presented. The [GEARS paper](https://www.nature.com/articles/s41587-023-01905-6#Sec2) has a section "Predicting new biologically meaningful phenotypes". They fill in the gaps in the Norman data by predicting consequences of perturbing every pair of the 102 genes for which perturbations are observed in the data. They highlights how "GEARS predicts a few new phenotypes, including one cluster showing high expression of erythroid markers... [I]ts identification demonstrates the ability of GEARS to expand the space of postperturbation phenotypes beyond what is observed in perturbational experiments." But erythroid differentiation is not beyond the training data; it's easily found in the training data. 

Caveat: GEARS repeated the discovery of an erythroid-like outcome using a subset of training data with some of the most erythroid-like perturbation signatures removed from the training data (Figure S11). This renews the possibility that the finding represents an insightful generalization. It would be simple to see how the same procedure affects the mean baseline, so I ran the analysis as best I could. The figure legend say 7 signatures are removed, but the figure lists 10 pairs across 11 genes, and the 10 pairs do not occur in the training data. I removed the 11 single genes and repeated the above analysis. The mean-over-control top 100 most increased genes still had six hemoglobins, two glycophorins, APOE, ferritin, biliverdin reductase, ALAS2, YPEL3, SLC25A37, PRDX5, TXNIP, and KLF1 (but not CEBPB). I am not yet convinced that GEARS has discovered an erythroid phenotype that could not be found in the training data.

#### The subfield is in an early phase that will not yet produce a stable consensus on performance

Several features of the current virtual cell ecosystem could lead to inaccurate overall assessment of performance.

- Unlike e.g. self-driving cars, there is no human that can do the relevant tasks, and therefore it is not obvious what kind of data are needed. We don't have a believable empirical scaling law yet partly because we don't know what to put on the x axis (well, [New Limit might](https://blog.newlimit.com/p/may-june-2025-progress-update)).
- Relevant datasets are biologically VERY diverse. Models capable of predicting PSC reprogramming may not be capable of predicting cellular stress responses or T cell de-aging. In line with this expectation, empirical results often reverse across datasets: on one, a new method wins; on another, a baseline might win, even though the task appears the same in abstract.
- New modeling work often includes a heavy focus on selecting performance metrics that the models can perform well on. A limited number of datasets are repeatedly re-used to jointly optimize methods and evaluation metrics. 

I want to talk more about choice of evaluation metrics. Statisticians have long cautioned that to avoid false positives, it is necessary to pre-specify a primary endpoint of an experiment and to fastidiously account for experimenter degrees of freedom. Selecting a metric specifically to highlight above-baseline performance of a model raises my statistical hackles. 

But, that ethos comes from late-phase clinical trials and other confirmatory work. Virtual cell models are used for hypothesis generation and early discovery. Pre-specifying a single endpoint is plainly incompatible with the careful, deep observation required for early discovery. Shutting the book on this chapter is not what a curious statistician ought to do.

Compared to statistics, machine learning has a more diverse and creative outlook, which could facilitate new predictive progress. In NLP, as GPT's smashed existing benchmarks, evals rapidly transitioned to much *harder* tasks in order to understand what the models could do. In early days of CASP, there was extensive exploration of what the predictions could get right and wrong. From the [first CASP paper](https://onlinelibrary.wiley.com/doi/epdf/10.1002/prot.340230303?saml_referrer):

> In December 1994, a meeting was held at the Asilomar conference center in California to examine what went right with the predictions, what went wrong, and, where possible, to understand why. Approximately 1 day was devoted to each of the prediction categories. Each day began with a review lecture by the leader of an assessment team, followed by lectures by some of the predictors in that category. Speakers were selected by the assessment teams on the basis of the interest and accuracy of their predictions. In the afternoons, participants were able to investigate many of the methods interactively on computer workstations. In the evenings, there was an extensive discussion of the day’s results.

So, it is totally reasonable and necessary to slice and dice the results when checking what we can and cannot predict, but we are also at a very early stage, and it's still hard to tell how well the models "really" work. 

.

.

.

.

.

.

.

.

.

.

.

.

.

... Still reading? You get a reward. Here's a quote from the first CASP paper: an admirably forthright declaration of the limitations of the contest. 

#### Bonus CASP history

"This is the first experiment of its kind on such a large scale. We consider that much was learned, but it should be realized there are limitations to the significance of the results. It was hard for predictors to gauge how seriously the community would view the outcome, and therefore how much effort to devote to the task. Some unevenness in results may arise from that factor, rather than real differences between the effectiveness of the methods. It is impossible to assess the quality of a method on the basis of one example. Although we tried to insist that all predictors made two and preferably more predictions, there are some exceptions. Methods of assessment evolved during the experiment, and initially it was not clear what information should be required from predictors about their methods and results. Some of these gaps were filled in along the way, but not all. As noted above, in the ab initio category, we were not completely successful in soliciting the participation of all the predictors we would have liked. Finally, the results represent a snapshot in time in the development of the methods. A year earlier or a year later would produce quite a different picture. For all of these reasons, the results should not be used to condemn or exult any particular group and their methods."
