
This miniseries is a multifaceted look at the derivations behind logistic regression. Today's post is

### View #3: Binomial generalized linear models and canonical link functions

Logistic regression is part of a family of regression models called generalized linear models. These have two modular components that can be swapped in and out. We already discussed replacing the sigmoid with other nonlinear functions, so that is one modular aspect. The other modular component is the response distribution, which is binary for logistic regression but could be altered to accommodate other data types. The general recipe is typically presented as follows -- $D$ is the response distribution and $g^{-1}$ is the sigmoid. 

$$g(E[Y]) = \beta X$$

$$Y \sim D(E[Y])$$

People use this model family because it's customizable, extensible, and well understood. In fact, it's extremely well understood, to the point where the behavior of these models can be guaranteed in certain ways even when the model is wrong. This is the other reason to use logistic regression.

#### Main point

**Logistic regression and its relatives are consistent even under model misspecification, and this property relies on the exact form of the sigmoid function.**

#### Details

For exponential family distributions, the pdf of the response can be written $\exp(c(\theta) + \eta(y)^T\theta)$, where $\theta=g^{-1}(x^T\beta )$. The log pdf is $c(\theta) + \eta(y)^T\theta $  and its derivative w.r.t. $\theta$ is $c'(\theta) + \eta(y)$. The usual way of optimizing this -- setting that derivative to zero -- gives rise to an *estimating equation* $c'(\theta) + \eta(y) = 0$. Once this point is reached, we can estimate $-c'(\theta)$ using the sample mean of the natural parameters $\frac{1}{N}\sum_{n=1}^N \eta(y_n)$. 

Why go into this? Suppose we are completely wrong about the response distribution $D$. Maybe we thought it was Poisson or binomial, but it's actually overdispersed due to unmodeled heterogeneity. It's unclear what a maximum likelihood procedure will end up with in this situation. The anchor we have to hold on to is the estimating equation. It is a method of moments estimator, and the only thing it needs in order to be unbiased for $c'(\theta)$ is for the population mean $E[\eta(y)]$ to exist. 

That's nice, but nobody cares about some obscure normalization constant based on a parameterization that we only use when we're forced to class. Is there any way we could extend this clever and reassuring unbiasedness argument so that it applies to our coefficients $\beta$?

Yes! If we select a link function $g$ such that $c'(\theta) = c'(g^{-1}(x^T\beta))$ reduces to just  $x^T\beta$, then the consistency argument will apply to $\beta$, the parameters we are actually interested in. In other words, 

- Find the exponential family representation of your response distribution
- Find the log normalizing constant $c$ and differentiate it. That's the *canonical link function* for this response distribution, and it allows your response distribution to be completely wrong (as long as it's not too heavy-tailed) and still yield unbiased coefficients. 

#### Punch line 

Let's practice! 

- My response distribution is bernoulli, and it has pdf equal to $p^y(1-p)^{1-y}$. Taking a log and an exponent, this equals $\exp(y\log p+ (1-y) \log(1-p)) = \exp(y\log (\frac{p}{1-p}) +  \log(1-p)) $. The natural parameters are $\theta \equiv \log\frac{p}{1 - p}$ and the log normalizing constant is $\log(1-p) = \log( 1 - \frac{\exp(\theta)}{1 + \exp(\theta)}) = \log(\frac{1}{1 + \exp(\theta)}) = -\log(1+\exp(\theta))$. It's crucial to distinguish between $p$ (from the parameterization you know and love) and $\theta$ (from the unique exponential family representation, which you don't know and don't like). 
- The derivative of  $-\log(1+\exp(\theta))$ is $ \frac{-\exp(\theta)}{1 + \exp(\theta)}$. That's ... the sigmoid function. (It's negative, but if you review the argument, it turns out that particular nattering nebob doesn't matter.)

#### Simulation