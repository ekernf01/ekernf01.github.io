---
layout: post
title: On cellular control networks: statistical issues
math: true
---

This is not a standalone post. Check out the [intro](https://ekernf01.github.io/GRN_intro) to this series.

Human cells have a remarkable ability to differentiate and respond to their environment. A single fertilized egg can give rise to placenta, germ cells, muscle, liver, skin, neurons, and all the tissues of the body. Individual cells alter their shape, stiffness, organelle content, chromatin state, and surface receptor composition. They migrate, contract, metabolize, secrete, multiply, kill, and die, according to the sequence of stimuli they "detect" beginning at conception. In systems biology, it's long-standing challenge to build predictive models of the underlying systems that control these "behaviors".

It's useful to conceive of the biochemical systems controlling cells as networks: if transcript A is translated into protein A, which binds at locus B and inhibits transcription of transcript B, then the network would have a connection from A to B. Many studies have modeled control networks starting with a hit from a genetic screen. For instance, mice lacking Foxn1 are severely immunodeficient, so papers have used various approaches to detect outgoing connections from Foxn1 ("downstream genes") in an attempt to understand how it contributes to development. 

This type of approach has revealed countless valuable pieces of information, often enough to detail entire "pathways" within the network. But, it is fundamentally not scalable to reconstruct the entire human control network one element at a time using customized tools. I am interested in automated, large-scale network modeling based on screens and observational data. 

Unfortunately, there are many statistical obstacles we must overcome in order to build convincing and useful models of cellular control from modern datasets. This post will lay out the problems separately from one another.

#### Missing data

Modern datasets predominantly measure DNA state and RNA quantity. Many efforts at network inference thus include only DNA state and RNA quantity. The elephant in the room is protein state and protein quantity. Proteins are not simply present in proportion to the correspondng messenger RNA's! If they degrade slowly (quickly), there can be more (less) than expected. More importantly, they form a whole separate set of interactions: notably, they can form complexes, they can be phosphorylated, and they can release signaling domains via hydrolysis. Dynamic behavior that is obvious and simple when proteins are observed can be confusing when they are missing. 

#### Measurement error

Genomics data are notoriously noisy. Most technologies suffer from measurement errors to varying degrees, but I want to take this opportunity to complain to the internet about two technologies in particular that are especially messy. In the extreme case of droplet-based single-cell RNA-seq, the roughly one million transcripts per cell are phyically downsampled to thousands or tens of thousands during the capture process. Cell-to-cell variability is dominated by this measurement error, so single-cell RNA-seq is ironically not well suited to study subtle biological differences from cell to cell. Another extreme example is the assay for transposase-accessible chromatin. It is popular due to the ease of use, and it has been adapted for single-cell assays too. Unfortunately, when you compare it to an older technology, DNase-seq, you'll find that my favorite feature is missing from ATAC-seq. DNase-seq produces clear, distinctive signals surrounding binding sites of transcription factors: there will be a spike in DNase sensitivity on either side of the binding site, with a trough in the site itself. ATAC-seq doesn't do this.

PICTURE?? 

#### Identifiability

One of my favorite papers completely removes measurement error and missing data from consideration. It uses mathematics and simulations to consider a scenario with perfect measurements of all relevant chemicals. This lays bare the fascinating issue of *identifiability*: multiple causal models can produce the same exact predictions. This problem can appear in different ways:

- If A affects B affects C, it's hard to tell that A doesn't affect C directly. 
- It's hard to tell whether A affects B or B affects A. Time-series measurements and assays related to direct binding can help infer the direction of a connection. 
- If effects are complicated and synergistic, it's hard to tell whether A, B, C, D, and E together physically determine the regulation of F, or whether it's some other set of factors. This problem explodes very badly as the number of incoming connections increases. 

For more thoughts on these issues, see the [posts on identifiability]() ???.