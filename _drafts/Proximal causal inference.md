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

### Proximal causal inference questions

Trying to read [this](https://academic.oup.com/aje/article/192/7/1224/7098281) and the HIV example in Figure 1 raises many questions.

- When is each of these variables defined?
- Why would age affect measured CD4+ count *conditional on the true count*? This does not make sense to me; how is the measurement done?
- Why would measured CD4+ count affect viral load *even conditional on the true count*? Do people take their medication more faithfully if their doctor says their immune system is on the ropes?
- Why does viral load not affect CD4+ count or self-rated health? Isn't that ... the reason we care about HIV?
- Why can't treatment assignment affect self-rated health?
- 