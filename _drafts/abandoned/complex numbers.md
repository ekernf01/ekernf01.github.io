---
layout: post
title: Eric's short(er) course on complex numbers 
math: true
---

My dad's friend Felicity, at age seventy something (?), is beginning her career again. She has a musicology PhD (done in the 70's, on jazz pianist Art Tatum), and she worked as an administrator for a big-time conglomerate for many years. She's now studying psychology and music at a public university in New York City, alongside people from all over the world -- often immigrant women with full-time jobs and kids, "busting their asses" with a five-course load (her words) to get ahead in their careers. 

En route to her new path in music therapy, Felicity wants to learn about signal processing for EKG data. She picked up a book on it, and I took a peek to help figure out what sort of math she needs to learn in order to dig into that book. A few pages in, I ran into a formula like this and thought, uh-oh.

$$S(t) = Ae^{\omega i\pi (t + \tau)}$$

This is basically like a sine wave -- it's a periodic signal with a frequency of $\omega$, a start time of $\tau$, and an amplitude (strength) of $A$. The output $S$ is the pressure (if sound) or the voltage (if electricity) when the signal is measured, and the input $t$ is the time of measurement. How is Felicity supposed to know that, and what exactly does it mean? Thus begins Felicity's journey into complex and imaginary numbers.

#### Hey! You can't do that!

The imaginary unit is defined as the square root of negative one. This has upset a lot of people and it continues to do so, but it is generally regarded as a good idea, at least among experts. 

Usually the symbol $i$ or $j$ is used for it, so the definition says $i^2 = i\times i = -1$. The chief complaint among newcomers: there is no number that fits this criterion. It is impossible to satisfy $i \times i = -1$, no matter what you plug in as $i$. Among familiar numbers, $-1$ itself seems like the most plausible candidate, and yet $-1 \times -1$ is (positive) $1$, not $-1$. So what do you think you're doing?

This complaint is entirely valid. The work-around is to propose an entirely new class of entities. They are not regular numbers, but they behave just like regular numbers, except for the above property. If this is taken as a given, there are, perhaps surprisingly, no resulting inconsistencies. Furthermore, imaginary numbers have proven their utility many times over in mathematics and engineering. 

A certain open-mindedness is required for this, but it has plenty of precedent. Originally, we had only the counting numbers: 1, 2, 3, and so on. There was no number $z$ such that $3 + z = 3$. Now, we have $0$: a new entity that did not exist among the counting numbers, but follows the same rules. Some new decisions needed to be made about multiplication and division, and dividing by $0$ continues to upset people sometimes, but all in all $0$ has been an extraordinarily valuable addition to the community, despite adding literally nothing. Negative numbers provide another example: if $n + 9 = 7$, what is $n$? Math teachers tell me their students sometimes object: that's impossible! You can't add something to 9 and have it decrease! But if you are open to a new collection of entities, an evil twin for each number, the universe will not implode, and your accounting skills will be much improved. Imaginary numbers work the same way.

In fact, this is the main insight of algebra: studying mathematical entities based purely on their relationships, not their particular values or form. This is a very strange idea, but if you continue to study the behavior of your new entity, you will become familiar with it, and it will feel more like learning a new word from context rather than learning it from the dictionary. Let us begin to get acquainted with our strange new friend $i$.

#### How does $i$ behave? (How do $i$ behave?)

