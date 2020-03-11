---
layout: post
title: Vibration of effects overstates variability by mixing up marginal and conditional parameters
math: true
---


Chirag Patel (Harvard DBMI) works on big-data epidemiology, implementing methodological insights from large-scale human genetics studies in a broader setting that includes environmental exposures. The basic idea is that people are exposed to hundreds or thousands of potentially risky substances like heavy metals, smoke and dust particulates, and organic pollutants. These probably cause disease, and we'd like to know which ones cause which diseases, and how much they influence risk. Testing for these connections one at a time is likely to yield false positives and overestimates for the same reasons that [candidate gene studies in psychiatry do](https://slatestarcodex.com/2019/05/07/5-httlpr-a-pointed-review/). Patel has begun testing them en masse, measuring as much as possible of the "exposome" and comparing it to health records.

Model uncertainty is a big part of that work. If they have data on socioeconomic status, health, gender, age, race, and so on, which of these factors should be "adjusted for"? In the "vibration of effects" method ([paper](https://www.sciencedirect.com/science/article/pii/S0895435615002772), [code](https://github.com/chiragjp/voe/blob/gh-pages/vibration/vibration.R)), they answer by fitting models with many different combinations of variables to adjust for, then looking at the results: how often are they bimodal or in opposite directions? This is very similar in spirit to [bayesian model averaging](https://www.stat.colostate.edu/~jah/papers/statsci.pdf). 

Unfortunately, there's a statistical snake-in-the-grass here called *non-collapsibility*, and Patel & colleagues have been bitten. For basically any model except for the simplest ordinary least squares, there is a subtle difference that arises when you add extra variables to your analysis: your target parameter actually changes! 
