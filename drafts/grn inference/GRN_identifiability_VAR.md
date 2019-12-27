---
layout: post
title: On cellular control networks: identifiability
math: true
---

This is not a standalone post. Check out the [intro](https://ekernf01.github.io/GRN_intro) to this series.

Consider a time-series of transcriptomic measurements. How much can we infer about a genetic network from this type of data? One way to think about this is the *vector autoregressive model*. If gene $g$ at time $t$ has $x_{gt}$ transcripts, the vector autoregressive model says gene activity is a linear function of the previous time-point: $x_{g,t+1} \approx \sum_{h \in G} c_{gh}x_{gt}$. The coefficient $c_{gh}$ is the influence of gene $h$ on gene $g$, so positive $c_{gh}$ means upregulation, negative means downregulation, and 0 means no relationship. 

Economists have written a lot about inference of vector autoregressive models. This is of interest to me because they don't just write about how to estimate some reasonable set of coefficients $C$ from a dataset $X$: they also consider important caveats. Are there many different options for $C$ that all fit the data well? Yes. For instance, can $C$ fit the data without reflecting causal relationships? Yes. Here are some of the details.

[what is possible](https://reader.elsevier.com/reader/sd/pii/S0304407616301828?token=7DC7B7BC54B12D6F3DC4EC94B02DE7C119374F7EB120842D3BA61CE7722169116D344AE963EEB8879FCD391DCB145C4E) 

[compactly represent the uncertainty remaining](https://public.econ.duke.edu/~kdh9/Source%20Materials/Research/4.%20Searching%20for%20the%20Causal%20Structure%20of%20a%20VAR.pdf)