At first, I refer people to [Dave's Short Course on Complex Numbers](https://www2.clarku.edu/faculty/djoyce/complex/), the namesake of this post. That's a great place to learn about complex numbers. But, I realized it wasn't as short or accessible as I remembered. You already need to be comfortable looking at polynomials to read that from the start. 

Fortunately, you don't need much algebra to learn about $i$ here. Mostly, you need to be curious and ask questions. So far, the only things we know about $i$ are: 

1. $i \times i = i^2 = -1$
2. $i$ interacts with all real numbers following all the usual rules. (Real numbers are the usual ones like -5, 0, 1, $\pi$, $9 \frac{3}{4}$, 42, and 66.66666667.)

This leave a lot of important questions unanswered. 

- Zero showed up alone, but $-1$ showed up with an infinite family of negative numbers. So is $i$ traveling alone, or has it brought a family? 
- We know what $i^2$ is, but what about $i^3$ or $i^4$? Can we use algebra to manipulate these into anything new, or anything familiar?
- What about $1 + i$ or $10 \times i$ -- do those somehow simplify? 



Let's start with $i^4$. This is a quick one; in fact: 

$$i^4 = i \times i \times i \times i = (i \times i) \times (i \times i) = -1 \times -1 = 1$$. This is enormously significant, so we'll return to it later; for now, notice how it came out of a familiar rule: "Multiplication can be done in any order." I simply placed parentheses and followed the rule that $i\times i=-1$; look again if you doubt me.

What about $i^3$? By the same logic, it seems to be 

$$ i \times i \times i = (i \times i) \times i = -1 \times i = -i$$.

This $-i$ may be another new entity, and it leads to a new set of questions.

- Can we confirm that $-i$ behaves as expected for a negative number? In other words, is $i + (-i)$ actually 0? We know that $(-2)^2 = 2^2 = 4$, so is it also true that $(-i)^2 = i^2 = -1$?
- Is $-i$ equal to $i$, or equal to some regular (real) number, or neither? 
- What is $(-i)^2$? With a good supply of parentheses, we should be able to eventually compute this.

For the first point, both are true. We can verify $-i + i = 0$ by using the *distributive property*, which says $ac + bc = (a+b)c$, and by using the rule that $0 \times n = 0$ for any number $n$ (real or imaginary). The steps are:

$$i + -i = (1 \times i) + (-1 \times i) = (1 + -1) \times i = 0 \times i = 0$$.

We can also exchange the order of multiplication to show $$-i \times -i = -1 \times -1 \times i \times i = 1 \times -1 = -1$$.

This also answers our family question. Like $-1$, and unlike $0$, $i$ has showed up with a family, which includes other members $-i$. In fact, this family is infinitely big, and it also includes members like $7 + 4i$ or $5 - 6i$, which are part real and part imaginary. I won't prove this, but the easiest way to represent them is just as I have done: $7 + 4i$. You put one number for the real part, another for the imaginary part, and carry them around together. Usually, this is the minimum information required to specify a complex number, and they can't be boiled down into any more compact form.

#### Complex numbers, periodic signals, and a smidge of geometry for the glue

So far, we have bridged about $0 \times i$ percent of the gap between the Weird World of Complex Algebra and Felicity's brain waves. To rectify this, let us return to the remarkable fact $i^4 = 1$. This fact is remarkable because of what happens upon repeated multiplication: every four times, you cycle back to the same value. It's periodic! Like a wave! It's periodic! Like a wave! It's periodic! Like a wave! It's periodic! Like a wave!

Power of  $i$ | Intermediate steps | Result 
---|---|---
$i^4$ | $i^2 \times i^2 = -1 * -1$ |  1    
$i^5$ | $i * i^4 = i*1$ | i 
$i^6$ | $i^2 * 1 = -1*1$ | -1 
$i^7$ | $i^3 * 1 = i * -1 * 1$ | -i
$i^8$ | $i^4 * 1 = 1*1$ | 1 
$i^9$ | $i * i^4 * i^4 =i * 1 * 1$ | i
$i^n$ | remainder of n when dividing by 4 | i, -1, -i, or 1 

I am unfortunately not able to continue all the way to the formula $$S(t) = Ae^{\omega i\pi (t + \tau)}$$ that I teased you with and explain why it produces a wavelike output. Please trust me to omit and summarize some details. First, the full proof would require extracting and graphing some bells and whistles which are important for customization of the resulting wave (tuning the frequency, for instance), but which obscure the essence. 

Second, that process would leave behind $e^{it}$. These -- $e, i, t$ -- are just numbers, and they follow the usual rule that $a^{bc} = (a^b)^c$. So, we can write the expression as $(e^i)^t$. This base is a complex number $e^i$, which I cannot give an exact value for, and the exponent $t$  is a plain old real number -- $t$ is just the time of measurement. To determine exactly what that complex number is in the base of the expression, you would need one piece of rather fancy machinery (called a Taylor Series). To avoid bothering with that, I'll just tell you what the whole thing comes out to. If you pick just the right value of $t$ to start with -- let's call it $t_0$ -- then you can set it up so that $e^{it_0}=i$. That's right: it comes out to the imaginary unit that kicked off our discussion.

Increasing $t$ through $2*t_0$, $3*t_0$, and so on then exactly corresponds to the above table, row by row. To offer the reader a chance to prove their understanding, I will end on a cliffhanger: what is $(e^{it_0})^{2}$ if $e^{it_0}=i$? If you can answer that and connect it to the table, then you have understood the relationship between complex exponents and periodic behavior.

P.S. Fun fact: the correct value of $t_0$ is $\pi/2$, where $\pi$ is the geometrical constant, the ratio between diameter and circumference. It's funny how $\pi/2$ measures out a quarter circle in radians, and it takes the fourth power of $i$ to yield $1$. What a coincidence!