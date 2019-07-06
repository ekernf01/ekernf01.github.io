---
layout: post
title: Eric's short(er) course on complex numbers 
math: true
---

My dad's friend Felicity, at age seventy something (?), is beginning her career again. She has a musicology PhD (done in the 70's, on Art Tatum), and she worked as an administrator for a big-time conglomerate for many years. She's now studying psychology and music at a public university in New York City, alongside people from all over the world -- often immigrant women with full-time jobs and kids, "busting their asses" with a five-course load (her words) to get ahead in their careers. 

En route to her new path in music therapy, Felicity wants to learn about signal processing for EKG data. She picked up a book on it, and I took a peek to help figure out what sort of math she needs to learn in order to dig into that book. A few pages in, I ran into a formula like this.

$$S(t) = Ae^{\omega i\pi (t + \tau)}$$

This is basically like a sine wave -- it's a periodic signal with a frequency of $\omega$, a phase offset of $\tau$, and an amplitude of $A$. How do I know all that, and what exactly does it mean? Thus begins Felicity's journey into complex and imaginary numbers.

#### Hey! You can't do that!

The imaginary unit is defined as the square root of negative one. This has upset a lot of people and it continues to do so, but it is generally regarded as a good idea, at least among experts. 

Usually the symbol $i$ or $j$ is used for it, so the definition says $i^2 = i\times i = -1$. The chief complaint among newcomers: there is no number that fits this criterion. It is impossible to satisfy $i \times i = -1$, no matter what you plug in as $i$. Among familiar numbers, $-1$ itself seems like the most plausible candidate, and yet $-1 \times -1$ is (positive) $1$, not $-1$. 

This complaint is entirely valid. The work-around is to propose an entirely new class of entities. They are not regular numbers, but they behave just like regular numbers, with (surprisingly) no resulting inconsistencies. They have proven their utility many times over in mathematics and engineering. 

A certain open-mindedness is required for this, but it has plenty of precedent. Originally, we had only the counting numbers: 1, 2, 3, and so on. There was no number $z$ such that $3 + z = 3$. Now, we have $0$: a new entity that did not exist among the counting numbers, but follows the same rules. Some new decisions needed to be made about multiplication and division, and dividing by $0$ continues to upset people sometimes, but all in all $0$ has been an extraordinarily valuable addition to the community. Negative numbers provide another example: if $n + 9 = 7$, what is $n$? Math teachers tell me their students sometimes object: that's impossible! You can't add something to 9 and have it decrease! But if you are open to a new collection of entities, an evil twin for each number, the universe will not implode, and your accounting skills will be much improved.

This is the essense of algebra: defining a mathematical entity based purely on its behavior. It is a very strange idea, but if you continue to study the behavior of your new entity, you will become familiar with it, and it will feel more like learning a new word from context rather than learning it from the dictionary. Let us begin to get acquainted with our strange new friend $i$.

#### How does $i$ behave? (How do $i$ behave?)

At first, I refer people to [Dave's Short Course on Complex Numbers](https://www2.clarku.edu/faculty/djoyce/complex/), the namesake of this post. That's a great place to learn about complex numbers. But, I realized it wasn't as short or accessible as I remembered. You already need to be comfortable looking at polynomials to read that from the start. 

Fortunately, you don't need much algebra to learn about $i$. Mostly, you need to be curious and ask questions. So far, the only things we know about $i$ are: 

1. $i \times i = i^2 = -1$
2. $i$ interacts with all real numbers following all the usual rules. (Real numbers are the usual ones like -5, 0, 1, $\pi$, $9 \frac{3}{4}$, 42, and 66.66666667.)

This leave a lot of important questions unanswered. 

- Zero showed up alone, but $-1$ showed up with an infinite family of negative numbers. So is $i$ traveling alone, or has it brought a family? 
- We know what $i^2$ is, but what about $i^3$ or $i^4$? Can we use algebra to manipulate these into anything new, or anything familiar?
- What about $1 + i$ or $10 \times i$ -- do those somehow simplify? 

Let's start with $i^4$. This is a quick one; in fact: 

$$i^4 = i \times i \times i \times i = (i \times i) \times (i \times i) = -1 \times -1 = 1$$. This is enormously significant, so we'll return to it later; for now, notice how it came out of a familiar rule: "Multiplication can be done in any order."

What about $i^3$? By the same logic, it seems to be 

$$ i \times i \times i = (i \times i) \times i = -1 \times i = -i$$.

This $-i$ may be another new entity, and it leads to a new set of questions.

- Can we confirm that $-i$ behaves as expected for a negative number? Is $i + (-i)$ actually 0? We know that $(-2)^2 = 2^2 = 4$, so is it also true that $(-i)^2 = i^2 = -1$?
- Is $-i$ equal to $i$, or equal to some regular (real) number, or neither? 
- What is $(-i)^2$? 

For the first point, both are true. We can verify $-i + i = 0$ by using the *distributive property*, which says $ac + bc = (a+b)c$, and by using the rule that $0 \times n = 0$ for any number $n$ (real or imaginary). The steps are:

$$i + -i = (1 \times i) + (-1 \times i) = (1 + -1) \times i = 0 \times i = 0$$.

We can also exchange the order of multiplication to show $-i \times -i = -1 \times -1 \times i \times i = 1 \times -1$

This also answers our family question. Like $-1$, and unlike $0$, $i$ has showed up with an infinitely big family, which includes members like $2i$ and $-i$. It also includes members like $7 + 4i$ or $5 - 6i$, which are part real and part imaginary. I won't prove this, but the easiest way to represent these is just as I have done: $7 + 4i$. You put one number for the real part, another for the imaginary part, and treat them as if they have been added together. Usually, this is the minimum information required to specify a complex number, and they can't be boiled down into any more compact form.

#### Complex numbers, periodic signals, and a smidge of geometry for the glue

So far, we have bridged about $0 \times i$ percent of the gap between the Weird World of Complex Algebra and Felicity's brain waves. To rectify this, let us return to the remarkable fact $i^4 = 1$. This fact is remarkable because of what happens upon repeated multiplication: every four times, you cycle back to the same value.

Power representation | intermediate computation | minimal result
---|---|---
$i^4$ | $i^2 \times i^2$  |  -1 * -1     | 1
$i^5$ | i * 1   | i * 1 | i
$i^6$ | i^2 * 1 | i^2 * 1 | -1
$i^7$ | i^3 * 1 | -i
$i^8$ | i^4 * 1 | 1 
$i^9$ | i^5 * 1 | i
$i^n$ | remainder of n when dividing by 4 | i, -1, -i, or 1 



