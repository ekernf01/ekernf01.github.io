---
layout: post
title: Network modeling and the Connectivity Map
permalink: /GRN_cmap/
math: true
---

The holy grail of stem cell biology would be a mechanistic model of cell state where users could specify starting cell type, small molecule stimuli, physical arrangement, and other culture conditions, then receive high quality predictions of how the cells will respond over time. This is obviously too much to ask right now, but there is also cause for optimism. Datasets and technological advances continue to scale at a terrifying rate. We already have large-scale perturbation data from CMAP (site: [https://clue.io/cmap](https://clue.io/cmap), paper: [doi:10.1016/j.cell.2017.10.049](https://www.doi.org/doi:10.1016/j.cell.2017.10.049) ), which has been successfully used for stem cell biology ([doi:10.1073/pnas.1501597112](https://www.doi.org/10.1073/pnas.1501597112)). People have also published out-of-sample perturbation response prediction using  ([doi:10.1038/s41592-019-0494-8](https://www.doi.org/10.1038/s41592-019-0494-8)). 

This begs the question: how well can perturbations be predicted in
CMAP? Surprisingly, nobody has done this. It would be worthwhile to set up a challenge where 9 cell types are observed in the control setting and only eight for each perturbation. Does latent space arithmetic work substantially better than regular arithmetic? What about other machine learning methods? 

TODO: READ ESPA AND SPEED

https://pubmed.ncbi.nlm.nih.gov/18937865-expression-based-pathway-signature-analysis-epsa-mining-publicly-available-microarray-data-for-insight-into-human-disease/

https://pubmed.ncbi.nlm.nih.gov/20494976-discovering-causal-signaling-pathways-through-gene-expression-patterns/

It would be especially interesting to augment these predictions with causal networks inferred from other sources. The additional information could potentially improve performance beyond black-box approaches, which would be limited to training on CMAP alone. If this were to succeed, CMAP could be used for large-scale validation or comparison of inferred network models, which is otherwise difficult to carry off. 

CMAP could also help refine and extend network models, rather than just validating them. 

- Models could predict transcriptional consequences of small molecule perturbations, not just TF overexpressions. This would greatly expand the range of available validation data compared to works where all regulators are genes. 
- If gene A is a direct target of stimulus B and gene C is further downstream, then gene A should consistently respond to B, but C should respond only when the connections downstream from A are active. 
- If gene C has a hypothesized regulator A that binds only under stimulus B, then the presence or absence of A in the control profile should predict whether B affects C. 
