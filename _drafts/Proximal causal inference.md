### Proximal causal inference

### Source number 1

Trying to read [this](https://arxiv.org/pdf/2009.10982).

- Had to go back and review the g-formula. Seems like a formalization of "we controlled for this by adding it as a covariate in a GLM". 

> [T]he analyst can correctly classify proxies into three bucket types: a. variables which are common causes of the treatment and outcome variables; b. treatment-inducing confounding proxies versus c. outcome-inducing confounding proxies. A proxy of type b is a potential cause of the treatment which is related with the outcome only through an unmeasured common cause for which the variable is a proxy[.] [A] proxy of type c is a potential cause of the outcome which is related with the treatment only through an unmeasured common cause for which the variable is a proxy. Proxies that are neither causes of treatment or outcome variable may belong to either bucket type b or c.

This is starting to sound like the [Celestial Emporium](https://en.wikipedia.org/wiki/Celestial_Emporium_of_Benevolent_Knowledge). For clarity, let's see if we can rewrite this without the horribly vague phrase "common cause", which inevitably inspires the question "Common to what?" Going down the list:

- Type A seems like the usual measured confounder. 
- Type B seems like an instrumental variable at first (potential cause of the treatment), but it's also allowed to be related to the outcome "through an unmeasured common cause". If B is the proxy, T the treatment, O the outcome, and U the unmeasured common cause, I think the authors are trying to specify a structure like U -> B, B -> T, T -> O, U -> O, and they specifically exclude B -> O. 
    - In section 3, we learn that this is elsewhere called a negative control exposure, but these authors find the name unsuitable.
    - As an example of type B, the authors give CD4+ T cell counts in HIV patients. These affect treatment: doctors may not prescribe ART if CD4+ counts are high (at least, this was true in the past). The argument goes that CD4+ counts are also unlikely to directly affect disease progression (the outcome) because they are an error-prone proxy for the true state of the immune system. This seems like a cop-out where simply adding a little noise has magical effects, but I am OK with it because the of the direct effect of these noisy measured values on treatment decisions. 
- Type C seems like a dual of type B: I think the authors are trying to specify a structure like U -> C, C -> O, T -> O, U -> O, and they specifically exclude C -> T. One thing caught me off guard: I expected O -> C, but it's actually C -> O.
    - In section 3, we learn that this is elsewhere called a negative control outcome, but these authors find the name unsuitable.
    - As an example of type C, the authors give MMSE at baseline. In this case, U is mental decline, which is common in HIV. Mental decline can compromise medication adherence (is this the same as treatment, or not?), ultimately affecting disease progression (the outcome). Why is MMSE taken to affect the outcome but not the treatment? Yet again they seem to add noise that magically preserves some direct causal effects (C -> O) while removing others (C -> T), and this time it seems unjustified. Conditional on complete measurements of mental decline, I would expect MMSE to directly affect neither T nor O. 

I have done them a disservice by left-truncating their quote above. It actually starts with "Mainly, proximal causal learning requires that the analyst can correctly classify...", and so it's clear they recognize possible structures where these assumptions do not apply. 

#### Linear example 


> (paraphrasing) Consider the following SEM. 
>
> - A: treatment (confusingly, A is not a type A proxy; it's a treatment)
> - Y: outcome
> - U: one-dimensional unmeasured confounder
> - X: measured confounders (type A from the Emporium)
> - Z: treatment proxy (type B from the Emporium)
> - W: outcome proxy (type C from the Emporium)
> - (eq. 1) $E[Y|A, X, U, Z] = \beta_0 + \beta_a A + \beta_x X + \beta_u U$
> - (eq. 1) $E[W|A, X, U, Z] = \eta_0 + \eta_x X + \eta_u U$
    
In equation 1, why does the outcome-inducing proxy W not appear in the RHS of expectation for the outcome Y? Does an outcome-inducing proxy not induce changes in the outcome? Literally bucket C says "a proxy of type c is a potential cause of the outcome".

> If we integrate out U, we get a useful pair of equations.
> 
> - $E[Y|A, X, Z] = \beta_0 + \beta_a A + \beta_x X + \beta_u E[U|A,X,Z]$
> - $E[W|A, X, Z] = \eta_0 + \eta_x X + \eta_u E[U|A,X,Z]$
 
Solving for $E[U|A,X,Z]$ and substituting yields their eqn. 2.
 
> (eq. 2) $$E[Y|A, X, Z] = \beta_0 + \beta_a A + \beta_x X + \frac{\beta_u }{\eta_u}(E[W|A, X, Z] - \eta_0 + \eta_x X)$$

This has the correct value for $\beta_A$, and it's entirely written in terms of known quantities because $U$ is gone. So just do the regression using those known quantities.

> Let $\hat W$ denote an (asymptotically) unbiased estimator of $E(W|A, Z, X)$. Then equation (2) suggests that ..., the least squares linear regression of Y on $A, X, \hat W$ recovers a slope coefficient for A that is consistent for the causal parameter $\beta_a$. In contrast, either removing $\hat W$ from the regression model, or replacing it with either W or (W, Z) will generally yield a biased estimate of $\beta_A$.

In the ..., I omitted their requirement that $E (U|A, X, Z)$ must depend on Z. It seems unnecessary, but I may learn otherwise soon. They write "suggests" because indeed, it's not totally obvious that we can substitute $\hat W$ here. 

##### Anger

Equation 2 also raises red flags. In real scientific problems, unmeasured confounders will not be one-dimensional, and the column space of will probably not be spanned by the column space of the proxy. The true status of the immune system is certainly not a scalar, nor is mental decline. This seems like a fatal flaw, and one could probably devise a simple simulation to demonstrate it.

#### Section 3

This section presents an example DAG (not the only possible example) plus some explicit criteria. It makes a lot more sense than the rest so far, but more questions come up:

First, it's interesting that IV's are of type A: I would have expected them to be of type B, since they affect treatment. Maybe they can be regarded either way and the procedure still is valid? But does it yield the same estimates either way? Is any special case of PCI equivalent to IV, or rather is it a new way of using similar structures? Hopefully can revisit this; I will give them a few more pages lolol. 

Second, a wrinkle in time. They write:

> It is sometimes reasonable to include post-outcome variables in Z so that exclusion restriction conditions hold, again due to temporal ordering.

But then how could Z (the treatment-inducing proxy) induce treatment? What does "induce" even mean? In other quant usages, such as "changing electric fields induce magnetic fields" or "conditioning on a collider induces a correlation between marginally independent variables", "induce" means "cause", but if Z is measured post-treatment, then Z does not cause X. 

One possible explanation is that treatment-inducing or outcome-inducing proxies *may* induce the thing that they nominally induce, but they are not *required* to. This is compatible with the linear SEM example and it doesn't cause any div-by-zero.

##### Completeness 

They require a completeness condition. 

$$E[v(U)|a,x,z]=0 \forall a,x,z \implies v=0$$

Side notes: 

- I have a whole [rant about "completeness"](https://ekernf01.github.io/completeness).
- They write the implication both ways, but v=0 obviously implies $E(v(U))=0$.

This condition means $U$ may not contain any garbage that is not informative about $a,z,x$. This implies:

- $U$ may not be symmetrical for all azx; otherwise set $v$ to $sign(U)$.
- If everything is discrete, the proposition that "a, x, z must have at least as many categories as U". Otherwise, find two values of U that map to the same configuration of azx and set $v$ to $\pm 1$ on those values of $U$ (or, if they have unequal probability, weight $v$ as needed). 
- $U$ may not contain any coordinate that is generated independently of $a,z,y$.

This is their way of admitting what I wrote above in the "anger" section. If this is a requirement, then it will never be met, and statisticians are about to cajole and [Euler](https://slatestarcodex.com/2014/08/10/getting-eulered/) untold numbers of hapless epidemiologists into making invalid inferences that are even harder to debunk than the usual invalid inferences.

### Source number 2

Trying to read [this](https://academic.oup.com/aje/article/192/7/1224/7098281) and the HIV example in Figure 1 raises many questions.

- When is each of these variables defined?
- Why would age affect measured CD4+ count *conditional on the true count*? This does not make sense to me; how is the measurement done?
- Why would measured CD4+ count affect viral load *even conditional on the true count*? Do people take their medication more faithfully if their doctor says their immune system is on the ropes?
- Why does viral load not affect CD4+ count or self-rated health? Isn't that ... the reason we care about HIV?
- Why can't treatment assignment affect self-rated health?
- Why are you doing literally any of this math/computation?

I didn't get very far with this because it seems like they just provide an example procedure with no explanation. 

### Messy notes

Proximal causal inference is named for the use of "proxies". They come in two flavors: proxies for exposures and proxies for confounders. These proxies can be instrumental variables or they can be negative controls.


(Clean this up)

Proxy for exposure -> exposure -> outcome 

Confounder -> proxy outcome 

Some examples:

- maternal stress, birth weight, paternal stress, ???
- flu vaccination, covid vaccination, covid, flu
- genetic variant, gene expression, disease, ???

The language is tricky because "Y is a proxy for X" definitely conveys a direct causal effect, but "Y is a negative control for X" conveys the absence of an effect. There is no actual contradiction because the terms "negative control" and "proxy" apply to different pairs of variables in the graph. 

- Paternal stress is a negative control w.r.t. birth weight because it cannot biologically affect birth weight in the way that maternal stress might. It is a proxy for whatever is stressing out those expecting parents.
- flu vaccination is a negative control for covid vaccination because it cannot confer immunity to covid. It is a proxy for things like being pro- vs shrug- versus anti-vaccine.
- flu is a negative control outcome because covid vaccination doesn't affect flu risk. It's a proxy for having kids in daycare or any other respiratory disease risk factor.
- genetic variants are a ?????????
