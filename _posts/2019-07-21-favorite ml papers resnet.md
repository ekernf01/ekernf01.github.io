---
layout: post
title: Favorite machine learning papers (resnets)
math: true
---

I've been reading recently about debugging methods, starting with [this post by Julia Evans](https://jvns.ca/blog/2019/06/23/a-few-debugging-resources/). All the links I followed from that point have something in common: the scientific method. Evans quotes [@act_gardner](https://twitter.com/act_gardner)'s summary:

> What’s happening? What do you expect to happen? ... [G]uess at what could be breaking and come up with experiments.

This principle applies generally, not just in finding software bugs.  Here, I want to discuss a machine learning paper I really admire, the [He et al 2015 resnet paper](https://arxiv.org/pdf/1512.03385.pdf), which uses the same scientific method to rapidly improve performance in deep learning. With a simple and clever technique, derived from detailed knowledge of the state of the art followed by careful experimentation, they won first place in multiple image processing competitions in 2015. 

##### What's happening?

Performance degrades when you add layers to a neural net.

*N.B. If you don't know what a neural net is, you can think of it as a sequence of mathematical transformations that are automatically adjusted or optimized to achieve a particular goal. Adding a layer means adding another transformation to the sequence. Deep learning means machine learning with neural nets with many layers.*

##### What do you expect to happen?

Deep learning should be great! The deeper, the better! If the extra layers aren't helping, then they should be able to at least preserve the already-good output from a shallower model. (Let's call this The Big Bad Assumption.)

##### Guess at what could be breaking and come up with experiments.

He et al name three possibilities: 

- they could be [overfitting](https://www.coursera.org/lecture/ml-regression/overfitting-demo-o6wzg)
- they might suffer from an optimization problem called vanishing gradients. 
- they might be unable to preserve high-quality output from middle layers. (This is a failure of the Big Bad Assumption.)

Through experimentation in previous papers -- some with He as a first author -- the first two problems are ruled out. For example, the overfitting explanation implies low training error as well as test error, but training error actually also increased with depth. This leaves the third explanation: the Big Bad Assumption has failed. 

He et al tested for the failure of the Big Bad Assumption by modifying their neural networks. They made a new structure, the resnet, that has an easier time leaving good output alone when necessary. Then, they fit it to data and found that indeed, it was leaving good output alone (or making only minor modifications).

> Replace $H(x)$ with $H(x) + x$. If $H(x)$ can learn to be $0$, then $H(x) + x$ can learn to be $x$, leaving good output unmolested.
> 
> Now check: is $H(x)$ actually close to $0$ in fitted resnets? 

This final experiment succeeded and paved the way for He et al to fit extremely deep neural networks with unprecedented performance.