---
layout: post
title: Gene regulatory network inference is a venus fly trap for quants
math: true
tags: grn
---

![An image of Audrey II captioned 'Why dont you try .... GENE REGULATORY NETWORK INFERENCE?'](/images/grn_meme_audrey_ii.jpg)

Choosing a scientific project is hard, and people don't spend enough time on it (see Alon ([pdf](https://www.weizmann.ac.il/mcb/alon/sites/mcb.UriAlon/files/uploads/nurturing/howtochoosegoodproblem.pdf)) and [Fischbach](https://www.cell.com/cell/abstract/S0092-8674(24)00304-0) on this). If you are thinking of choosing a research project related to **gene regulatory networks**, **computer models of transcription**, **perturbation responses**, or **virtual cells**, then you might benefit from knowing what others have set out to do and how it has gone.

### Gene regulatory network inference is a venus fly trap for quants

We learn about LASSO and regression trees and dynamic mode decomposition and "Bayesian mechanics" and Kalman filters and transformers, and we get excited to solve real problems with these models. Maybe we start thinking about assumptions -- e.g. my predictors are supposed to have [not too much correlation for LASSO model selection consistency](https://jmlr.org/papers/v7/zhao06a.html), and oh yeah I only have mRNA data, so I hope the protein activity in my cells [relies on uninterrupted mRNA production](https://www.nobelprize.org/prizes/medicine/1965/ceremony-speech/). Oh and some of the variation is measurement error, not biological variation, so let's build in a [Gaussian](https://www.sciencedirect.com/science/article/pii/S1046202315300049) or [Binomial](https://www.nature.com/articles/s41592-023-01971-3) error model. And we have some [guesses about the network structure](https://github.com/ekernf01/network_collection), so let's [use those as a prior for Bayesian model averaging](https://bmcsystbiol.biomedcentral.com/articles/10.1186/1752-0509-8-47). Wow, this is turning into a ton of work! Throw in a demo on a real dataset. OK, great, we're done. 

... I guess maybe we should check the results. Let's ([simulate](https://www.liebertpub.com/doi/abs/10.1089/cmb.2008.09TT)) ([some](https://ieeexplore.ieee.org/abstract/document/9992359)) ([data](https://www.biorxiv.org/content/10.1101/2023.02.23.529720v1)) and maybe also compare to portions of known networks in well-studied organisms ([BEELINE](https://www.nature.com/articles/s41592-019-0690-6), [DREAM5](https://www.nature.com/articles/nmeth.2016), [Djordjevic](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0111661), [McCalla](https://academic.oup.com/g3journal/article/13/3/jkad004/6982776)). Wow, this is even more work! And the precision-recall tradeoffs look pretty bad. Huh ...

... ok, maybe we can't get the whole network. Fine. If someone can ChIP and KO a single transcription factor and publish a paper on that -- which, to be clear, is common and worthwhile -- then maybe I can still have a positive impact by recovering a subset of a gene regulatory network with high confidence. So let's get some p-values and run some multiple testing correction and just skim off the top of the list. Throw in a real-data demo. OK, great, we're done. 

... I guess maybe we should check the results again. Oh but these tests make all sorts of assumptions about [linear/Gaussian data](https://pubmed.ncbi.nlm.nih.gov/15479708/) or [extremely unstructured null models](https://pubmed.ncbi.nlm.nih.gov/30169550/). Let's roll our own test with [more flexible assumptions](https://academic.oup.com/jrsssb/article/80/3/551/7048447) and figure out a way to [calibrate the error rates](https://academic.oup.com/bioinformatics/article/31/17/2836/182839) and [OH EEUUUGGHH IT'S THAT BAD??](https://www.cell.com/cell-systems/fulltext/S2405-4712(24)00205-9)

Fuck. Well. I guess we need cleaner data somehow. Let's try to just [regress out some batch effects](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-019-1700-9) and oh the [AUPR is worse now](https://pubmed.ncbi.nlm.nih.gov/35115012/) and the [calibration is also probably not fixed](https://www.cell.com/cell-systems/fulltext/S2405-4712(24)00205-9) but we can't tell because we lost 95% of our power? Huh. Ummm. 

Ok fine, maybe the data are just hopelessly confounded by unmodeled post-transcriptional regulation and/or batch effects. Let's try this again some other time with cleaner data.

... this is where I left off and where I hope to pick up again some day. If you want to work on this, I am happy to chat about it. 

### Virtual cells

So we tried GRN inference and the result is extremely messy. Can we still get some value out of a messy network with lots of wrong answers but also enrichment of right answers? People claim to make useful cell state predictions with a messy first-draft motif-based network ([CellOracle](https://www.nature.com/articles/s41586-022-05688-9), [scKINETICS](https://academic.oup.com/bioinformatics/article/39/Supplement_1/i394/7210448?login=false)) or a curated functional similarity network ([GEARS](https://www.nature.com/articles/s41587-023-01905-6), [CODEX](https://pmc.ncbi.nlm.nih.gov/articles/PMC11211812/)) or no network at all ([PRESCIENT](https://www.nature.com/articles/s41467-021-23518-w), [GeneFormer](https://www.nature.com/articles/s41586-023-06139-9)). 

There is [tons of modeling diversity here](https://ekernf01.github.io/perturbation-methods) and there are lots of open questions. In fact, here's a [list of guiding questions](https://github.com/ekernf01/perturbation_benchmarking/blob/main/guiding_questions.txt) that I maintained and extended for several years during my Ph.D. I chased after too many of these questions during the super-customizable [PEREGGRN project](https://github.com/ekernf01/perturbation_benchmarking), leaving myself a little overextended. But the [main result](https://www.biorxiv.org/content/10.1101/2023.07.28.551039v2) was that simple baselines usually worked best, preventing us from obtaining meaningful answers to many of our questions. [Many others are finding similar results](https://ekernf01.github.io/perturbation-benchmarks). So this didn't work out either.

### Lessons

Longstanding ambitions to build GRN's and virtual cells still await richer data. For a problem this hard, modeling details will not matter until we have adequate data. I encourage analysts to redirect their enthusiasm: instead of crafting theory, investigate the information content of your data, and devise new ways to discover what other information you need. Alternatively, if you do want to focus on theory and model-building, there are other types of data and other ideas in transcriptional control that could be a better fit for you: for example [reaction rate parameter inference](https://github.com/ekernf01/prelim_tex_files/blob/master/kernfeld_wilkinson_summary/kernfeld%20wilkinson%20summary.pdf) or [kinetic](https://www.cell.com/cell-systems/fulltext/S2405-4712(16)30407-0) [control](https://www.nature.com/articles/s41586-024-08219-w) or [noise propagation](https://www.biorxiv.org/content/10.1101/2024.11.28.625836v1.abstract). 

