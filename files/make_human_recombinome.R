library(magrittr)
LOCI = c("A", "B", "G", "D")

# Ingest and tidy data
# Goal: dataframe with one TCR segment per row
x = list.files("/Users/erickernfeld/Downloads/raw_seqs", full.names = T)
tcr_seqs_by_type_and_locus = lapply(x, read.csv, header = F, stringsAsFactors = F) %>% lapply(extract2, 1)
get_names = function(x) grep(">", x, value = T) %>% gsub(">", "", .)
get_seqs = function(x) {
  # strategy is to make one giant string; split on '>', and then clean up the mess left behind
  seqs_with_prepended_names = paste0(x, collapse="") %>% strsplit(">") %>% extract2(1) 
  seqs_with_prepended_names %<>% extract(-1) # first one is blank
  pattern = get_names(x) %>% paste0(collapse = "|") %>% gsub("\\*", "\\\\*", .)
  gsub(pattern, "", seqs_with_prepended_names)
}

get_names(tcr_seqs_by_type_and_locus[[2]])
get_seqs(tcr_seqs_by_type_and_locus[[2]])
X = data.frame( sequence = lapply(tcr_seqs_by_type_and_locus, get_seqs) %>% Reduce(f=c), 
                name     = lapply(tcr_seqs_by_type_and_locus, get_names) %>% Reduce(f=c), 
                stringsAsFactors = F)

# Detour: summarize TCR segments' basic properties
X$type = X$name %>% substr(4,4) %>% factor(levels = c("V", "D", "J", "C"))
X$locus = X$name %>% substr(3,3) %>% factor(levels = LOCI)
X$length = X$sequence %>% nchar
X %<>% (dplyr::arrange)(locus, type)
library(ggplot2)
table(X$locus, X$type)
ggplot(X) + 
  geom_point(aes(y = length, x = locus, colour = locus)) +
  facet_wrap(~type, scales = "free_y", ncol = 4) +
  ggtitle("TCR segment lengths") + 
  ylab("Length (nt)")
ggsave("~/Dropbox/blog posts/thymus atlas/TCR_length_by_segment.pdf", height = 3, width = 7)

knitr::kable(t(table(X$type, X$locus) ))
names(tcr_seqs) = basename(x) %>% gsub(".fa", "", .)

# Print a FASTA with everything in one "chromosome"
results = file.path( "~/Dropbox/blog posts/thymus atlas/human")
dir.create( results )
write.table( c( paste0( ">chrTCR_recombinome"), 
                paste0(X$sequence, collapse = "") ), 
             file.path(results, "simple_recombinome.fa"),
             quote = F, row.names = F, col.names = F ) 

# Print a refFlat and a gtf
X$seq_stops  =      cumsum(X$length) - 1
X$seq_starts = c(0, cumsum(X$length))[-(length(X$sequence) + 1)]
refFlat = with(X, data.frame(gene = paste0("TR", locus), 
                             transcript = name,
                             chr = "chrTCR_recombinome",
                             strand = "+", 
                             transcr_start = seq_starts,
                             transcr_stop = seq_stops,
                             transla_start = seq_starts,
                             transla_stop = seq_stops,
                             nexon = 1,
                             exon_starts = paste0(seq_starts, ","),
                             exon_stops = paste0(seq_stops, ","), 
                             stringsAsFactors = F)
)
write.table( refFlat, 
             file.path(results, "simple_recombinome.refFlat"),
             quote = F, row.names = F, col.names = F, sep = "\t" ) 


# # Make a GTF for STAR with one big gene and each segment as an exon.
gtf_guides = with(X, data.frame( seqname = "chrTCR_recombinome",
                                 source = "chrTCR_recombinome",
                                 feature = "exon",
                                 start = seq_starts, 
                                 end = seq_stops,
                                 score = ".", 
                                 strand = "+",
                                 frame = ".",
                                 attributes = paste0('transcript_id \"', name, '\";', 
                                                     ' gene_id \"',      name, '\"; '), 
                         stringsAsFactors = F, sep = "\t" )
)
write.table( gtf_guides, 
             file.path(results, "simple_recombinome.gtf"),
             quote = F, row.names = F, col.names = F ) 
