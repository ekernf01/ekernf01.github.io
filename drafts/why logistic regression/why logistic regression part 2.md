## Why logistic regression? (Part 2)

This miniseries is a multifaceted look at the derivations behind logistic regression. You're reading part 2, about case-control studies. Here's [part 2???](???) and [part 3???](???).

--

### A consistent estimator for highly efficient case-control studies 

Suppose you're designing a study on the association between colon cancer and red meat consumption. One immediate problem is that colon cancer is rare: you could follow 10,000 people for a decade and observe only 39 cases of colon cancer. You've spent a lot of money and put in a lot of work, and you've got so few cases to show for it that your R console refuses to label the corresponding tiny slice of pie.

![](/Users/EricKernfeld/Dropbox/blog posts/why logistic regression/Colon cancer incidence.png)



This situation arises frequently in epidemiology, and there is a correspondingly common work-around known as a *case-control design*. In a case-control design, you enroll 500 cases and 500 controls, instead of enrolling a simple random sample. This give you a much more powerful characterization of colon cancer patients' diet history at a fraction of the cost. 

But your sample is obviously biased. Can you still obtain reliable parameter estimates and quantify their uncertainty? (Spoiler alert: yes, if you use logistic regression.)

#### Main point

**In logistic regressions on case-control data and unbiased sampling, the underlying population parameters (the targets of inference) are the same (except for the intercept term). This makes logistic regression uniquely well-suited to case-control data.**

#### How to specify what exactly you are asking

If a statistical model is applied to a sample of people, as in an epidemiological study, it can be thought of as having population parameters. These are the coefficients you would get if you had the funding to recruit literally everyone for your study. These are not very concrete, conceptually, because you can't squeeze them out of your data. The best you can get is an estimate of them. Nonetheless, it's worth knowing what population parameters your procedure seeks. That allows you to ask when you might be able to study those parameters more efficiently and when you might be led astray.

The first part of my explanation is a discussion of these population parameters as the apply to logistic regression. I will discuss two simple measures of association: the *risk ratio* and the *odds ratio*. I will focus on the odds ratio, since it is the population parameter targeted by logistic regression. 

#### Population parameters by example 

Suppose we are investigating a single binary covariate $x$: do you eat red meat, or not? Suppose the population looks like this. (I made the numbers up.)

| Fake Counts | Has colon cancer | No colon cancer | Total   |
| ------------------ | ---------------- | --------------- | ------- |
| Eats red meat      | <span style="color:red">24</span>            | <span style="color:red">5000</span>              | <span style="color:red">5024</span>  |
| No red meat        | <span style="color:blue">15</span>            | <span style="color:blue">4961</span>           | <span style="color:blue">4976</span>   |
| Total              | <span style="color:violet">39</span>     | <span style="color:violet">9961 </span>          |    10000     |

The odds of having colon cancer are <span style="color:violet">39 / 9961</span> . (In common usage, "odds" and "probability" can mean the same thing. In statistics, they are related, but the denominator differs. In this example, the probability of having colon cancer is 39 / 10000 .) The higher the prevalence of colon cancer, the higher the odds. 

The odds ratio of colon cancer for red meat eaters versus red meat abstainers is the ratio of the odds within each stratum. That's <span style="color:red">( 24 / 5000 ) </span> /  <span style="color:blue">( 15 / 4961 )  </span>. The odds ratio is one way of measuring the association between red meat consumption and colon cancer. 

The risk of colon cancer for meat-eaters is <span style="color:red"> (24 / 5024) </span> -- that's just Pr(cancer | meat) -- and the risk ratio is <span style="color:red"> (24 / 5024) </span>/ <span style="color:blue">  (15 / 4976) </span> . The risk ratio is another way of measuring the association between colon cancer and red meat consumption.

#### Logistic regression estimates the log of the odds ratio 

