## Data-intensive wellness programs will enable covert discrimination based on pre-existing conditions, race, and social class


Kaiser Health News [article](https://khn.org/news/workplace-wellness-programs-put-employee-privacy-at-risk/) about wellness rewards programs' lack of concern for patient and consumer privacy (h/t [my dad](http://www.barrykernfeld.com/)). The article gives an extreme example from Houston:

>  Last fall the city of Houston required employees to tell an online wellness company about their disease history, drug and seat-belt use, blood pressure and other delicate information.
>
> The company, hired to improve worker health and lower medical costs, could pass the data to “third party vendors acting on our behalf,” according to an authorization form. The information might be posted in areas “that are reviewable to the public.” It might also be “subject to re-disclosure” and “no longer protected by privacy law."

Oh, and the opt-out penalty? $300. 

Luckily, the Houston case didn't last long against the backlash, but the article reels off a laundry list of companies collecting data on location, sleep and exercise habits, and even grocery purchases. There is no telling what kind of damage you can do based on location alone -- recall [the Times article reporting that location data reveal someone's hour-long trip to Planned Parenthood](https://www.nytimes.com/interactive/2018/12/10/business/location-data-privacy-apps.html). 

I applaud Kaiser Health for bringing these programs into the spotlight. I'd like to piggy-back on that and raise an issue that they don't mention: *it is impossible to implement wellness rewards programs without implicit discrimination.* Even assuming companies act in good faith and focus purposefully on evidence-based health scoring of foods, it will be virtually impossible to construct this system in a way that is free of racial bias.

Grocery purchases offer incredibly detailed information. You can infer race, class, and even pre-existing conditions from someone's groceries -- the accuracy will be far from perfect, but it will be much better than chance. Because of this, even so-called "fairness through unawareness" -- training models based on groceries and health outcomes with no knowledge of race, class, or pre-existing conditions -- will result in penalties to disadvantaged people.

Before we get into the details, remember that racial discrimination has arisen time and again through supposedly neutral decision criteria. You may not agree with all the claims that follow, but it should be easy for you to find at least one understandable example. Instances range from [redlining](https://www.washingtonpost.com/news/wonk/wp/2018/03/28/redlining-was-banned-50-years-ago-its-still-hurting-minorities-today/?noredirect=on&utm_term=.550f150737bc), [predictive policing](https://www.propublica.org/article/machine-bias-risk-assessments-in-criminal-sentencing), and [drug policy](https://www.vocativ.com/underworld/drugs/crack-vs-coke-sentencing/index.html) to [IQ tests](https://www.theatlantic.com/national/archive/2013/05/why-people-keep-misunderstanding-the-connection-between-race-and-iq/275876/) and [college](https://www.thecrimson.com/article/2018/6/21/holistic-admissions-origin/) [admissions](https://www.theroot.com/the-merit-myth-the-white-lies-about-race-conscious-col-1828231903). (That last linked article is valuable to read throughout, but point #2 is most relevant to this post.)

But wait a minute -- can you seriously infer my race from my groceries? Come on, I just bought gochujang last week; that doesn't mean I'm Korean-American.

#### How well could you predict someone's race, class, or pre-existing conditions based on their grocery receipts?

##### Race

You could predict race conclusively better than random by following simple tendencies observed in market research. [According to Nielsen](https://www.nielsen.com/us/en/insights/news/2016/fresh-foods-and-flavors-how-multicultural-consumers-are-driving-fresh-grocery-trends.html), Black people buy more meat and Asian people buy more seafood. (The label "Asian" is too imprecise for rigorous public health research, but it suffices here for proof of principle.) 

Nobody will be surprised at aggregate differences across populations. It's more interesting to know exactly how accurate predictions are on a person-to-person level. [This article by Weijun Li & coauthors](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5726305/) (full citation below) might help us ballpark it: they thoroughly study grocery shopping behavior in small samples of older Black and White women in the D.C. area.

> Li, W., Youssef, G., Procter-Gray, E., Olendzki, B., Cornish, T., Hayes, R., ... & Magee, M. F. (2017). Racial differences in eating patterns and food purchasing behaviors among urban older women. *The journal of nutrition, health & aging*, *21*(10), 1190-1199.

The paper includes an overall Average Healthy Eating Index, for which the higher-scoring group (p < 0.001) was ... take a guess and click [this link](https://en.wikipedia.org/wiki/White_people) to find out. Li & coauthors report group means of 44 and 34 points with standard deviations of 10.5. If the scores were perfectly Normally distributed, it would give an overlap that looks like this.

![](C:\Users\Eric Kernfeld\Dropbox\blog posts\drafts\AHEI overlap.png)

![](/Users/erickernfeld/Dropbox/blog posts/drafts/ml_bias/AHEI overlap.png)


In Washington D.C., where Li & coauthors' study recruited, Black and White populations each make up roughly 45% of the city, so it's fair to put the same area under the curves. Dropping a decision boundary at 39 gives a race classifier with about 68% accuracy. This involved unrealistic assumptions, which could bias the estimate in either direction. Also, it's unclear how statistical trends will change when expanded from ~100 older women in DC to national-level or regional-level "wellness vendors". But, [a review of >100 studies](http://thefoodtrust.org/uploads/media_items/grocerygap.original.pdf) finds systematic disparities. From the executive summary:

> Accessing healthy food is a challenge for many Americans—particularly those living in low-income neighborhoods, communities of color, and rural areas.

And remember, we are talking about a healthy eating score that was constructed by well-intentioned health science professionals. We obtain 68% accuracy in predicting shoppers' races *purely as a byproduct*. That means it is virtually impossible to construct a grocery-based wellness rewards program that is free of racial bias. 

##### Social class 

Another major category that wellness companies could use to stratify prices is **social class**. Differences in grocery tendencies are almost painful to list: is your customer buying filet mignon and caviar, or beans, rice, and Kraft dinners? I am not yet able to find or produce a ballpark for "How well can groceries predict class?", but you can read more about this topic [here](https://poseidon01.ssrn.com/delivery.php?ID=855089082102113076099096090084103113102082065014007039108084065002094112076005093111050117107034029039046029083028124112004103039086075069039066002116096020082104119020043021064084071082116031123031005000076117115087118122082079105086068111114105023031&EXT=pdf).

> Handbury, J., Rahkovsky, I. M., & Schnell, M. (2015). What drives 
> nutritional disparities? Retail access and food purchases across the
> socioeconomic spectrum.

##### Pre-existing conditions

Groceries could also be used to detect pre-existing conditions. For example, Brown University economist Emily Oster recently used grocery purchases to [infer/predict diagnosis of diabetes](https://pdfs.semanticscholar.org/b4bd/08df4c29d14ff237966f46b1bf2fdec6bed9.pdf). She started with only directly relevant items (such as glucose testing products), but adding information from regular groceries substantially improved the false discovery rate (from 68% to 40%). As a side note, Oster didn't just classify who had diabetes; she faced the more difficult task of establishing the exact timing of diagnosis. If you are interested in the details, the paper is very readable.

> Oster, E. (2018). Diabetes and diet: purchasing behavior change in response to health information. *American Economic Journal: Applied Economics*, *10*(4), 308-48.

Even without going through all of the details, this finding is enough to show that on principle, grocery purchases can be used to discriminate based on pre-existing conditions. 

Other pre-existing conditions include AIDS, pregnancy, obesity, alcoholism, and kidney failure. How well could these be predicted based on groceries? I would rather not have to figure it out, but companies are already finding indirect ways around ACA protections, for example by putting AIDS drugs on tiers with high copays. [Source: is obamacare living up-to its preexisting conditions promise?](http://www.sophienovack.com/blog-is-obamacare-living-up-to-its-preexisting-conditions-promise/) If they want to take this opportunity, what is stopping them? 

(It's a rhetorical question, but if you actually have an answer, please get in touch!)

#### On fairness through unawareness

Some people would object to this whole post, saying that healthy eating scores are fair as long as they properly reflect causal impact of diet on health. Why bring in complicated considerations about race, class, and pre-existing conditions when we could be having a simple discussion about rewarding people who make healthy choices of what to eat? There are several reasons. 

First, discrimination by pre-existing conditions is illegal, whether it's done explicitly, covertly, or even accidentally. 

Second, there is only one proper quantitative expression of fairness, and it implies that we need to avoid pricing health insurance based on diet. I am talking about Kusner et al's [counterfactual fairness criterion](https://arxiv.org/pdf/1703.06856.pdf). To understand what it says, imagine you could alter someone's race. You then allow the changes to propagate through any aspect of their life influenced by race; this includes dietary preferences. (Kusner et al would probably included not just your race but also your entire family's cultural background; see "ancestral closure of protected attributes" on page 5 of the paper.) To meet the criterion of counterfactual fairness, your predictions should not change after all effects of the racial alteration have been propagated. Although Kusner et al clarify that it is not mathematically necessary to avoid variables causally downstream of protected attributes -- e.g. diet affected by race -- I claim that doing so is the only feasible way to meet their criterion in practice, and the paper itself says as much (see their Lemma 1).


Suppose we disregard the counterfactual fairness criterion and the risk of targeting pre-existing conditions. Health research is still not mature enough yet to properly design a fair wellness rewards program, and it will not be for the foreseeable future. In particular, a) causal effects in nutrition research are *notoriously* difficult to parse out, and b) research is a social phenomenon affected by the deeply engrained legacy of a society that has been explicitly racist for most of its history. Let's take an [example](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3898713/) of a large, geographically widespread, multi-racial study:

> Judd, S. E., Gutiérrez, O. M., Newby, P. K., Howard, G., Howard, V. J.,
> Locher, J. L., ... & Shikany, J. M. (2013). Dietary patterns are associated
> with incident stroke and contribute to excess risk of stroke in black 
> Americans. Stroke, 44(12), 3305-3311.

This is a careful and impressive piece of work. It does a great job at its stated purpose. But designing a wellness rewards program is an order of magnitude more difficult than designing a single respectable study. Why? 

-  This study does not explain 100% of the association between race and stroke. 
- It does not provide definitive proof of that Southern diets cause strokes. I personally find it convincing, but the methods used cannot eliminate residual confounding and unobserved confounding. It's not proof. 
- It prioritizes diet-associated disease in Black Americans, leaving other important questions unanswered or possibly even answered backwards. The first sentence of the paper: "Black Americans and residents of the Southeastern United States are at increased risk of stroke." That's why the study was done. But ignoring other heatlh outcomes can lead to strange findings: the Sweets/Fats pattern, more common in White American, correlated with a *reduction* in stroke risk. The authors did not expect this, and their best explanation is that eating Sweets/Fats "protects" people against strokes by killing them with cancer or heart disease. Any wellness rewards program that accounts for the stroke risk estimates in this study will take the study's well-meaning focus on a disadvantaged group and flip it around to impose higher health insurance prices on that same group, while essentially ignoring unhealthy choices made by the dominant group.


#### Summary

If we are going to charge some people more for health insurance, we have a moral and legal responsibility to ensure we are not penalizing them based on race, class, and pre-existing conditions. Market research indicates that simple rules of thumb based on purchases of branded and unbranded produce, meat, and seafood could reveal information about race, and health studies find that even carefully designed healthy eating scores stratify people by race. Emily Oster showed that grocery bills could be used -- not perfectly, but much better than random -- to ferret out people with a pre-existing condition (diabetes). Social class is similarly vulnerable. For complex predictors based on grocery purchases, avoiding discrimination is impossible in practice.

Even if well-meaning programs focus on causal effects of diet, "fairness through unawareness" is not enough to avoid unacceptable bias, for many reasons. On the principled side, people should not be penalized for cultural preferences, even those with a genuine causal effect on health. On the practical side, diet is too difficult to disentagle from other determinants of health, and the legacy of racism is baked into well-meaning health research, shaping whose diet and what health outcomes are scrutinized. 

At the very least, wellness rewards programs should make datasets, methods, and principles transparent. They should make their case to consumers for why their practices are fair. Ideally, health insurers should abandon grocery-based wellness rewards. The Houston incident shows that organized action from consumers also has the power to influence this space, especially through labor unions, which are strong enough to negotiate with large employers about institutional decisions on health benefits. Houston's government switched to a separate program, and the KHN article cites objections from the police union and other city employees as key to this decision.