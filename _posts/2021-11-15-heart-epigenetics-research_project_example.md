---
layout: post
title: Learning to learn about epigenetics (example project)
math: true
tags: misc
---

This is an example of a completed project from [my class on epigenetics](https://ekernf01.github.io/2021-11-15-heart-epigenetics).

---

## Annotated bibliography: mechanism(s) of gene silencing by DNA methylation

Eric Kernfeld

### Preface

During my preparation to teach this class, I became interested in DNA methylation. At my previous job, we talked a lot about histone modifications and chromatin accessibility, and I analyzed data directly measuring those properties, but methylation only came up once in the 4 years I spent there, and someone else handled the analysis. Because of this, I'm  not familiar with methylation in general. From some long-ossified textbook reading, I know it represses transcription, but I don't know how, and I don't know what processes methylation helps control or enable. 


Now, I'm meeting people in Andy Feinberg's lab who do basic research on methylation, studying how it changes during cancer or in response to genetic mutations or in response to the physical environment of the cell. I also learned that methylation is the key mechanism in MyoD reprogramming, which was the first instance where stem cells were purposefully "reprogrammed" to a different cell type. Overall, it's a really important aspect of epigenetic state, and I want to know more about how it works. Among many possible questions, you can see below the one I chose.

One publicly available resource to learn about methylation in cancer is the interview in ref. 1. I learned about reprogramming from the JHU class "Computational Stem Cell Biology", and the materials for that class are not public, but they refer to the original papers listed as refs 2 and 3. A nice place to learn about DNA methylation for the first time is the review article in ref. 4. 

### Question

How does DNA methylation silence nearby genes? In particular, does it directly prevent binding of TF's or RNA Pol II, or does it serve as a marker for some other system to come along and do the grunt work? 

### Not my question

Right now, I don't want to get distracted by how DNA methylation gets added or removed. I don't want to get distracted by its downstream effects on cancer, development, or any other tissue-level or organism-level phenotype.

### Premise

The question assumes that DNA methylation silences gene activity. To find the original evidence for this, I started from ref. 4, the review, which sent me to refs. 5 and 6. Upon reading these, it seems that ref. 5 hardly says a thing about transcription, but rather proposes a bizarre molecular clock mechanism in which methylation is part of a chemical process to systematically change DNA base identity in specific loci. It would be interesting to know whether this molecular clock is actually known to be relevant to animal development, but that question is out of scope here. Ref. 6 is much more relevant: a gene called metallothionein-I is expressed in response to cadmium and zinc, but only if the locus is not methylated. This is shown by measuring methylation with restriction enzymes and by altering methylation with 5-azacytidine, a cytosine analog that cannot be methylated. The intro to ref. 6 cites many slightly earlier works that observe correlations between expression and methylation, though most of those studies could not prove causation because they did not intervene on the methylation state. 

Modern technology is able to measure methylation status and transcription across the entire genome. In addition to these 1970's and 1980's papers discussing single genes, it would be nice to know whether these effects are consistent across many genes. By using bisulfite sequencing (which measures cytosine methylation) and RNA-sequencing (which measures transcript quantities), Ref. 6 finds consistent effects across the genome and across species. It also offers an interesting clue about the mechanism: DNA methylation is most consistently associated with transcriptional repression when the DNA in the first intron of the gene is methylated. It doesn't entirely make sense to analyze methylation in terms of introns and exons because splicing happens to RNA, not DNA, but they suggest that the first intron is important because its DNA often contains enhancers.

### Answering the question

The review article (ref 4) claims that methylation can repress transcription in both ways: by preventing TF's from binding and by recruiting proteins that make other epigenetic changes.   

Regarding direct prevention of binding, one example is ref 7 (Watt et al 1988). They study a transcription factor binding site where methylation inhibited binding of a transcriptional activator. The effect was dose-dependent: methylation of a single strand of the target DNA produced expression levels between those of the fully-methylated and unmethylated binding sites. It was also very localized: methylating a site 6 base-pairs away did not repress transcription. I have not found other instances of this effect.

Most other literature focuses on indirect effects via recruitment of repressive "methyl reader" proteins. The review article ref 4 has a section on these methylation readers. This mentions ref 9, which describes one family of methyl-reading transcriptional repressors, and refs 11-14, which describe another.

Refs 8-10 describe MeCP2. Ref 8 is the original discovery and naming of this gene (in the rat genome, not the human genome). This paper was a screen: they had methylated and non-methylated DNA sections, and they sorted out proteins by size on a polyacrylamide gel, looking for bands in the gel that could preferentially bind the methylated DNA. Once they found the protein and found that it had different properties than already-known methylation readers, they digested the protein, obtained amino acid sequences for the fragments, and deduced enough of the nucleotide sequence to PCR-amplify the gene out of the genome. They found that MeCP2 was highly sensitive, binding DNA with even a single methylated cytosine. 

Ref. 9 talks more about the mechanism linking MeCP2 and gene expression. The introduction of this paper has a great collection of related work, especially discussing how far away the methylation can be from the promoter while still repressing it. They studied transcription from a reporter sequence in vitro with/without methylation and with/without MeCP2. Neither one alone repressed transcription, but together they did repress transcription. They also studied a modified MeCP2 with a deleted DNA binding domain (this did not repress transcription) and a competition assay where other methylated DNA was added to soak up MeCP2 (this removed the repressive effect). they also constructed a fusion of MeCP2 (without DNA binding domain) and the binding domain of a well-known TF called GAL4. They could then repress transcription at GAL4 binding sites, even when those binding sites were not methylated and even when the GAL4 sites were 1-2 kilobases away from the promoter. This shows that MeCP2 is necessary and sufficient for methylation to repress transcription, at least under the particular conditions studied.

Ref 10 determines how the MeCP2 transcriptional repression domain works. It detects binding to a complex containing histone deacetylases: so by capturing a domain of MeCP2 on a bead, they end up also capturing histone modifiers. They also inhibit these histone modifiers with a drug, and they find that the repressive effect of the methylation decreases. Thus, the methylation physically binds with histone modifiers (via MeCP2) and depends on them to do its job.

Ref 4 cites additional work in this area on family members such as MeCP1 or MBD2 and structurally unrelated but functionally similar proteins such as Kaiso and ZBTB4. One important paper in this area is ref 11, which finds two new methyl-sensitive proteins belonging to the zinc-finger TF family. The mechanism by which this family represses transcription is not clear (to me); I don't know whether anyone has done the same experiment described above to look for recruitment of histone deacetylases. If they did, I doubt they would find the same result, but I don't know what would be a better candidate. 

### Future outlook

My reading is still at least a decade behind the state of the DNA methylation field, so I am unable to comment on future studies. If I were to continue reading, I would want to know more about the histone modifiers that act downstream of DNA methylation. There is a lot of variation from gene to gene in the effect of DNA methylation. Ref 11 backs me up on this:

> The existence of multiple proteins that all recognize the same seemingly simple signal—methylated CpG—is intriguing and suggests that the DNA methylation signal may have complex and subtle consequences at different genomic loci and in different cell types.

So, I would also like to know whether there exist predictive models that can accept (as input) relevant factors such as methylation status, DNA sequence, and TF availability and yield (as output) a prediction about the level of transcription at any given gene. If not, what would it take for the field to get to that point?

### References

1. Feinberg, A. (2014). DNA methylation in cancer: three decades of discovery. Genome medicine, 6(5), 1-4.
2. Taylor, S. M., & Jones, P. A. (1979). Multiple new phenotypes induced in 10T12 and 3T3 cells treated with 5-azacytidine. Cell, 17(4), 771-779.
3. Davis, R. L., Weintraub, H., & Lassar, A. B. (1987). Expression of a single transfected cDNA converts fibroblasts to myoblasts. Cell, 51(6), 987-1000.
4. Moore, L. D., Le, T., & Fan, G. (2013). DNA methylation and its basic function. Neuropsychopharmacology, 38(1), 23-38. 
5. Holliday, R., & Pugh, J. E. (1975). DNA modification mechanisms and gene activity during development. Science, 187(4173), 226-232.
6. Anastasiadi, D., Esteve-Codina, A., & Piferrer, F. (2018). Consistent inverse correlation between DNA methylation of the first intron and gene expression across tissues and species. Epigenetics & chromatin, 11(1), 1-17.
7.  Watt, F., & Molloy, P. L. (1988). Cytosine methylation prevents binding to DNA of a HeLa cell transcription factor required for optimal expression of the adenovirus major late promoter. Genes & development, 2(9), 1136-1143.
8. Lewis, J. D., Meehan, R. R., Henzel, W. J., Maurer-Fogy, I., Jeppesen, P., Klein, F., & Bird, A. (1992). Purification, sequence, and cellular localization of a novel chromosomal protein that binds to methylated DNA. Cell, 69(6), 905-914.
9. Nan, X., Campoy, F. J., & Bird, A. (1997). MeCP2 is a transcriptional repressor with abundant binding sites in genomic chromatin. Cell, 88(4), 471-481.
10. Nan, X., Ng, H. H., Johnson, C. A., Laherty, C. D., Turner, B. M., Eisenman, R. N., & Bird, A. (1998). Transcriptional repression by the methyl-CpG-binding protein MeCP2 involves a histone deacetylase complex. Nature, 393(6683), 386-389.
11. Filion, G. J., Zhenilo, S., Salozhin, S., Yamada, D., Prokhortchouk, E., & Defossez, P. A. (2006). A family of human zinc finger proteins that bind methylated DNA and repress transcription. Molecular and cellular biology, 26(1), 169-181.

    