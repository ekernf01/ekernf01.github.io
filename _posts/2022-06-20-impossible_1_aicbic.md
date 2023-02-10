---
layout: post
title: You can't achieve optimal inference and optimal prediction simultaneously.
math: true
permalink: impossible_1
tags: stat_ml
---

It's natural to want and expect a one-stop shop. The best fitting model ought to give both the best predictions and the best inferences. 

Does it?

![The meme where Bugs Bunny smugly says "No."](images/BugsBunnyNo.jpg)

This brings me to the first topic in a [series on impossibility theorems](impossible_0): Yuhong Yang's "[Can the strengths of AIC and BIC be shared?](http://users.stat.umn.edu/~yangx374/papers/Pre-Print_2003-10_Biometrika.pdf)"

#### A fundamental tradeoff in selecting linear model complexity for prediction vs inference

Yang considers linear regression

$$Y_i = \Phi(X_i)^T\theta + \epsilon_i$$

where $\theta$ could be in either a family of possible parameters $\mathcal F_2$ or a smaller family $\mathcal F_1$ that is essentially a linear subspace of $\mathcal F_2$. For example, if $\Phi(X) = (x_1, x_2, x_3)$, then $\mathcal F_2$ could be any vector $(\theta_1, \theta_2, \theta_3)$ and $\mathcal F_1$ could require $\theta_3=0$.  Yang considers two desirable properties. 

- Consistency. If $\theta \in \mathcal F_1$, we want to eventually select the smaller family. BIC has this property and AIC does not, which was proven prior to Yang's work.

- Minimax-rate optimal risk. Essentially, this means you're making the best possible predictions about $Y$. AIC has this property and BIC does not. This was proven prior to Yang's work. Skip the rest of this bullet if you don't want the formal definition. Suppose the maximum likelihood estimator of $\theta$ within family $\mathcal F_k$ is $\hat \theta_k$. Suppose the family $k$ is selected by $\delta(X, Y)$, meaning $\delta$ implements a procedure like "return the family with the best AIC." Suppose the "risk" is the expected squared error: 
$$R(\theta, \delta) = E[ \frac{1}{N} \sum_i (Y_i - \Phi(X_i)^T\hat \theta_{\delta(X, Y)})^2]$$
. The worst-case risk is 
$$\max_{\theta\in \mathcal F_2} R(\theta, \delta)$$
, and notice that the max is taken over the bigger family. A minimax-rate optimal selection procedure is a $\delta$ that minimizes the worst-case risk. (Rather, the word "rate" means it doesn't have to be the best, but as a function of the size of the data, it has to shrink just as fast as the best.) 

Naturally, people wanted to know if some AIC-BIC hybrid could achieve both consistency and minimax-rate optimal risk. Yang's contribution is to say "No."

Yang begins his argument with a mercifully simple example (one-dimensional $x$), and it is not too hard to follow up to the bottom of page 7. He shows that the rate of convergence of the minimax risk for any consistent model selection procedure has a crucial component involving the probability of selecting the simpler model. After that, it gets really into the weeds to show that even the most powerful possible test has to select the simpler model too often to have minimax-rate optimal risk. 

#### Takeaways

The implications of this finding are profound and ubiquitous. For one example, polygenic risk score development is a high-dimensional linear model selection problem. Yang's finding would suggest that the best possible polygenic risk score *for making predictions about individuals* will always extend beyond use of just variants & genes we can be reasonably certain about. I'd expect the same to hold for [predicting antibiotic resistance from bacterial genomes](https://www.dayzerodiagnostics.com/). 

Formally speaking, polygenic risk scores typically do not use maximum likelihood estimators (too high-dimensional), so I am not certain if Yang's Theorem 1 applies. If some extension is possible, I don't know what exactly that work would say and whether it has been done. If you know, send me an email or a tweet (@ekernf01) and I'd appreciate it! 


#### Coda

This is part of a series on [disturbing impossibility theorems](impossible_0).
