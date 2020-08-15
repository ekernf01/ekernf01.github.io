---
layout: post
title: Favorite machine learning papers: phonetic evolution
math: true

---

My other favorite machine learning paper [reconstructs common ancestors of human languages using a phonetic language evolution model](https://www.pnas.org/content/110/11/4224). The abstract speaks for itself:

> One of the oldest problems in linguistics is reconstructing the words that appeared in the protolanguages from which modern languages evolved. Identifying the forms of these ancient languages makes it possible to evaluate proposals about the nature of language change and to draw inferences about human history. Protolanguages are typically reconstructed using a painstaking manual process known as the comparative method. We present a family of probabilistic models of sound change as well as algorithms for performing inference in these models. The resulting system automatically and accurately reconstructs protolanguages from modern languages. We apply this system to 637 Austronesian languages, providing an accurate, large-scale automatic reconstruction of a set of protolanguages. Over 85% of the system’s reconstructions are within one character of the manual reconstruction provided by a linguist specializing in Austronesian languages. Being able to automatically reconstruct large numbers of languages provides a useful way to quantitatively explore hypotheses about the factors determining which sounds in a language are likely to change over time. We demonstrate this by showing that the reconstructed Austronesian protolanguages provide compelling support for a hypothesis about the relationship between the function of a sound and its probability of changing that was first proposed in 1955.

Accurate automated reconstruction of extinct languages! Automated construction of linguistic family trees! I'm amazed. Let's break this down with an example to see what type of reasoning the algorithm does.

#### Example: evolution of "to speak" from Latin to modern languages

The Latin word for "to speak" is *fabulare*. Here are its descendants in several modern languages.

- fabulare (Latin, pronounced faa-boo-lah-ray)
- parler (French)
- parlar (Occitan, Catalan)
- parlare (Italian)
- falar (Portuguese)
- hablar (Spanish)
- fable, fabulous, confabulate (related English words)

We know about *fabulare* because there is lots of surviving written and spoken Latin, for example in the Catholic Church. But how might an algorithm try to recover *fabulare* from its modern descendants? 

Let's look at Spanish first: hablar, pronounced ah-blar with a silent h. 

- The basic structure of the word is there: b, l, and r in the correct order. 
- The a's are correct, but the u and the e are missing. 
- The f is also missing, having turned into a silent h. 

Some of the missing pieces are probably not recoverable, but the f-to-silent-h transition is actually very common in Spanish. It is certainly recognized by linguists and it could potentially be rediscovered by a computer program. Here some examples.

- "ferrous", "ferric", and "ferro" are English words and prefixes related to iron, commonly used in science. In Spanish, "iron" and "hardware store" are "hierro" (yairo) and "herreteria" (air a tare ee uh). 
- The surname "hernandez" used to be "fernandez".
- "Facere" (Latin) means "to make" ("factory" is an English cognate). In Spanish, it became "hacer" (ah sair).

#### Example: can the algorithm uncover the lost "F"?

This example brings up some questions about the specifics of the method.

- How does their method represent a language? 
- Does the algorithm know to pair up cognates like "fable" and "hablar", or does it have to guess?
- How would it represent the loss of an "F" over time? 
- Can it take information learned from pairs of cognates (ferro/hierro, factory/hacer) and apply it to a new situation (fabulare/hablar)?
- Does the algorithm use the plain spelling of each word (fought), or a phonetic spelling (fot)?

The methods section begins to address our questions with a hilariously technical opening sentence.

> The conditional distributions over pairs of evolving strings are specified using a lexicalized stochastic string transducer.

Let's expand this into the paragraph that it should be. A "string" in computer science is short for a "character string", also known as a word. A "string transducer" is a process that takes a word and mutates it by adding, removing, or changing a letter. "Lexicalized" means they took a tool from biology and adapted it to apply to human language. "Stochastic" means the model has randomness. So they seem to model languages as collections of words, and languages are compared by looking at pairs of related words. each word evolves randomly by gaining, losing, or altering sounds in a way that is similar to the evolution of a gene in biology.

They continue to confirm and expand on aspects of the model.

> Consider a language $l$ evolving to $l'$  for cognate set $C$. Assume we have a word form $x=w_{cl}$ . The generative process for producing $y=w_{cl'}$ works as follows. First, we consider *x* to be composed of characters  $x_1x_2...x_n$. The process generates $y_1y_2...y_n$ in *n* chunks, one for each $x_i$. The $y$'s may be a single character, multiple characters, or even empty.

This answers our second question: the method cannot pair up cognates on it own. It requires a set of cognates $C$ as input. The following text describes a random process for 





##### Footnotes

- I love that they model words as sequences of sounds rather than sequences of letters. This seems hard, and it allows realistic evolution of words, e.g. by dropping syllables ("alright" becomes "aight") or changing to nearby sounds (British-style "little" becomes American-style "liddle"). It also allows them to quantitatively test the "functional load hypothesis", which they explain as "sounds that play a more important role in distinguishing words are less likely to change over time."
- I enjoy outrageous jargon for its own sake, so I relished their mention of "lenitions, epentheses, and elisions" as sound transformations that their model could accomodate. Lenition is weakening of a consonant, as in "little Wayne ==> liddle Wayne". Elision is full-on removal of a sound: "liddle Wayne ==> Li'l Wayne"; "Ca est la vie ==> C'est la vie". Epentheses is the plural of "epenthesis", which means inserting an extra sound. For example, Hampshire [didn't always have a 'p'](https://en.wikipedia.org/wiki/Hampshire#Name), and my friend John says his name is pronounced "joo-AWN". 
- More delightful jargon: "Most types of changes not captured by transducers are not regular and are therefore less informative (e.g., metatheses, reduplications, and haplologies)." This list definitely sounds as if it were made up by linguists, which I suppose it was. 