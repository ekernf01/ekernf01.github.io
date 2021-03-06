---
layout: post
title: Thymus Atlas
math: true
tags: maehrlab single_cell
---

Why study the thymus? The eponymous "T cells" of the immune system:

- kill invaders directly.
- unleash antibody-secreting B cells.
- fight cancer.
- specifically protect desired cell types.
-  contribute lasting immunity after vaccination. 

Strangely enough, people had no idea what the thymus did or how important it was even as late as the 1960's. This is really weird, right? For comparison, consider the parathyroid: equally obscure and closely related in its fetal origins. G. Moussu published on its function around 1900, and in 1909, Y.W. Berkeley and S.B. Beebe [successfully treated a human](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2099352/pdf/jmedres00083-0036.pdf) based on the same principles! Why did thymus research lag behind by more than half a century?

Part of the problem is that once you reach adulthood, the job is finished. The thymus's most important work is done early in development, and this obviously makes the problem harder to study. Once Jacques Miller demonstrated this, immunologists were able to make tremendous progress, but even in 2016, we still felt the field didn't have a complete answer to a rather basic question: what different cell types are in the thymus, and how do they change during development? So, we started to work on single-cell RNA mapping of mouse thymus development. We performed single-cell RNA sequencing on thymi from mouse embryos from 12.5 days after fertilization (when the thymus forms) to birth (8 days later). The idea was to produce a resource for any lab studying thymus development or thymocyte development. We put a ton of work into this, and we're proud of the results, which you can find [here](https://www.ncbi.nlm.nih.gov/pubmed/29884461).

There is a ton you could dig into in this type of dataset: you could look for new cell subpopulations, find transcription factors that are subset-specific or dynamically expressed, or look for instances of "thymic crosstalk". One of my favorite aspects of the paper was that in a couple of places, we were able to cross-reference the expression data with GWAS hits. Although there are advantages of working in a developmental biology lab rather than doing genetic epidemiology with no access to wet-lab resources, this experience really showed me the importance of GWAS and similar reseach. 

This was my first major project in the Maehr Lab, and I learned a ton. I hope to write some follow-up posts on specific technical topics. One of the biggest challenges was keeping everything organized and making sure the analyses were reproducible. I worked really hard at that, and you can find [the code](http://github.com/maehrlab) on Github. 


You can learn more thymus history in Jacques Miller's [A Scientific Odyssey: Uncovering
the Secrets of Thymus Function](https://www.cell.com/cell/pdf/S0092-8674(19)30911-0.pdf) and more about parathyroid history in this [history of parathyroid endocrinology](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3683213/#ref3).

