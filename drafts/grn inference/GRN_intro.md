## On cellular control networks

Back in graduate school, I became interested in systems biology, but I never quite found exactly what I was looking for. Biology is an ocean, and to arrive at the lagoon I am in, I swam past papers on [gene-set enrichment analysis](http://amp.pharm.mssm.edu/Enrichr/), [grouped association tests](https://www.sciencedirect.com/science/article/pii/S0002929718301083), [critical state transitions](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5189937/), [stochastic](https://www.ncbi.nlm.nih.gov/pubmed/17037977) [modeling](https://www.ncbi.nlm.nih.gov/pubmed/28341132) and [related inference methods](https://darrenjw.wordpress.com/), large-scale [perturbation](https://www.sciencedirect.com/science/article/pii/S0092867416316105) [experiments](https://www.biorxiv.org/content/early/2017/05/10/136168), and [correlation](https://www.ncbi.nlm.nih.gov/pubmed/15867157) [networks](https://www.ncbi.nlm.nih.gov/pubmed/29202695). Some of these enable highly detailed modeling motivated by both the biology and the underlying physics. Unfortunately, these do not scale well; they tend to include fewer than 20 interacting genes and proteins, whereas modern sequencing datasets routinely measure tens of thousands of genes or non-coding elements. Other lines of research grapple head-on with genome-wide inference, but do not explicitly model direct interactions between transcriptional regulators and their targets. So, they can describe cells in lots of detail, but they give limited insight into the mechanisms controlling cell state. 

Some time over the last three years, I managed to pin down my questions, and I began finding some of the right papers to satisfy my curiosity. These projects attempt to infer what regulates each gene's activity, and they do it using genome-wide datasets. In the context of [my day job](https://ekernf01.github.io/about_maehrlab), the ultimate goal coming out of that type of model would be a stem cell simulator. Given a dataset measuring gene activity, and optionally other inputs such as genes to be overexpressed or small molecules to be dumped on the cells, I want to computationally extend the data days or weeks into the future. Running many such simulations would help the lab understand how initial conditions affect stem cells' fate. 

We are a long way from that ideal, but people are working towards it, and that is what I am beginning to explore in this post series. I will try to tackle select examples of existing work in small, coherent batches. 

- Quick & dirty biology for people from other fields

- The single cell revolution in RNA sequencing

- Other data resources

- Other technologies: ChIP-seq, ATAC-seq, enhancers, and motif analysis

  - Aside: methods of pairing enhancers with their target genes
  - Inferring gene regulatory networks from combined RNA and DNA sequencing data

- Algorithms and the DREAM5 competition: how well do existing methods perform?

- Stem cell applications: how do people use network inference to study stem cells or development? 

- Identifiability: how much data will we need to improve performance, and what kind?

  
