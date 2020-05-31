---
layout: post
title: Pseudotime rant
math: true
---

As multicellular organisms develop, they produce a baffling variety of cell types. Describing this process continues to be a major project of modern science, and the sequel to that project -- unraveling and manipulating the relevant mechanisms -- is even more daunting. Single-cell genomics was enlisted in this effort immediately and with much excitement. 

One of the earliest papers at this intersection of technology and inquiry announced Cole Trapnell's Monocle. It introduced a beautiful idea. From single-cell RNA data, can we directly recover the shape of the lineage tree by which progenitor cells mature and diversify? In other words, can the concept of a lineage tree, which up until now consisted of diagrams in textbooks, be somehow encoded as a formal statistical model and directly fitted to data? In one stroke, this idea promised to take clunky conceptual models and vastly boost their sensitivity and precision. No longer would we rely on discrete cell stages that were described piecemeal, often by just a few surface receptors. Instead, we could discriminate cell types finely, with the entire transcriptome (all genes) at our disposal. In cases where we observed a continuum of changes, rather than stepwise development, we could encode that new understanding directly in a model that would yield a number for each cell specifying exactly how mature that cell is. These estimates of maturity quickly came to be known as "pseudotime".

For developmental biologists and data scientists alike, this idea has proved irresistible. There are now at least ??? methods for pseudotime inference (reviewed heroically in ???), and new claims about lineage relationships appear constantly in single-cell RNA papers. Many of these claims have no other supporting evidence.

Unfortunately, context is king in computational biology, and in many cases, these models are being used in an ill-fitting context. The resulting claims range from "dubious" to "demonstrably false", and there is a clear pattern that explains many of the failures. Much of the scholarship on these topics seems to take the results at face value anyway, with no real exploration of the potential issues. This post is a warning to newcomers in the field who might be wondering: can I infer lineage trees from my data? 

My main claim: to use lineage tree inference methods in practice, make sure you are studying a continuous process and make sure your sample represent enough points along the continuum. Be aware that the measurement error present in the data can exaggerate the degree of continuity of a given process by "smearing" together discrete cell types.

To make the case for these claims, I will describe a series of examples.