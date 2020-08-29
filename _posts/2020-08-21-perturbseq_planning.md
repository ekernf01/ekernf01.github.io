---
layout: post
title: Experiments with one control and $k$ treatments have highest power when the control arm is $\sqrt k$ times bigger than each individual treatment arm
math: true
permalink: perturbseq_planning
---

When we screened transcription factors influencing endoderm differentiation ([post](https://ekernf01.github.io/DE_screen), [paper](https://pubmed.ncbi.nlm.nih.gov/30995470/)), we ran into an interesting design problem. The experiment had 49 different treatment conditions and one control. Treatments were not allowed to overlap. We were able to measure outcomes in a fixed number of cells -- as it turned out, about 16,000. What is the optimal proportion of cells to use as controls?

If we had one treatment and one control, it's a pretty safe bet to use 8,000 control cells and 8,000 treatment cells, unless you expect a much higher standard deviation in one group. But with 49 treatments, control cells are each used in 49 comparisons, whereas treatment cells are used only once. This could be a nice opportunity to re-use cells. Think about it like this: we could allocate 16,000/50 = 320 cells to each condition, or allocate 319 for each treatment and 320+49 = 369 for the control. The second option seems like a gain of ~49 cells in exchange for a loss of just one in each comparison, which is obviously good. In fact, you could also have 318 versus 320+49+49 = 418, or 317 vs 477, and so on. Obviously, you can't continue to far, or you will have 16,000 control cells and no treated cells. What is the right balance?

## Derivation based on the length of a typical confidence interval

Let us derive an answer by considering the width of a confidence interval for the estimate of the difference between the control and treatment. I use notation common in statistics: $X_i$ or $Y_i$ is the observation for cell $i$ and $\bar X$ or $\bar Y$ is the sample mean. $X$ is for treatment cells and $Y$ is for control cells. If the response is considered to be Gaussian -- this assumption will be discussed and relaxed below -- the interval would typically be centered around the difference in sample means, $\bar X - \bar Y$, and its width would be proportional to  $\sqrt{ Var(\bar X - \bar Y)}$. I will omit the square root for simplicity, but this will not alter the results. If each cell is assumed to be independent of the others, the variance of $\bar X - \bar Y$ is $Var(\bar X) + Var(\bar Y)$. Since $\bar X = \frac{1}{n_x}\sum_{i = 1}^{n_x} X_i$, 

$$Var(\bar X) = \frac{Var(X_1) + ... Var(X_{n_1})}{n_x^2} =  \frac{n_xVar(X_1)}{n_x^2} =  \frac{Var(X_1)}{n_x}$$

, and a similar result holds for $Y$.

#### Key result

If the treatment and control have variances $\sigma^2_x$ and  $\sigma^2_y$ respectively, the end result is that we want to **minimize $\frac{\sigma^2_x}{n_x} + \frac{\sigma^2_y}{n_y}$ subject to $49n_x + n_y = 16000$**. 

#### Resuming the derivation

Before resuming, we could restore the square root, but this would not change the location of the minimum. Since I am terrible at using [Lagrange multipliers](https://en.wikipedia.org/wiki/Lagrange_multiplier) for constrained optimization, I will rewrite this without the constraint before solving. If the extra size of the control is defined as $n_y/n_x = c$, then $$cn_x + 49n_x = 16,000 \implies n_x = 16,000/(49+c) \implies n_y = 16,000c/(49+c) $$ . In terms of just $c$, we want

 $${ \rm argmin }_{c}\frac{\sigma^2_x}{16,000/(49+c)} + \frac{\sigma^2_y}{16,000c/(49+c)} \\= { \rm argmin }_{c}\frac{\sigma^2_x(49+c)}{1} + \frac{\sigma^2_y(49+c)}{c}  \\= { \rm argmin }_{c}{\sigma^2_x(49+c)} + \sigma^2_y + \frac{49\sigma^2_y}{c} $$ .

Zeroing out the derivative yields $$0 = \sigma^2_x - \frac{49\sigma^2_y}{c^2} \implies c^2 =  \frac{49\sigma^2_y}{\sigma_x^2} $$. If the variances are equal, then $c^2=49$ and it's best to have 7 times as many control cells as each individual treatment. This can be generalized to any number of cells and treatments as follows. 

#### Key result

The control arm should be $\sqrt{k\frac{\sigma^2_y}{\sigma^2_x}}$ times bigger than any individual treatment group.

The actual result is slightly more complex than the post title admits: it also depends on the standard deviations of control and treatment. All else being equal, one should help out groups with higher standard deviation by allocating more cells to them.

## When does this result apply and when does it fail?

#### Heteroskedasticity 

The result in the title assumes that treatment and control groups have equal variances. The more detailed result from the derivation does not -- yet it is not immediately usable, since depends on the variances, and these are seldom known prior to the experiment. Here are some considerations for planning around this issue.

- For a binary outcome, such as "proportion of cells classified as endoderm", variance is highest at 50-50 and lowest at lopsided extremes. The variance is likely to be low among the control arm, as modern protocols give >95% pure endoderm. It might be higher for perturbations that disrupt endoderm formation. Or, if the perturbation has no technical issues and the effect is highly penetrant, the treatment variance could be low too.
- For log-transformed gene expression, variance is generally higher for high-expressed genes. If the treatment changes the mean expression level, it likely will change the variance too. For many genes with effects in both directions, it seems reasonable to **design the experiment as if the variances were the same even if you know they aren't** -- as we like to say in statistics, "under the erroneous yet tractable assumption of homoskedasticity". 
- If you have a specific outcome of interest, pilot data could help determine the ratio between the variances.

#### Non-Gaussianity 

What about the assumption that the outcomes are Gaussian in the population of cells sampled for the experiment? **Being Gaussian is actually not essential.** Most of the calculations require only that the variances exist. The idea of forming a confidence interval whose width is proportional to the square root of the variance appears in widely used non-Gaussian methods such as edgeR or quasi-poisson regression.

#### Lack of independence 

A more serious issue arises if you smooth or impute gene expression prior to running differential expression tests: the cells will no longer be independent. You would not get proper coverage for naive confidence intervals, because after smoothing, the cells will appear less variable than they actually are. That is, of course, the purpose of smoothing, but **this result does not apply.** 