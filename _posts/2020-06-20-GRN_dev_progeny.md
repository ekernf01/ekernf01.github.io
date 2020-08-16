---
layout: post
title: Inferring developmental signals from RNA-seq data
permalink: /GRN_dev_progeny/
math: true
---

Back in the Maehr lab, any given experiment that my coworkers ran was expensive and hard. Our most common measurements -- flow cytometry, imaging, and qPCR -- could take hours or a day or two. Making a batch of virus containing CRISPR guide RNAs could take days or a week or two. Running a directed differentiation could take weeks or a month or two, especially if the cells died. Making a cell line could take months. So if they are going to design an screen, they really want a good chance to find something in there that works for whatever result they are trying to obtain.

So, stem cell biology has a real need for tailored statistical methods that provide calibrated results with applicability in directed differentiation. Unfortunately, the methods I typically used to explore and annotate transcriptome data fell short. 

- The underlying biological phenomena are overlapping and redundant, such that any given output could potentially be accounted for by a process that is similar, but not the same. For instance, it is easy to find thymic epithelial datasets annotated as other epithelial tissues (skin, bronchioles, intestine). This is partly because of the frequent use of the Fisher Exact Test: its null model requires genes to be permuted randomly, not selected based on other well-coordinated biological processes.
- The outputs are often based on genes that are involved in a given pathway, but not necessarily via transcriptional regulation. For example, Wnt signaling involves beta-catenin, and any sensible general-purpose ontology will rightly associate them, but [the key buildup or degradation is of beta-catenin protein, not RNA](https://en.wikipedia.org/wiki/Wnt_signaling_pathway#Mechanism). If beta-catenin is differentially expressed on an RNA level, that is hard to explain in terms of Wnt signaling.
- The underlying databases are often not something one could design a screen from: for example, "positive regulation of epithelial cell apical/basal polarization" is informative, but you can't order a bottle of it and feed it to your cells.

In cancer biology, these deficiencies were answered in style by [`progeny`](https://saezlab.github.io/progeny/). For a limited number of cancer-related signals, they provide a calibrated method to test for the activity of each signal. Their method is based on genes that are specifically selected as responsive on an RNA level: in terms of the Wnt example, this would not be beta-catenin but something further downstream. When I call it "calibrated", I mean they tested it on a large held-out set to ensure that positives occurred only in samples involving the corresponding signals or related driver mutations with essentially the same effects.

Unfortunately, `progeny` only tests for presence of 11 or 12 cancer-related signals. I wish somebody would do this for stem cell biology using common developmental signals. It looks like a ton of work, especially to curate the data. If you know of anyone doing this, please let me know -- otherwise, I might try it myself at some point.



