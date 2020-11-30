---
layout: post
title: Lazy matrix evaluation saves RAM in common analyses 
math: true
tags: software single_cell stat_ml
---

`MatrixLazyEval` is an R package for "lazy evaluation" of matrices, which can help save time and memory by being smarter about common tasks like: 

- scaling rows/colums
- shifting rows/columns
- extracting residuals after linear regression
- multiplying matrices
- composing multiple such operations
- performing approximate PCA and SVD's

See [https://github.com/ekernf01/MatrixLazyEval](https://github.com/ekernf01/MatrixLazyEval) to try it out. 

##### How does it work? 

Can you spot the difference between $$(Xv) - \mathbf 1(m^Tv)$$ and $$(X - \mathbf 1 m^T)v$$? In certain realistic situations, the result is more or less the same, but the memory requirements can differ by gigabytes. 

Suppose you have a 60,000 by 30,000 sparse matrix X. You want to center each column of X to form a new matrix Z.  Then you want to compute Zv for some vector v. This closely mimics what happens when you run PCA. The first step can be written $Z = X - \mathbf 1 m^T$, where $m$ are the means and $\mathbf 1$ is a column vector of $1's$. If you center the columns naively, almost none of the zeroes will be preserved. Your matrix will be dense, and it will occupy **>14GB of memory** (1.8e9 doubles; 8 bytes per double). To avoid this, you can distribute $v$ to avoid ever storing $Z$: compute $(Xv) - \mathbf 1(m^Tv)$, where m is a row vector containing the column means of X. This consumes little memory beyond what is already used to store the data.





​    


