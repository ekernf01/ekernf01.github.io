---
layout: post
title: On cellular control networks: identifiability
math: true
---

This is not a standalone post. Check out the [intro](https://ekernf01.github.io/GRN_intro) to this series.

### I can never tell you two apart

When we construct quantitative models of biological systems, they usually have unknown parameters. These might be fertility rates in a population model, decay rates of random polymer looping in a model of 3D genome structure, or transcription rates in a model of gene regulation. Sometimes, two different settings of the parameters will give rise to more or less identical predictions, and this presents problems for statistical inference. For example, if genes Foxg1 and Foxn1 are active in the same cells, it's hard to distinguish their effects. In statistics, we would call this an *identifiability* problem. A common-English synonym might be *model distinctiveness*. 

Do we have an identifiability problem in systems biology? Almost certainly yes, because so much is missing from our measurements. In one common type of experiment, we measure gene activity by counting RNA transcripts, but we can only guess at: 

- protein levels
- protein modifications such as phosphorylation and cleavage
- [tiny little RNAs](https://en.wikipedia.org/wiki/MicroRNA) not captured well by vanilla RNA-seq
- whether the DNA at each locus is accessible, or other aspects of DNA packaging and modification

Furthermore, many RNA pairs are highly correlated, without either member directly regulating the other.

So, even if we can establish a definite causal link between RNA transcript A and RNA transcript B, the exact mechanism is not clear. Does A bind the gene for B directly (`A==>B`)? Maybe A gives rise to a protein C that binds the gene for B (`A ==> (C) ==> B`)? Maybe protein C facilitates production of a microRNA D that degrades transcripts of B (`A ==> (C) ==> D ==> B`). Maybe protein C [goes to the cell surface, forms a complex with several other proteins, binds another molecule outside the cell, opening an intracellular domain to phosphorylation, which recruits a kinase, which phosphorylates a thing, which recruits things that phosphorylate things that hydrolyze things to generate things that promote transcription of B.](https://www.cellsignal.com/contents/science-cst-pathways-immunology-and-inflammation/t-cell-receptor-signaling-interactive-pathway/pathways-tcell) 

### A more reasonable problem

Even though Occam's razor does not apply here, we don't want to just pull our hair out. Let's reduce the scope of the problem. This post is about a few papers that reduce this problem in different ways, arriving at estimates for how much data we need, and what kind of data we need, in order to start inferring what controls gene activity.

The main strategy here is to ask for links that are causal, even though they may not represent direct physical interactions. In diagrams:

 
     A  ==> (B) ==> (C) ==> D    # Desired inference: A -> D
     A  ==>  D                   # Desired inference: A -> D
    (B) ==>  A  and (B) ==> D    # Desired inference: none
     A  ==>  E  ==>  D  # Desired inference: A -> E and E -> D but not A->D
    
    Legend: 
    A, B, C, D, E are pieces of DNA, RNA, protein, or other functional molecules.
    A without () means A is measured
    (A) means A is not measured
    A ==> B means "A directly binds B, influencing its function and/or quantity."
    A -> B means "A has a causal effect on B, possibly mediated by unobserved species but not entirely mediated by observed species."

**Is this possible? What type and scale of data are needed?** This post is about theoretical answers to this question based on mathematical models of gene regulation. In other posts, I'll discuss practical aspects.
  
### The papers

> Akutsu, T., Miyano, S., & Kuhara, S. (1999). Identification of
> genetic networks from a small number of gene expression patterns 
> under the Boolean network model. In Biocomputing'99 (pp. 17-28).
> https://www.ncbi.nlm.nih.gov/pubmed/10380182

> Schober, S., Kracht, D., Heckel, R., & Bossert, M. (2011). Detecting 
> controlling nodes of boolean regulatory networks. EURASIP Journal on 
> Bioinformatics and Systems Biology, 2011(1), 6.
> https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3377916/

The first two papers featured here are on Boolean models. That means they assume the activity of gene A at time t+1 is determined by a boolean function of other genes. For a made-up example, "Ccl25 is active at time t+1 if, at time t, Foxn1 is active and Gcm2 is not active." The second paper allows randomness: "Ccl25 is active with 90% probability if at time t+1 if, at time t, Foxn1 is active and Gcm2 is not active. Otherwise, it is active with probability 0.05." They assume certain restrictions on the complexity of the input rules: each gene can have at most $k$ inputs, where a practical value of $k$ might be 3. They study various aspects of this problem, but the topic today is: *how many samples are needed to infer each gene's input function?* 

They measure the answer by counting "state-transition pairs," which are measurements of gene activity at two consecutive time-points.

From the abstract: 

> This paper proves that, if the indegree of each node (i.e., the number of input nodes to each node) is bounded by a constant, only O(log n) state transition pairs (from 2n pairs) are necessary and sufficient to identify the original Boolean network of n nodes correctly with high probability. We made computational experiments in order to expose the constant factor involved in O(log n) notation. The computational results show that the Boolean network of size 100,000 can be identified by our algorithm from about 100 INPUT/OUTPUT pairs if the maximum indegree is bounded by 2. 


[what is possible](https://reader.elsevier.com/reader/sd/pii/S0304407616301828?token=7DC7B7BC54B12D6F3DC4EC94B02DE7C119374F7EB120842D3BA61CE7722169116D344AE963EEB8879FCD391DCB145C4E) 
[compactly represent the uncertainty remaining](https://public.econ.duke.edu/~kdh9/Source%20Materials/Research/4.%20Searching%20for%20the%20Causal%20Structure%20of%20a%20VAR.pdf)


It's good to know that whenever I want to skim through a long list of papers with terrifying titles and feel bad about myself, I can check out [everything Tatsuya Akutsu has been up to since he published that paper back in 2000.](http://www.bic.kyoto-u.ac.jp/takutsu/members/takutsu/papers.html)