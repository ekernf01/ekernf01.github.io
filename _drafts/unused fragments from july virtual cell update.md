
### Unused fragments from July virtual cell update

#### A simple way to combine MSE-strong and retrieval-strong baselines

The mean of the wrong perturbation effects in the right cell type (call this $M_1$) often does well on MSE-like metrics. The mean of the right perturbation effect across the wrong cell type (call this $M_2$) often does well on retrieval metrics. Consider the following simple strategy to combine their performance: return $M_1 + \epsilon M_2$ where $\epsilon$ is a very small number. This would limit damage to $M_1$, and it might preserve the retrieval metrics of $M_2$. Consider predictions for perturbations A and B: $M_1 + \epsilon M_{2A}$ and $M_1 + \epsilon M_{2B}$. If the true outcomes are $Y_A, Y_B$, then the distances determining the retrieval metric for perturbation A would be $||Y_A - (M_1 + \epsilon M_{2A})||^2$ and $||Y_A - (M_1 + \epsilon M_{2B})||^2$. These can be written $||Y_A||^2 - (M_1 + \epsilon M_{2A})||$

 If $Y_A - M_1$ is roughly orthogonal to $$