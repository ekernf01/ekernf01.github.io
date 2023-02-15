---
layout: post
title: Neural Network Checklist
math: true
permalink: neural_network_checklist
tags: stat_ml
---

Training neural networks is hard. Plan to explore many options. Take systematic notes. Here are some things to try when it doesn't work at first.

- Make it deterministic:
    - `np.random.seed` for numpy
    - `random.seed` for python
    - [deterministic functions for pytorch](https://pytorch.org/docs/stable/notes/randomness.html)
    - `deterministic=True` for [pytorch lightning `Trainer`](https://pytorch-lightning.readthedocs.io/en/stable/common/trainer.html)
    - Avoid natively non-ordered collections, like sets or dict keys `[i for i in set([3,1,2])]`
- Make it transparent. Log:
    - the training objective
    - the validation objective 
    - the norm of the gradient
    - the various components of your objective function (e.g. L1 penalty)
    - the number of iterations
    - the walltime per iteration and total
- Make it more stable:
    - Scale the input features to have mean 0, variance 1
    - Use a tried-and-true initialization
        - "Xavier" for feed-forward networks with sigmoidal activation ([explainer](https://cs230.stanford.edu/section/4/), [original article pdf](https://proceedings.mlr.press/v9/glorot10a/glorot10a.pdf))
        - "He" for feed-forward networks with ReLU activation ([explainer](https://medium.com/@shauryagoel/kaiming-he-initialization-a8d9ed0b5899), [article](https://arxiv.org/abs/1502.01852))
        - The identity matrix, lolol, for recurrent networks ([arxiv](https://arxiv.org/abs/1504.00941))
    - Use a ResNet architecture 
        - The usual:  `y <- f(Wx + b)`
        - The ResNet: `y <- f(Wx + b) + x` [(arXiv)](https://arxiv.org/abs/1512.03385)
- Make it easier:
    - Memorize 1 or 5 data points instead of fitting everything
    - Learn a single layer or a linear layer in place of your full architecture
    - Simulate data with *no noise* and try to fit that
    - On simulated data, cheat as much as necessary to identify problems. Example: initialize the weights to their true values.
- Optimization tricks in order of increasing desperation:
    - Max out the batch size
    - Use L-BFGS with Wolfe line search for fast debugging on small problems, but don't expect it to scale well
    - Mess around with the learning rate

More resources: 

- Eventually, once my current project is closer to publication, I will share notes from about 40 experiments that took me from baby steps up to the scale of real data. 
- [Stats SE thread](https://stats.stackexchange.com/questions/352036/what-should-i-do-when-my-neural-network-doesnt-learn)
- [Twitter thread by DSaience](https://twitter.com/DSaience/status/1590784746375720960)
- If you find something else helpful and you think it ought to be added here, please do contact me or tweet @ekernf01.
    


