
## Why logistic regression? (Part 3)

This miniseries is a multifaceted look at the derivations behind logistic regression. You're reading part 3, about mixture models and feature selection. Here's [part 1???](???) and [part 2???](???).

--

The typical presentation of logistic regression begins with a real input $x$ and a binary output $y$. This section will flip the model upside down. Suppose we had started with a binary label $y$ and generated a feature vector $x$ . If $y$ is 1, we'll generate $x$ according to model 1: $x \sim D_1$. If $y$ is 0, we will use a different generative model $x \sim D_0$. Now, suppose we forget the details of $D_1$ and  $D_0$. (More realistically, suppose they represent natural processes that are not fully understood.) Given a set of training data, what is the best way to recover $y$ from $x$? 

#### Main point

**Under certain (surprisingly general) conditions, the optimal way of inverting this exponential mixture procedure -- recovering $y$ from $x$ -- is logistic regression.**

#### Details

Suppose the distributions $D_y$ both belong to the exponential family, meaning the pdf of $D_y$ is $f_y(x) = \exp(g(\theta_y)+\eta(x)^T\theta_y)$. (The exponential family captures many common distributions, including Poisson and Gaussian. For example, if $\eta(x)$ is $x$ squared elementwise and $\theta$ is constant, then the result is an isotropic Gaussian.) Suppose that the data come from an initial coin-flip $Pr(y=1)=\pi$, followed by simulation of $x$ from the component given by the coin-flip outcome. Given $x$, how should we predict $y$?

Well, by Bayes' rule, 

$$Pr( y=1| x) = \frac{Pr(x | y=1)\pi}{ Pr(x | y=1)\pi +  Pr(x | y=0)(1-\pi)}$$

. Plugging in the pdf's, we obtain

$$Pr( y=1| x) = \frac{\exp(g(\theta_1)+\eta(x)^T\theta_1)\pi}{\exp(g(\theta_1)+\eta(x)^T\theta_1)\pi + \exp(g(\theta_0)+\eta(x)^T\theta_0)(1-\pi)}$$

, which can be simplified to

$$Pr( y=1| x) = \frac{1}{1 + \exp(g(\theta_0) - g(\theta_1))  \frac{(1-\pi)}{ \pi}\exp(\eta(x)^T(\theta_0-\theta_1))}$$

If we care only about the functional form of the dependence on $x$, then this can be reduced further to 

$$Pr( y=1| x) = \frac{1}{1 + \exp(\beta_0 + \eta(x)^T\beta_1)} = \sigma(\beta_0 + \eta(x)^T\beta_1)$$. (The exact values that achieve this are $\beta_0 = g(\theta_0) - g(\theta_1)+\log(\frac{1-\pi}{\pi})$ and  $\beta_1 = \theta_0 - \theta_1$ .) 

#### Punch line

If you assume any exponential generative model for $x$ given $y$ and set your features $\Phi(x)$ equal to the canonical exponential family representation $\eta(x)$, then logistic regression is the way to recover $y$ from $x$ using Bayes' Rule (and Bayesian procedures are often [as good as it gets](https://en.wikipedia.org/wiki/Bayes_estimator#Admissibility) in some sense). 


#### Bonus #1

Suppose you have an abundance of training data from class 1 and not much from class 2, but for new data, you expect otherwise: maybe they are equally likely to come from either class or maybe they are even more biased. The formula for $\beta$ (the LR coefficients) tells you how to adjust them for a different prior $\tilde\pi$:

- Since $\beta_0 = g(\theta_0) - g(\theta_1)+\log(\frac{1-\pi}{\pi})$, you can estimate $\pi$ as $\hat \pi$ by counting successes/failures, subtract $\log(\frac{1-\hat \pi}{\hat \pi})$, and add on $\log(\frac{1-\tilde \pi}{\tilde \pi})$. 
- Since $\beta_1 = \theta_0 - \theta_1$, that doesn't need to change. 

You may find that this eerily echoes the other post in this miniseries, which is about case-control sampling.

#### Bonus #2

This derivation extends to multivariate logistic regression. Start off your mixture model with $K$ clusters and $K$ prior probabilities $\pi_k$ and you'll see:

$$Pr( y=1| x) = \frac{\exp(g(\theta_1)+\eta(x)^T\theta_1)\pi_1}{\sum_k\exp(g(\theta_k)+\eta(x)^T\theta_k)\pi_k}$$.

If you care only how the prediction depends on $x$, then you can boil this down to multiclass logistic regression.

