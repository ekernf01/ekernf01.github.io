---
layout: post
title: You can't test for independence conditional on a quantitative random variable.
math: true
permalink: impossible_4
tags: stat_ml
---

Suppose the joint distribution of $X, Y, Z$ is continuous and the max of $X$, $Y$, and $Z$ is $M$. Suppose you want to test whether $X$ and $Y$ are independent conditional on $Z$. You want to do this with a type 1 error rate (false positive rate) controlled at 5%. 

![The meme where Bugs Bunny smugly says "No."](images/BugsBunnyNo.jpg)

You can't do it. The proof, by from Shah and Peters [(pdf)](https://arxiv.org/pdf/1804.07203.pdf), is based on an outrageous information-smuggling scheme. Round off the numbers to a long decimal (or binary) approximation. Stick the digits of $X$ into the right side of $Z$, like this.

    round(X) = 0.1234
    round(Z) = 5.6789
    Zsmuggle = 0.123456789

`Zsmuggle` is very close to `Z`, but contains WAY more information about `X`. This allows you to take 

- a distribution where $Y$ has lots of info about $X$ (above and beyond what $Z$ has)

and turn it into 

- a very similar distribution where $Z$ has all of $X$ (and $Y$ can add nothing further). 

By doing that, you make X independent of $Y$ given $Z$. There is a ton of additional technique required to make this work as a proof, but the core idea is all about this encoding of $X$ into $Z$ via discretization.

#### Takeaways

On the surface, this finding is devastating. Conditional independence tests are a basic building block of statistics. For example, foundational techniques in causal inference, like the PC algorithm, rely on conditional independence tests. Every test for a zero coefficient in a regression model is a conditional independence test within a limited set of distributions. This theorem seems to say that any quantitative scientist seeking to simplify their models with some kind of structure -- for example, a macroeconomist trying to simplify an [autoregressive model relating inflation, industrial production, the S&P 500, etc.](https://www.cmu.edu/dietrich/philosophy/events/workshops-conferences/causal-discovery/hoover.html) -- it is impossible to make *any* progress without *a priori* assumptions on the complexity of the relationships between variables. Model structure inference *cannot* be solely data-driven. 

Practically speaking, I don't think this finding makes much difference to modern science. The key question: when do tiny fluctuations in one variable carry substantial info about other variables? Maybe they do in chaotic-but-deterministic domains like meterology or n-body problems. For biology, economics, and neuroscience, tiny fluctuations in measured variables probably don't carry comprehensive information about other variables. 

Another matter is whether conditional independence tests are needed. In n-body problems, conditional independence tests are not really needed; the causal structure is pretty clear because it's just gravity. Some scientific fields using sparse causal structure also have methods of directly measuring network structure (ChIP-seq, [BrainBow](https://en.wikipedia.org/wiki/Brainbow)) so they don't need to rely on conditional independence tests alone. 

#### Coda

This is part of a series on [disturbing impossibility theorems](impossible_0).
