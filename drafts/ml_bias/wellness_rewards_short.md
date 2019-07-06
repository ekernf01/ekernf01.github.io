## Data-heavy "wellness rewards" programs allow covert discrimination based on pre-existing conditions, race, and social class


Kaiser Health News recently put out an [article](https://khn.org/news/workplace-wellness-programs-put-employee-privacy-at-risk/) about wellness rewards programs that ask for information on disease history, seat belt use, and groceries. The article focuses on privacy risks, which is laudable, but there is an absolutely crucial issue that they don't mention:

*It is impossible to implement grocery-based wellness rewards programs without implicit discrimination, even assuming companies act in good faith.*

I will discuss the potential for bias based on class and pre-existing conditions, but I mostly focus on race. Before we get into the details, remember that racial discrimination has arisen time and again through supposedly neutral decision criteria. You may not agree with every single claim people make on this controversial topic, but examples abound, ranging from [redlining](https://www.washingtonpost.com/news/wonk/wp/2018/03/28/redlining-was-banned-50-years-ago-its-still-hurting-minorities-today/?noredirect=on&utm_term=.550f150737bc), [predictive policing](https://www.propublica.org/article/machine-bias-risk-assessments-in-criminal-sentencing), and [drug policy](https://www.vocativ.com/underworld/drugs/crack-vs-coke-sentencing/index.html) to [IQ tests](https://www.theatlantic.com/national/archive/2013/05/why-people-keep-misunderstanding-the-connection-between-race-and-iq/275876/) and [college](https://www.thecrimson.com/article/2018/6/21/holistic-admissions-origin/) [admissions](https://www.theroot.com/the-merit-myth-the-white-lies-about-race-conscious-col-1828231903). 

Furthermore, grocery purchases offer incredibly detailed information. You can infer race, class, and even pre-existing conditions from someone's groceries -- not perfectly, but much better than chance. Because of this, even so-called "fairness through unawareness" -- training models based on groceries and health outcomes with no knowledge of race, class, or pre-existing conditions -- will result in penalties to disadvantaged people.

##### Grocery purchases correlate with race and class 

It is common sense that grocery purchases reflect social class. The specifics are almost painful to list: is your customer buying filet mignon and caviar, or beans, rice, and Kraft dinners? And [according to market research by Nielsen](https://www.nielsen.com/us/en/insights/news/2016/fresh-foods-and-flavors-how-multicultural-consumers-are-driving-fresh-grocery-trends.html), simple rules of thumb based on purchases of branded and unbranded produce, meat, and seafood could reveal information about race. 

More relevant to my point here is that healthy eating scores produced by well-meaning health researchers, with no intent to discriminate, still find strong systematic disparities by race:

> Li, W., Youssef, G., Procter-Gray, E., Olendzki, B., Cornish, T., Hayes, R., ... & Magee, M. F. (2017). Racial differences in eating patterns and food purchasing behaviors among urban older women. *The journal of nutrition, health & aging*, *21*(10), 1190-1199.

For those wanting more systematic evidence, a [review](http://thefoodtrust.org/uploads/media_items/grocerygap.original.pdf) of more than 100 nutrition studies explains:

> Accessing healthy food is a challenge for many Americans—particularly those living in low-income neighborhoods, communities of color, and rural areas.

Any honest attempt at grocery-based wellness rewards has a moral and legal responsibility to address these issues. Below, I make the case that this is impossible in theory given the state of the art about how to define "fairness" for a predictive algorithm, and impossible in practice given our incomplete understanding of human health and human history.

##### Grocery purchases also correlate with pre-existing conditions

Many readers will not be surprised that, in aggregate, dietary preferences and healthy eating indices differ by race and class. More surprising is that groceries can be used to detect pre-existing conditions on an individual level. For example, Brown University economist Emily Oster recently used grocery purchases to [infer diagnosis of diabetes](https://pdfs.semanticscholar.org/b4bd/08df4c29d14ff237966f46b1bf2fdec6bed9.pdf) for a study unrelated to wellness rewards. She started with only directly relevant items (such as glucose testing products), but found that adding information from regular groceries substantially improved the false discovery rate (from 68% to 40%). This finding shows that in principle, routine grocery purchases may contain substantial individual-level information on pre-existing conditions. 

Other pre-existing conditions include AIDS, pregnancy, obesity, alcoholism, and kidney failure. How well could these be predicted based on groceries? Companies are already finding indirect ways around ACA protections, for example by putting AIDS drugs on tiers with high copays. [Source: is obamacare living up to its preexisting conditions promise?](http://www.sophienovack.com/blog-is-obamacare-living-up-to-its-preexisting-conditions-promise/) If they want to take wellness rewards as another opportunity, what is stopping them? 

#### On fairness through unawareness

Some people would object to this whole argument, saying that healthy eating scores are fair as long as they properly reflect biological impact of diet on health. Why bring in complicated considerations about race, class, and pre-existing conditions when we could be having a simple discussion about rewarding people who make healthy choices of what to eat? There are several reasons. 

First, causal effects in nutrition research are *notoriously* difficult to parse out. They often remain buried in complicated geographic and social trends.

Second, discrimination by pre-existing conditions is illegal, whether it's done explicitly, covertly, or by accident. 

Third, try to enter a room with a Black consumer and a White consumer and explain why it's fair that the foods one of them grew up eating will now cost her extra in health insurance. If they object, their intuition matches [carefully reasoned principles of fairness in machine learning](https://arxiv.org/abs/1703.06856). To be fair according to this work, predictions must not be affected by changing someone's racial background, including their own race and that of their entire family. Assessing whether their food preferences depend on race would require a massive family history project full of impossible counterfactuals. Would your great-grandmother have borrowed that cookbook from her neighbor if she were White? Would she have even lived in that same neighborhood? Gone to that same market? Given the massive uncertainties involved, the only feasible fair practice is to avoid using groceries for wellness rewards.

Fourth, health research -- even completely reasonable and well-meaning health research -- is affected by our perceptions about race. For example, consider the uncontroversial idea that some populations are less healthy in some ways. This idea affects the following [example](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3898713/), which is a large, geographically widespread, multi-racial study of the associations between race, geography, Southern-style diet, and stroke risk.

> Judd, S. E., Gutiérrez, O. M., Newby, P. K., Howard, G., Howard, V. J.,
> Locher, J. L., ... & Shikany, J. M. (2013). Dietary patterns are associated
> with incident stroke and contribute to excess risk of stroke in black 
> Americans. Stroke, 44(12), 3305-3311.

This is a careful and impressive piece of work. It does a great job at its stated purpose. But, it prioritizes diet-associated disease in Black Americans, leaving other important questions unanswered. The first sentence of the paper: "Black Americans and residents of the Southeastern United States are at increased risk of stroke." That's why the study was done. But ignoring other heatlh outcomes can lead to strange findings: the Sweets/Fats pattern, more common in White Americans, correlated with a *reduction* in stroke risk. The authors did not expect this, and their best explanation is that eating Sweets/Fats "protects" people against strokes only by killing them with cancer or heart disease before a stroke can take place. Any wellness rewards program that accounts for this study will take their well-meaning focus on Black Americans' stroke risk and flip it around to impose higher health insurance prices, while essentially ignoring unhealthy choices made by White Americans. Again, the problem is not the study. Our understanding of nutrition and health is incomplete, and it's incomplete in ways affected by race. Under these circumstances, designing a fair wellness rewards program is not feasible. 

#### Summary

If we are going to charge some people more for health insurance, we have a moral and legal responsibility to ensure we are not penalizing them based on race, class, and pre-existing conditions. This is impossible: grocery purchases are wound up in our lives much too tightly for it to work. Market research indicates that simple rules of thumb based on purchases of branded and unbranded produce, meat, and seafood could reveal information about race, and health studies find that even carefully designed healthy eating scores stratify people by race. Emily Oster showed that grocery bills could be used -- not perfectly, but much better than random -- to ferret out people with a pre-existing condition (diabetes). Social class is similarly vulnerable. For complex predictors based on grocery purchases, avoiding discrimination is impossible in practice.

Even if well-meaning programs focus on causal effects of diet, "fairness through unawareness" is not enough to avoid unacceptable bias, for many reasons. On the principled side, people should not be penalized for cultural preferences, even those with a genuine causal effect on health. On the practical side, diet is too difficult to disentagle from other determinants of health, and the legacy of racism is baked into well-meaning health research, shaping whose diet and what health outcomes are scrutinized. 

#### Call to action

At the very least, wellness rewards programs should make datasets, methods, and principles transparent. They should engage with these issues and make the case to consumers for why their practices are fair. But ideally, health insurers should abandon grocery-based wellness rewards. 

The Houston incident relayed by Kaiser Health News shows that organized action from consumers also has the power to influence this space, especially through labor unions, which are strong enough to negotiate with large employers about institutional decisions on health benefits. Houston's government switched to a separate program, and the KHN article cites objections from the police union and other city employees as key to this decision.