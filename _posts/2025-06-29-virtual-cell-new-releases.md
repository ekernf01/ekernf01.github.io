---
layout: post
title: A recap of virtual cell releases circa June 2025
math: true
tags: grn
permalink: virtual-cell-june-2025
---

In October 2024, I [twote](https://x.com/ekernf01/status/1845809278197567542) that "something is deeply wrong" with what we now call virtual cell models. A lot has happened since then: modelers are advancing new architectures and mining new sources of information; evaluators are upping their game with deeper follow-up and an open competition; and synthetic biology wizards are building new datasets. Let's see what's cookin'. 

For context, this post is part of a series dedicated to computational prediction of gene expression in response to genetic perturbations, which is often called virtual cell modeling.

- [Episode 1](perturbation-methods): methods circa mid-2024
- [Episode 2](perturbation-benchmarks): benchmarks circa early 2025
- [Episode 3](FM-refs-2025): a broader look at genomic foundation models (large-scale, multi-purpose neural networks trained on DNA or RNA data)
- [Episode 4](virtual-cell-june-2025): new developments circa June 2025 (this post)

### A spicy note on terminology

Some people want to restrict the term "virtual cell" to mechanistic models. But [most layers of gene regulation are not measured in transcriptome data](https://ekernf01.github.io/GRN_missing/), and mechanism-oriented network models [currently don't work for predicting detailed outcomes of novel genetic perturbations](https://www.biorxiv.org/content/10.1101/2023.07.28.551039v2). It's time to creatively adapt our methods to work best given the limited but incredible datasets currently on offer circa 2025. People are already doing it, and [usage of words determines their meaning](https://en.wikipedia.org/wiki/Philosophical_Investigations#Meaning_as_use), so this ship has sailed. I'll talk about deep learning models as "virtual cells" throughout this post. 

### New model releases
 
#### Genentech

It's [this](https://arxiv.org/html/2412.13478v1). The core innovation is to pair transcriptome foundation models with a "drug conditional adapter" that fine-tunes them to predict transcriptional responses to *chemical perturbations not seen during training* or *in cell lines not seen during training*. Also, when they say "unseen cell lines (zero-shot)", they mean that control expression for test-set cell lines is observed during training, but no perturbed expression profiles from test-set cell lines are seen during training. 

A crucial ingredient is the molecular embeddings provided by ChemBERTa. Embeddings are lists of numbers that represent discrete entities. The most famous example of an embedding might be the [word embeddings](https://en.wikipedia.org/wiki/Word_embedding) from [word2vec](https://en.wikipedia.org/wiki/Word2vec#:~:text=Word2vec%20is%20a%20technique%20in,text%20in%20a%20large%20corpus.), which became known for examples like "sister" being the closest word in embedding space to the result of "Brother" - "Man" + "Woman". The ChemBERTa embeddings represent small organic molecules. 

Genentech's DCA is compatible with different transcriptome foundation models, but the exposition focuses on scGPT, the [single-cell Generative Pretrained Transformer](https://www.nature.com/articles/s41592-024-02201-0). The usual function of scGPT is to convert gene expression measurement into triples (g, x, c) where g is a gene identifier, x is a discretized expression level, and c is a covariate (usually the name of the cell line). Each cell is a collection of these triples. A transformer model is trained to predict held-out triples. The latent space of the transformer consists of gene embeddings, expression level embeddings, and covariate embeddings. To make predictions, the embeddings are added together and passed through a transformer, making this a type of [latent space arithmetic](https://en.wikipedia.org/wiki/Word2vec).

So what's new? Well, molecular embeddings are new. They would ideally just get added to all the other embeddings. But they are *so* alien to scGPT that it's hard to effectively fine-tune scGPT and make use of them. So actually no, the molecular embeddings don't get added to the other embeddings right away, and no, scGPT is not fine-tuned; the scGPT weights are frozen. Instead, like a turbocharger compressing air headed to an engine, Genentech's **drug-conditional adaptor** transforms the molecular embeddings to be a more useful input to scGPT. 

The experiments focus on the [sciplex3 data](https://pubmed.ncbi.nlm.nih.gov/31806696/), with different data splits corresponding to different prediction scenarios. The eval metric is an $R^2$ that I believe is the same as the one from the [ChemCPA paper](https://arxiv.org/pdf/2204.13545). As usual the absolute scale is hard to interpret because it is computed within each perturbation, not within each gene; in the ChemCPA paper, the baseline achieves an $R^2$ above 65% for most observations. DCA shows improvements versus a more conventional method of skipping the turbocharger and fine-tuning all the scGPT weights. It also shows improvements over competitors ChemCPA, BioLORD, and SamsVAE. With scRNA data, gene expression changes often cannot be estimated precisely, and it is argues that scDCA approaches the actual resolution of the data.

So far in this series, I have only been focusing on genetic perturbations, but this method is elegant and the article was enjoyable to read. I have no idea how good the model is in tangible, biological terms. Two easy changes might help:

- Add a simple baseline such as predicting the expression change will be same across all cell lines or the same across all drugs. (Notably, the Arc institute's State model and Recursion's Txpert will each compare to both of these baselines; see below.) Genentech's DCA model beats [ChemCPA](https://arxiv.org/pdf/2204.13545), which beats a baseline that discards all perturbation info (ChemCPA page 6, bottom). The ChemCPA baseline seems similar to assuming the same transcriptional output across all drugs and it is reassuring to have DCA clearly beating that. 
- It might be useful to see some sort of retrieval metric: is the prediction closer to the correct compound than it is to other compounds? Retrieval metrics as in [PerturBench](https://arxiv.org/abs/2408.10609) are gaining popularity, and I will comment on that below. 

#### GSK's Large Perturbation Model (LPM)

It's [this](https://arxiv.org/html/2503.23535v1). They have a perturbation embedding, a readout embedding (gene identifier), and a context embedding, and the model is trained in a supervised manner, predicting the expression level of that gene in that context after that perturbation. I appreciate the simplicity of the model and the presentation. 

Their experiments use the [Norman 2019 erythroid leukemia genetic interaction data](https://pubmed.ncbi.nlm.nih.gov/31395745/), the Replogle essential-gene loss-of-function screens, and numerous subsets of the [CMAP (LINCS)](https://www.broadinstitute.org/connectivity-map-cmap) data. The task is to predict outcomes in a combination of cell context and perturbation that was not observed during training, but where the right perturbation was seen in other cell contexts and the right cell context was seen under other perturbations. This task is easier than predicting outcomes of genetic perturbations never seen in any cell type. The baselines include NoPerturb, [GEARS](https://www.nature.com/articles/s41587-023-01905-6), and numerous methods based on prior-knowledge gene embeddings such as GenePT. The NoPerturb baseline predicts the mean of ALL training data, not just the controls, so it's not exactly no perturbation effect as you might think from the name. There is another simple baseline that others use for this task (see below) but that is missing here, which is to assume that for a given perturbation, the differential expression is the same across all cell contexts. This would be nice to see and hopefully easy to add. 

In addition to relative performance vs baseline methods, the LPM fully revamps the data preprocessing to try to get more realistic absolute performance numbers. 

They have a SPECTACULAR demo in which they discover that statins may be effective against autosomal dominant polycystic kidney disease (ADPKD). ADPKD is thought to be a monogenic disease rooted in loss-of-function mutations of the gene PKD1. A kidney cell line (HA1E) was included in CMAP/LINCS, and that was an essential ingredient of this example. But, the PKD1 gene was neither measured nor perturbed in LINCS, and the ultimately-relevant chemical perturbations were not applied to HA1E. So the in-silico extension of CMAP was essential to make the initial hypothesis that statins increase PKD1 expression in kidney epithelium. Furthermore, **they ran a retrospective follow-up study based on health records** and demonstrated a protective effect of statins against progression to end-stage renal disease in ADPKD patients. 

I am more excited by this demo than I have ever been by any virtual cell finding. This could be tested in a randomized trial right now, and I cannot wait to see someone unravel the mechanism and design a new drug to nail it harder than the statins did by accident. What are the key ingredients of this demo?

- monogenic disease with known causal gene
- known relevant cell type with some drug and gene perturbations available
- NO REQUIREMENT for the causal gene to be perturbed or measured in the relevant cell type.
- NO REQUIREMENT for the selected drugs to be perturbed or measured in the relevant cell type. 

Certainly a restricted setting, but also it's a difficult, unexpected, valuable extension of the data. 

#### Valence (txpert)

It's [this](https://www.valencelabs.com/publications/txpert-leveraging-biochemicalrelationships-for-out-of-distributiontranscriptomic-perturbation-prediction/). This was the first method I saw directly cite and respond to the finding that the mean of the training data often outperforms deep learning methods for predicting outcomes of novel perturbations. Accordingly, the results *start* by discussing evaluation, not the new model. Some changes:

- They quantify batch effects and they use batch-matched controls throughout.
- They focus on retrieval metrics as from [PerturBench](https://arxiv.org/abs/2408.10609), and motivated by retrieval, they also rely on Pearson correlations between predicted and observed gene expression change. I will write about retrieval metrics below. 

On the methods side, Txpert combines a baseline state embedding with a perturbation embedding, then decodes the summed embeddings into a predicted expression state. Control expression embeddings are learned de novo or borrowed from foundation models. Perturbation embeddings are learned jointly using a graph neural network. The graph structure includes proprietary Recursion assets based on post-perturbation microscopy and transcriptomics, as well as graphs generated from publicly available sources ([STRINGdb](https://string-db.org/), [GO](https://geneontology.org/)) on both physical and functional gene-gene relationships. They put a lot of work into the specific network architecture used to combine these embeddings. The overall logic encoded by the model is that if perturbations are similar based on internal Recursion screens or curated biological knowledge, then the model should make similar predictions for them. 

The evaluation focuses on 4 large perturb-seqs from the [GWPS paper](https://pubmed.ncbi.nlm.nih.gov/35688146/) and the [TRADE paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC11244993/). As baselines, it includes GEARS, and a mean-ish baseline with additional handling of batch and cell-line diversity, and a method based on NLP-derived gene embeddings. Txpert beats all the comparators when predicting unseen perturbations in a task where they can train on other perturbations. They also study a task where the test-data cell type has limited training data, with only control expression and not perturbed expression, but test-set perturbations are seen in other cell types during training. They include a baseline assuming the gene expression change is the same across all cell types, which is the one that I was wanting to see in the Genentech model. Txpert also beats comparators in this setting. Speaking as an acknowledged virtual cell skeptic, these results seem "real" to me, with thoroughly-considered baselines, metrics, and tasks. 

Ablation studies show that:

1. Most of the value is from STRINGdb. (In figure 4d, do note the y-axis.)
2. Recursion datasets do add some new information not found in STRINGdb. 
3. Recursion datasets add information roughly equally across better-known and lesser-understood genes.
4. (I don't fully understand this yet but) scRNA foundation models do not seem to be important to their results.

Given that most of the value in this study can be had from the STRINGdb graph alone, I would love to see results from GEARS with the STRINGdb graph swapped in. To find that so much detailed insight was already sitting in the public domain is a huge win.

#### Arc (State)

It is [here](https://arcinstitute.org/manuscripts/State). The thesis is in line with that of Valence's Txpert: technical confounders and unmodeled basal-state heterogeneity make the prediction task harder, and they must be explicitly modeled. However, Txpert requires explicit labeling of confounding factors such as batch labels, whereas State also handles unlabeled causes of heterogeneity. State handles unlabeled confounders by matching the *distribution* of post-perturbation cells to the *distribution* of basal-state cells during training. The state transition model consists of:

- $X_0$, a random variable whose realizations represent basal states.
- $T_p$, a stochastic process whose realizations represent functions from basal state to perturbation effect.
- $\epsilon$: experiment-specific technical noise that is independent of the basal state.

The state transition model assumes observed perturbed expression state follows the same distribution as $X_0 + T_p(X_0) + \epsilon$. The functional form of $T_p$ is

$$T_p(X) = f_{recon}(resid(f_{ST}, f_{cell}(X) + f_{pert}(Z_p) + f_{batch}(Z_b)))$$ where

- $f_{recon}$ linearly predicts gene expression from transformed embeddings
- $resid(f, x) := x + f(x)$ is a decorator that residualizes its first argument applied to its second
- $f_{ST}$ is a transformer
- $f_{cell}$ is a fully-connected neural net taking the initial expression state as input
- $f_{pert}$ is an embedding layer plus a fully-connected neural net taking the perturbation label $Z_p$ as input
- $f_{batch}$ is an embedding layer plus a fully-connected neural net taking the batch label $Z_b$ as input

The evaluations use Tahoe-100M; the 4 large perturb-seqs from the [genome-wide perturb-seq paper](https://pubmed.ncbi.nlm.nih.gov/35688146/) and the [TRADE paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC11244993/); the [Parse PBMC cytokine-response data](https://www.parsebiosciences.com/datasets/10-million-human-pbmcs-in-a-single-experiment/); and several others. I'll start with just Fig. 1 because there's so much to recap here. The task in figure 1 is to train on all perturbations from some cell lines but only some perturbations from a query cell type, then predict the remaining perturbations in the query cell type. Thus, the query perturbations have been seen during training (but in the wrong cell type) and the query cell type have been seen during training (but under the wrong perturbations). There are baselines that predict the mean differential expression from the correct cell type (but other perturbations) and from the correct perturbation (but other cell types). 

This is quite different from the Genentech demo tasks with novel chemicals, or the GEARS demo tasks with novel perturbations or novel combos. It is very similar to the GSK eval tasks one of the Txpert tasks. Because of the type of task selected, there is no need for State to generalize to entirely unseen perturbations, which greatly simplifies the process of learning perturbation embeddings. 

The evaluation metrics are an especially thorough and creative piece of this study:

- Inverse rank, a retrieval metric as from [PerturBench](https://arxiv.org/abs/2408.10609)
- Pearson correlation between predicted and observed differential expression
- Adjusted mutual information, which assesses how well predictions preserve the cluster structure of the real effects
- Mean absolute error and mean squared error
- Overlap or precision-recall in recovering the top differentially expressed genes (observed per-gene effects are filtered on p-value and ranked on effect size)
- Overall (not per-gene) effect size: they compute this as the number of genes with adjusted p-value < 0.05, and they compute a rank correlation to see how well the predictions rank the perturbations from biggest to smallest effect. 
- There's more evals; on this axis, they really left no stone unturned.

State stacks up really well, beating the baselines for most combinations of eval metric and dataset. Genetic perturbations look a little harder to model than chemical perturbations, with the condition-specific mean among top performers on two correlation metrics and the perturbation-specific mean among top performers on the PerturBench-style retrieval metric. For genetic perturbations, State also loses out to the linear baseline of Ahlmann-Eltze et al. when predicting the top differentially expressed genes (strongest per-gene effect). But, State has a huge gain over all competition when predicting which genes will be differentially expressed at all (disregarding per-gene effect size). State is also the best at predicting overall (not per-gene) effect size. And State combines strong performance across multiple metrics, whereas individual baselines seem competitive only on their strongest metrics. It's an open question whether some sort of consensus-method baseline could perform as well across many different metrics. To me, a simpler hypothesis is that State is working.

Ok. That was Fig. 1. Beyond that, State also has an extensive zero-shot demo, Fig. 3, where only control data are observed in the query cell type. The strategy here involves a whole separate model component pretrained on hundreds of millions of single-cell transcriptomes (observational data). The results outpace the relevant baseline (mean response to the right perturbation in the wrong cell types), although again the genetic perturbations seem a little harder to model and the chemicals a little easier. Fig. 4 highlights an individual finding selected to showcase especially strong relative performance of State over baselines. 

#### Ambrosia (New Limit)

It's [this](https://openreview.net/forum?id=kPQ6NKVAiT). Ambrosia starts with TF-set embeddings derived from [ESM2](https://www.science.org/doi/10.1126/science.ade2574). It transforms the TF-set embeddings into gene expression predictions using a fully-connected three-layer neural network. The network is small: hidden layers are sizes 512 and 128. 

They compare Ambrosia against the mean of the training data, the linear baseline of Ahlmann-Eltze et al., and Ambrosia-Linear (Ambrosia but the neural network is replaced with a linear function). They test on the [Norman 2019 erythroid leukemia genetic interaction data](https://pubmed.ncbi.nlm.nih.gov/31395745/) and on NLMT-cx0001, which is internal to New Limit and contains 6503 combos of 580 unique TFs in primary human T cells. The data split is 5-fold CV over TF combinations, with each combination appearing in the test set exactly once. The evaluation metrics feature a Pearson correlation plus a form of mean squared error that up-weights TF sets with large effects, and there is also a large focus on retrieval tasks (New Limit focuses on development of cellular reprogramming protocols). Ambrosia or Ambrosia-Linear are the best performers across all tests, with Ambrosia winning more often for the retrieval tasks and more often for the larger dataset. This task of genetic interaction prediction is very different from the focus of 

In a follow-up task, they reveal portions of the NLMT-cx0001 data to Ambrosia sequentially, allowing it to choose which results it wants to see at each round. With the objective of mimicking a specfic T cell state, Ambrosia discovered about twice as many hits as a random baseline.

This is a nice, easy-to-understand contribution with sensible due diligence. The ESM2 embeddings are a clever source of information that has not to my knowledge been used for virtual cell models, but has shown promise in predicting genetic interactions (see Fig. 4 of [Zhong et al.](https://www.biorxiv.org/content/10.1101/2025.01.29.635607v1.full)).

The proprietary data allow them to see a scaling law where the log of the weighted mean squared error decreases about linearly with the log of the number of observed perturbation conditions. I have limited perspective on this and no reason to doubt it, but in terms of expense, it seems daunting: an exponential decrease in error will require an exponential increase in sequencing costs.

### New benchmarking work

#### Virtual Cell Challenge

The Arc Institute is hosting a [Virtual Cell Challenge](https://www.cell.com/cell/fulltext/S0092-8674(25)00675-0). The task is to predict outcomes of a new combination of cell type and genetic perturbation, where the genetic perturbation has been observed in other cell types and the cell type has been observed under other genetic perturbations. The competition is based on new loss-of-function data in pluripotent stem cells, focusing on a high number of cells per perturbation to get a cleaner gene expression signal. The evaluation metric is a combination of retrieval, differential gene expression prediction, and mean absolute error. 

This is a really important effort, and if you're thinking about entering a method, I would definitely encourage it! This is a great opportunity to make a widely-seen contribution. I took a quick look at the leaderboard out of curiosity. On July 17 at 4:30pm, the second-best out of 164 participants ([leaderboard](https://virtualcellchallenge.org/leaderboard)) was called `random_baseline`. By July 19 at 9AM, it had disappeared (?), but third place out of 178 was occupied by a competitor called `combo_baseline`. Maybe someone is being cagey and hiding their high-ranking approaches under innocuous names, or maybe not. At time of writing, top of the leaderboard was `zera_small` from Markov Bio. Markov Bio has a [distinctive scaling approach prioritizing compute and observational data](https://www.markov.bio/research/mech-interp-path-to-e2e-biology).

Here's a [notebook from Arc](https://colab.research.google.com/drive/1QKOtYP7bMpdgDJEipDxaJqOchv7oQ-_l?usp=sharing) to get you started.

#### Shift and U. Toronto

Shift and U. Toronto researchers have put out [new work on benchmarking](https://arxiv.org/pdf/2506.22641). The author list here includes Bo Wang, creator of scGPT, a method that has been used for perturbation prediction both on its own and as a component of methods like DCA. The central argument is that metrics such as mean squared error and Pearson correlation between predicted and observed differential expression are a bad choice because they favor baselines like the mean of the training data. Instead, we should use weighted $R^2$ or squared-error metrics that emphasize genes with higher deviation from the mean of the training data. According to these weighted metrics, GEARS out-performs the mean of the training data on the [Norman 2019 erythroid leukemia genetic interaction data](https://pubmed.ncbi.nlm.nih.gov/31395745/). The authors also hack GEARS to change the *training* loss to weighted squared error, and they observe further improved results. 

How should we view this in context of other recent work? On the Norman data, various metrics emphasizing the most differentially expressed genes have favored GEARS over baselines: Pearson DE Delta in [Wong et al.](https://academic.oup.com/bioinformatics/article/41/6/btaf317/8142305#524967483) and the MSE on the top genes in [PEREGGRN figure S6](https://www.biorxiv.org/content/10.1101/2023.07.28.551039v2.full#F10). New Limit's Ambrosia evals also eschew MSE in favor of a metric with more differentially-expressed genes upweighted. The new priorities and results from Shift et al. seem qualitatively in line with all this.

But, there is actually a huge qualitative difference in methodology between this study and any other work I have seen. In this study, the weighting is not done by differential expression over controls. It is done by differential expression over the mean baseline. For any prediction P, you can show poor performance of P by up-weighting genes according to their observed distance from P in the test data. 

### Outlook

In October 2024, I [twote](https://x.com/ekernf01/status/1845809278197567542) that "something is deeply wrong" with what we now call virtual cell models. A lot has happened since then, so how am I updating?

Well, these models are starting to work by leveraging new information and by identifying feasible but valuable tasks. In particular:

- For the very hard task of predicting unobserved perturbations without transferring from another cell type, Txpert finds a ton of useful signal in STRINGdb. 
- For genetic interaction prediction, New Limit's Ambrosia leverages ESM2 embeddings and demonstrates a scaling law based on the number of TF perturbation combos used for training.
- Numerous models show strong results for transferring observed perturbations to new cellular contexts. This is the most commonly relevant task for near-term academic and industry use. The GSK ADPKD example was especially exciting to see. Future work should push for detail: 
    - what cell types are best and worst predicted by available data? 
    - What stimuli are least or most consistent across cell types? For example, OSKM overexpression can nuke any epigenome to bits, but Foxn1 knockout doesn't do much outside skin and thymus, and models could potentially learn things like this.
    - For a given success or failure, can a model tell us which cell type(s) it learned the most from? 
    - How simple of a model can successfully transfer-learn across cell types?
- Compared to the work reviewed in this post, Markov Bio is taking a very different strategy focusing on sequence-level modeling, mechanistic interpretability, and observational data. Read [their manifesto](https://www.markov.bio/research/mech-interp-path-to-e2e-biology). 

**Overall, it would be prudent for us to act as if virtual cell models are about to get a lot better quickly.**

Here are some more specific takes about "how good are they *really*".

#### Causal networks are down and out, but we still like them and we want them back

Currently dominant strategies tend to not attempt causal inference on the training data. Instead, they learn how to transcriptomically decode existing knowledge of gene function, such as that encoded by STRINGdb or other perturbation data. As an example, look how the understanding has evolved at GSK: the focus circa 2022 was on causal inference with the [CausalBench challenge](https://arxiv.org/abs/2308.15395), but the [current focus is on decoding embeddings](https://arxiv.org/html/2503.23535v1). Likewise at Genentech, the focus has moved from [causal inference with factor graphs](https://arxiv.org/abs/2206.07824) to a [foundation model](https://arxiv.org/html/2412.13478v1). 

But causal networks will not go away; they are just too appealing to us and too useful if true. We already see the GSK paper demo'ing causal network inference using training data augmented with virtual cell predictions. I predict there will be a revival of causal network analysis as a tool for interpreting black-box virtual cell models.

#### Metric flame wars have a prequel favoring UMAP, squared error, and retrieval

If community discussion of UMAP is any indicator, virtual cell enthusiasts and skeptics are about to descend into a couple years of flame wars over what distance metric is most biologically meaningful. So it's interesting to look back at [Dorrity et al.](https://www.nature.com/articles/s41467-020-15351-4) and [Ji et al.](https://www.biorxiv.org/content/10.1101/2023.12.26.572833v1.full), who already studied biological relevance of various metrics. 

Dorrity et al. use UMAP and other methods to embed genetically-perturbed transcriptome data. Their proxy for biological relevance is whether the nearest neighbors are biologically related:

> To assess whether distance in UMAP space captured known interactions as well as pairwise correlation, we used three gold-standard interaction datasets: (1) protein interactions determined by co-immunoprecipitation followed by mass spectrometry; (2) gene interactions from stringDB, which are derived from a probabilistic metric based on multiple evidence channels including yeast two-hybrid, pathway annotations, and co-expression; and (3) interactions from CellMAP, which are derived from an experimental screen for synthetic genetic interactions. 

They find that UMAP outperforms distance in the original space, distance in a subspace learned by PCA, and a correlation-based distance. Work such as [Chari et al.](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1011288) makes a big deal out of the fact that UMAP does not preserve nearest-neighbor relationships. According to Dorrity et al., that's a feature, not a bug. At least for this specific purpose, the neighbors in the UMAP are a better choice, not an imperfect surrogate for the raw data. After all, the sum of squares is very special in physics, but in transcriptome space, [isometry invariance makes no sense](https://ekernf01.github.io/impossible_2), and we do not know the right metric.

Ji et al. ran a study in a similar spirit, but with very different success criteria. The most interesting of their three criteria was control rank percentile: "the percentage of perturbed conditions with a larger distance to the reference control set than the control sets to each other." No simple summary could accurately convey their findings, but they recommend mean squared error. They did not consider distance in UMAP or PCA space as far as I can tell.

Both of these studies rely on some type of retrieval to evaluate their notions of distance. Thus, implicitly, they both endorse retrieval. A simple reading of this work would suggest that we evaluate gene expression predictions using squared error, or UMAP embeddings, or retrieval tasks. 

#### Retrieval metrics are reasonable, but they deserve retrieval baselines

Many studies are either including or centering retrieval metrics as a way of measuring performance. With a retrieval metric, predictions don't have to be close to the true outcome. They just have to be closer to the true outcome than the other predictions are. (I don't have to outrun the bear; I just have to outrun you.) In a setting where you have a differential expression profile that you want to mimic (e.g., stem cell versus desired end product or healthy versus disease),

- Squared error or similar asks "How thoroughly will my chosen drug or target work on a molecular level?". 
- Retrieval metrics ask "Did I pick the best drug or target from my screening library?" 

Both questions matter, and it makes sense to focus on the one that gives our early-discovery algorithms a better chance to demonstrate value. Retrieval metrics will favor biological diversity in predictions. They will screen out baselines whose predictions are constant across perturbations. 

However, if retrieval metrics answer "did I pick the best drug or target from my screening library", then they should be paired with baseline methods focused on retrieval. I don't know exactly what this should be, but maybe something like [CollecTRI](https://github.com/saezlab/CollecTRI) or [SigCom LINCS](https://maayanlab.cloud/sigcom-lincs/#/SignatureSearch/UpDown).

#### Retrieval metrics have a natural duality

Consider predictions P1, P2 and true outcomes T1, T2. Retrieval could be assessed among many predictions vs one truth: "T1 is closer to P1 than P2". Or, retrieval could be assessed on a single prediction: "P1 is closer to T1 than T2". So far, most work discussed herein does it the first way: many predictions versus one truth. But, [the Arc Virtual Cell Challenge does it the other way around](https://virtualcellchallenge.org/evaluation). In many applications, we will have a single query profile such as endoderm versus pluripotent cells, and we will make many predictions about it. Many-predictions-one-truth seems to match that scenario, but both ways seem meaningful to me. 

#### The mean baseline contains biologically relevant findings that could trick you if you didn't know they came from a baseline

The Txpert authors write "[T]he strong predictive power of the mean baseline  ... reflects general biological responses to perturbation-induced stress or a reduction in fitness, health or growth due to perturbation of an important cellular component, rather than perturbation-specific effects." Similarly, the eval work from Shift and U Toronto claims "Systematic bias is readily apparent when evaluating DEGs against control. This is illustrated in the Norman19 dataset[.]" This cannot be the full explanation of what's going on. Here's why. 

I averaged together all the perturbation samples in the [Norman 2019 erythroid leukemia genetic interaction data](https://pubmed.ncbi.nlm.nih.gov/31395745/). I computed the log fold change over the control mean. I inspected the top 100 most increased genes. They included the following indicators of erythrocyte (red blood cell) differentiation:

- ALAS2, which catalyzes the first step of heme biosynthesis
- biliverdin reductase, which helps catalyze degradation of *fetal* heme
- SLC25A37, which is an iron importer
- Ferritin, which is used for iron storage
- APOE4, which [is essential for iron homeostasis](https://pmc.ncbi.nlm.nih.gov/articles/PMC7823209/)
- PRDX5, which [may have an antioxidant role in erythroid differentiation](https://pmc.ncbi.nlm.nih.gov/articles/PMC6283586/)
- YPEL3, which [is essential for red blood cell membrane properties](https://www.nature.com/articles/s41598-021-95291-1)
- TXNIP, which [regulates erythroid differentiation](https://pubmed.ncbi.nlm.nih.gov/25600403/)
- CEBPB, which also regulates erythroid differentiation, at least for [some isoforms](https://pubmed.ncbi.nlm.nih.gov/18832658/)
- KLF1, which regulates beta-globin and other erythroid genes [per GeneCards](https://www.genecards.org/cgi-bin/carddisp.pl?gene=KLF1&keywords=KLF1)
- Two [glycophorins](https://en.wikipedia.org/wiki/Glycophorin). Glycophorins are membrane proteins that make up 2% of red blood cell mass.
- Six different hemoglobin genes. Hemoglobin is used by red blood cells to transport oxygen.

Thus, the results are not only perturbation-induced stress and technical artifacts. Many results are highly specific to the biological process that drives interest in much prior literature on K562 cells: erythroid differentiation. 

The biological relevance of the "mean" baseline is especially important in light of how deep learning model results are presented. The [GEARS paper](https://www.nature.com/articles/s41587-023-01905-6#Sec2) has a section "Predicting new biologically meaningful phenotypes". They fill in the gaps in the Norman data by predicting consequences of perturbing every pair of the 102 genes for which perturbations are observed in the data. They highlights how "GEARS predicts a few new phenotypes, including one cluster showing high expression of erythroid markers... [I]ts identification demonstrates the ability of GEARS to expand the space of postperturbation phenotypes beyond what is observed in perturbational experiments." But erythroid differentiation is not beyond the training data; it's easily found in the training data. 

Caveat: GEARS repeated the discovery of an erythroid-like outcome using a subset of training data with some of the most erythroid-like perturbation signatures removed from the training data (in Figure S11). This renews the possibility that the finding represents an insightful generalization. It would be simple to see how the same procedure affects the mean baseline, so I ran the analysis as best I could. The figure legend say 7 signatures are removed, but the figure lists 10 pairs across 11 genes, and the 10 pairs do not occur in the training data. I removed the 11 single genes and repeated the above analysis. The mean-over-control top 100 most increased genes still had six hemoglobins, two glycophorins, APOE, ferritin, biliverdin reductase, ALAS2, YPEL3, SLC25A37, PRDX5, TXNIP, and KLF1 (but not CEBPB). I am not yet convinced that GEARS has discovered an erythroid phenotype that could not be found in the training data.

#### The subfield is in an early phase that will not yet produce a stable consensus on performance

Several features of the current virtual cell ecosystem could lead to inaccurate overall assessment of performance.

- Unlike self-driving cars, there is no human that can do the relevant tasks. Therefore it is not obvious what kind of data are needed. In terms of scaling laws, there is huge disagreement on what to put on the x axis. New Limit [thinks perturbations in one cell type](https://blog.newlimit.com/p/may-june-2025-progress-update); Markov Bio thinks [cell types regardless of perturbation](https://x.com/adamlewisgreen/status/1878543385600090428). 
- Relevant datasets are biologically VERY diverse. Models capable of predicting common cellular stress responses after partial knockdowns may not be capable of predicting idiosyncratic cell fate reprogramming via 10x the normal physiological dose of several genes. In line with this expectation, empirical results often reverse across datasets: on one, a new method wins; on another, a baseline might win, even though the task appears the same in abstract ("genetic perturbation").
- New modeling work often includes a heavy focus on selecting performance metrics that the models can perform well on. A limited number of datasets are repeatedly re-used to jointly optimize methods and evaluation metrics. 

I want to talk more about choice of evaluation metrics. Statisticians have long cautioned that to avoid false positives, it is necessary to pre-specify a primary endpoint of an experiment and to fastidiously account for experimenter degrees of freedom. Selecting a metric specifically to highlight above-baseline performance of a model raises my statistical hackles. 

But, that ethos comes from late-phase clinical trials and other confirmatory work. Virtual cell models are used for hypothesis generation and early discovery. Pre-specifying a single endpoint is plainly incompatible with the careful, deep observation required for early discovery. Shutting the book on this chapter is not what a curious statistician ought to do.

Compared to statistics, machine learning has a more diverse and creative outlook, which could facilitate new predictive progress. In NLP, as GPT's smashed existing benchmarks, evals rapidly transitioned to much *harder* tasks in order to understand what the models could do. In early days of CASP (the long-running competition that facilitated the rise of usefully accurate ML-based protein folding), there was extensive exploration of what the predictions could get right and wrong. From the [first CASP paper](https://onlinelibrary.wiley.com/doi/epdf/10.1002/prot.340230303?saml_referrer):

> In December 1994, a meeting was held at the Asilomar conference center in California to examine what went right with the predictions, what went wrong, and, where possible, to understand why. Approximately 1 day was devoted to each of the prediction categories. Each day began with a review lecture by the leader of an assessment team, followed by lectures by some of the predictors in that category. Speakers were selected by the assessment teams on the basis of the interest and accuracy of their predictions. In the afternoons, participants were able to investigate many of the methods interactively on computer workstations. In the evenings, there was an extensive discussion of the day’s results.

So, it is totally reasonable and necessary to slice and dice the results when checking what we can and cannot predict, but we are also at a very early stage, and it's still hard to tell how well the models "really" work. 


### Epistemic coda

#### Mistake bounty

I will pay you 25 USD via Venmo if you can (patiently!) explain to me a significant factual error that affects a substantive claim within this post. 

- This is at my discretion. 
- The maximum number of bounties is 4. The same person may claim multiple bounties.
- I will credit you if you want. You can also remain anonymous.

#### Commitment to neutrality

My twittersphere is rapidly resolving (devolving?) into virtual-cell enthusiasts and virtual-cell skeptics. Most people would probably identify me as a skeptic. However, I am both a skeptic and an enthusiast. Let me recap the ways in which my desires might be shaping my remarks, in the hope that you and I can see past my bias. 

- *Skeptic:* The bulk of my Ph.D. is on the [PEREGGRN expression forecasting benchmarks](https://www.primamente.com/Pleiades-July-2025/). These found largely negative results. It is in my interest to push a narrative maximizing the relevance of the PEREGGRN work, and especially the "mean" baseline.
- *Enthusiast:* I want the virtual cells to work, and I have wanted this for a long time. Let me quote an application essay draft fished out of a 2019 email.

    > Some older theoretical results indicate that expanding the diversity and quality of available data could rapidly improve [causal gene regulatory] network inference. ... There is also promise in deployment of the deep learning methods that have recently achieved impressive performance leaps in AI and image processing. When I realized this, I became interested in building a causal stem cell simulator by using high-dimensional, non-parametric machine learning techniques to integrate new cell atlases and other public data with sequencing-based profiles of stem cell differentiations.

- *Insider bias*: I tend to follow a lot of people doing similar stuff within similar paradigms. You may wish to seek points of view that take a very different view of the virtual cell subfield. Compared to the work reviewed in this post, Markov Bio is taking a very different strategy focusing on sequence-level modeling, mechanistic interpretability, observational data, and better ML practices, including much more compute. They have a valuable outsider view on the academic-style research community I am a part of; [read their manifesto for more](https://www.markov.bio/research/mech-interp-path-to-e2e-biology). A teaser:

    > [T]he incompetence and perverse incentives of academics in the single-cell field (both those training the single-cell foundation models and those creating the benchmarks to evaluate them) conspire to make the field and the broader scientific public, which is taking cues from this group, unduly pessimistic about the potential of these models. Therefore, single-cell foundation models have been systematically underrated for the past year or so. 
    > 
    > These models... are severely underparametrized; use old architectures, suboptimal hyperparameter configurations, and naive losses; and don’t do smart data curation or filtering.

#### Bonus CASP history

"This is the first experiment of its kind on such a large scale. We consider that much was learned, but it should be realized there are limitations to the significance of the results. It was hard for predictors to gauge how seriously the community would view the outcome, and therefore how much effort to devote to the task. Some unevenness in results may arise from that factor, rather than real differences between the effectiveness of the methods. It is impossible to assess the quality of a method on the basis of one example. Although we tried to insist that all predictors made two and preferably more predictions, there are some exceptions. Methods of assessment evolved during the experiment, and initially it was not clear what information should be required from predictors about their methods and results. Some of these gaps were filled in along the way, but not all. As noted above, in the ab initio category, we were not completely successful in soliciting the participation of all the predictors we would have liked. Finally, **the results represent a snapshot in time in the development of the methods. A year earlier or a year later would produce quite a different picture.** For all of these reasons, the results should not be used to condemn or exult any particular group and their methods."