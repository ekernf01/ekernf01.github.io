---
layout: post
title: Four disturbing impossibility theorems
math: true
permalink: impossible_0
tags: stat_ml
---

I remember reading, maybe in a decades-ago issue of *Scientific American*, that geometry and physics professors sometimes hear from cranks. These arrogant people, working in isolation, earnestly believe they have discovered something important. Typical examples might be trisecting an angle with a compass and straightedge in a finite number of steps or [unifying physics](https://arxiv.org/pdf/quant-ph/0206089.pdf). I have not understood the details of those examples personally, but there is a basic, recurring disconnect between the position of the crank -- "The establishment has tried and failed; they do not understand" -- and the position of the establishment -- "We understand thoroughly; this task is proven to be impossible." 

In order to avoid wasting time on the wrong side of this dichotomy, the progressive scientist naturally wants to be acquainted with any impossibility theorems that affect their studies. In my field, statistics, this is easier said than done, because these impossibility theorems are not often taught, and some of them are genuinely surprising. In particular, one would hope that just about any statistical model could be learned correctly in principle. With no technological barriers, no ethical objections, and no limits on funding or resources, or simply with a computer simulation as the data generating mechanism, one would hope that cranking out more and more data would lead to inferences that are *eventually correct*, except in obvious cases like a regression with multiple exactly identical predictors.

![The meme where Bugs Bunny smugly says "No."](images/BugsBunnyNo.jpg)

One would be disappointed. Beyond that, one would be *disturbed* by the number of basic and fundamental goals that are now known to be out of reach. And not just out of reach given present techniques or datasets: provably, irretrievably out of reach given any technique and any experimental design. What are these goals?

- [You can't achieve optimal inference and optimal prediction simultaneously](impossible_1)
- [You can't satisfy three simple desiderata for a clustering algorithm](impossible_2)
- [You can't test if the mean is 0.](impossible_3)
- [You can't test for independence conditional on a quantitative random variable](impossible_4)