This claim is a matter of algebra. If logistic regression says that $Pr(Y=1 | X) = \frac{1}{1+\exp(-\beta X)}$, then the odds are ${\frac{Pr(Y=1 | X) }{ Pr(Y=0 | X)}} =  {\frac{1}{1+\exp(-\beta X)} } {\frac{1+\exp(-\beta X)}{\exp(-\beta X)}}  = \exp(\beta X)$. The odds ratio is $\color{red}{\exp(\beta \times 1)} / \color{blue}{\exp(\beta \times 0)} =  \exp(\beta )$. The log odds ratio is then $\beta$. If you had data on the whole population, you could recover the odds ratio by using logistic regression instead of calculating it directly from the definition.

#### Case-control sampling preserves the odds ratio 

In the previous example, you have very little power to test for an effect of red meat consumption on colon cancer. Let's adjust the table so that you sample equal numbers of cases and controls. Here's the same table again, with new highlighting.

| Fake Probabilities | Has colon cancer | No colon cancer | Total   |
| ------------------ | ---------------- | --------------- | ------- |
| Eats red meat      | <span style="color:black">24</span>            | <span style="color:black">5000</span>              | <span style="color:black">5024</span>  |
| No red meat        | <span style="color:black">15</span>            | <span style="color:black">4961</span>           | <span style="color:black">4976</span>   |
| Total              | <span style="color:red">39</span>     | <span style="color:green">9961 </span>          |         |


You can represent a case-control design by taking the numbers from above and adjusting the cancer/non-cancer marginals so that they equal 500. 

| Fake Probabilities | Has colon cancer      | No colon cancer     | Total   |
| ------------------ | --------------------- | ------------------- | ------- |
| Eats red meat      |  |      | |
| No red meat        |  | |   
| Total              |  39 * <span style="color:red">500 / 39                  | 9961 * <span style="color:green">500 / 9961                |  1000

You got to control the bottom row, but then the rest of the table is determined by the relationship between colon cancer and red meat consumption (plus some sampling variability). 

| Fake Probabilities | Has colon cancer      | No colon cancer     | Total   |
| ------------------ | --------------------- | ------------------- | ------- |
| Eats red meat      | 24 * <span style="color:red">500 / 39 | 5000 * <span style="color:green">500 / 9961      | |
| No red meat        | 15 * <span style="color:red">500 / 39</span> | 4961 * <span style="color:green">500 / 9961 |   |
| Total              | 500                  | 500               |  1000       |

 The convenient property here is that odds within each meat-group are skewed by a constant factor containing the numbers we used to adjust the sampling; it's 9961 / 39. Roll up your sleeves:

(24 * 500 / <span style="color:red">39</span>) / (5000 * 500 / <span style="color:green">9961</span>) = 24 / 5000 * <span style="color:green">9961</span> / <span style="color:red">39</span>

and

(15 * 500 / <span style="color:red">39</span>) / (500 * 4961 / <span style="color:green">9961</span>) = 15 / 4976 * <span style="color:green">9961</span> / <span style="color:red">39</span>.

The odds ratio is ( 24 / 0.5 * <span style="color:green">9961</span> / <span style="color:red">39</span>) / (15 / 0.4976 * <span style="color:green">9961</span> / <span style="color:red">39</span> ) =  ( 24 / 5000 ) / (15 / 4976 ), which is the same as before. 

Let's look back at the risk ratio for a minute. It's like the odds ratio, but instead of calculate the odds by putting the opposing group in the denominator, it uses the probability or risk by putting the total in the denominator. The denominator of the red-meat risk is (24 * 500 / <span style="color:red">39</span> + 5000 * 500 / <span style="color:green">9961</span>). The denominator of the no-red-meat risk is  (15 * 500 / <span style="color:red">39</span> + 4961 * 500 / <span style="color:green">9961 </span>). You can stare at this all you like, but there is simply no way to cancel what you would need to cancel. The risk ratio will get messed up by the case control design.  


### Recap

Odds ratios, which are the targets of inference in logistic regression, remain the same in a case-control design. Thus, logistic regression has an important advantage over alternative methods for this particular class of problems.