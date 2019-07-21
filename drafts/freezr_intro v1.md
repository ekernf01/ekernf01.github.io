---
layout: post
title: Debriefing the thymus atlas, or, why freezr?
math: true
---

The Maehr Lab recently published a paper on single-cell RNA mapping of mouse thymus development. (Find it [here](https://www.ncbi.nlm.nih.gov/pubmed/29884461)). I learned a huge amount, and it's time to sit back and assimilate it. That means writing.

### What could possibly go wrong?

The number one technical challenge for me on this project was keeping everything organized. Fresh out of grad school, I jumped straight into the complicated world of single-cell RNA-seq analysis. It's a logistical nightmare. Labs generate large quantities of data and need results fast; there is often little emphasis on code quality or insufficient expertise to implement systems that improve code quality. Single-cell RNA-seq analysis (really bioinformatics in general) requires writing large amounts of heavily tailored code, and the code changes constantly. Often you want to try out many versions in a single afternoon. In this particular paper, every figure depends on a previous figure, so the whole thing is very brittle: one change up front and you need to redo everything. Everything needs to be meticulously recorded for reproducibility. 

Let's say you start trying to pull this off using Git and Rmarkdown. You start with this structure:

```
ThymusAtlasAnalysis
  scripts
    qc_and_cell_filtering.Rmd
    overview_figure.Rmd
    ...
  raw_data
    counts_e12_5.dge.txt
    ...
  results
    some_tsne.pdf
    some_cluster_markers.pdf
    cluster_assignments.csv
    ...
```

You record what R packages and versions you're using with [Packrat](http://rstudio.github.io/packrat/). You crank out some plots, make a commit, and go have a chat with the boss. 

...

It's a wonder I didn't screw it up, but I didn't (footnote 1). Why? 

### Evolution of a system

I started out with a lot of loose code -- the stuff that would eventually become [thymusatlastools](https://github.com/maehrlab/thymusatlastools). At that time, it was sitting in a big script, which was changing minute-by-minute as I figured out what the data looked like and I wanted to do with it. From previous projects, I also had a skeleton of a wrapper script that looked something like this. 

```
wrapper = function( script_name, notes_to_self ){
  results_path = file.path( "results/", get_time_and_date() )
  dir.create( results_path )
  cat( notes_to_self, file.path( results_path, "notes.txt" ) )
  setwd( results_path )
  source( script_name )
  return()
}
```

It would send results to a timestamped results folder along with some notes. This was really handy: for one thing, the timestamp makes it so I can run a script over again without worrying about overwriting results. 

### `freezr`: a system for easy and near-excessive organization of data analysis projects in R

The reason is [freezr](https://github.com/ekernf01/freezr).




Footnotes

- Footnote 1: The [source code](https://github.com/maehrlab) and [expression matrices](https://www.ncbi.nlm.nih.gov/gds?LinkName=pubmed_gds&from_uid=29884461) are public, so you can check for yourself whether I screwed up.

 