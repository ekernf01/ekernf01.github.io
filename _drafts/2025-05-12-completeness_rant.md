---
layout: post
title: Statistical completeness rant
math: true
tags: stat_ml
permalink: completeness
---

Completeness is at the very foundation of statistics: so why does it have such a horribly ill-fitting name?🧵

Background: "Completeness" fulfills a basic function of statistics by helping determine "this estimation method is the most efficient among all unbiased methods".
https://en.wikipedia.org/wiki/Completeness_(statistics) 

You also need "completeness" to understand other things in stats [such as proximal causal inference](https://arxiv.org/pdf/2009.10982).

Unfortunately, "complete" is the worst possible name for a "complete" statistic. I propose a better name: "pithy".

Setup: suppose we have an iid sample X1, ... Xn from a distribution with an unknown parameter s. Suppose U summarizes the sample.

Oversimplifying, we say a statistic U is "complete" when for any function v:

E[v(U)|s] = 0 for all s ==> v(u)=0 for all u. 

So what's wrong? First, a funny thing happens when you add something irrelevant to a "complete" statistic: it becomes incomplete (?). 

Let W = [U,X] for any zero-mean X. If you set v(W) = W[2], then you find that E[v(W)]=0 for nonzero v. 

This is inconsistent with the usual meaning of "complete": appending gibberish to the Complete Guide to Playing the Lute should not render your lute library incomplete.

A similar funny thing happens when you distribute a "complete" statistic over two pieces: let W = [U + X, U - X] for any zero-mean X; set v(W)=W[1]-W[2].

Buying the Complete Guide to Playing the Lute as a two-volume set should not render your lute library incomplete.

Second, "complete" statistics do not contain all information in a sample!! `¯\_(ツ)_/¯`
https://stats.stackexchange.com/questions/187869/are-complete-statistics-always-sufficient

If you want to knock me for buying a second copy, or for including a second set of liner notes, and you don't care that **I only bought the first chapter**, "pithy" is what you want. Or "concise", or "brief", or "parsimonious". Not "complete". 

**"Complete" statistics contain no noise, only signal. They do not contain all the signal.** They would be better called "pithy" statistics. End rant.

