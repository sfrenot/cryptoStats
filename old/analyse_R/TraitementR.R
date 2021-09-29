library(tibble)
library(jsonlite)
library(tidyr)
library(dplyr)
setwd("~/Cours/4A/PR/pr-noe")

brut <- stream_in(file("data.ndjson"))
tablecrypt <- tibble(brut)
longtab <- function(vector = c()){return (length(unlist(vector)))}
nbtab <- tablecrypt %>% select("tags") %>% apply(1,longtab) %>% data.frame()
tablecrypt$nbtag <- nbtab$.
tablemots <- tablecrypt %>% select(name, short, tags, nbtag) %>% filter(nbtag > 1)
cryptnotnest <- unnest(tablecrypt,tags)
listetag <- cryptnotnest %>% select(tags) %>% count(tags) %>% arrange(desc(n))
write.table(listetag, "./listetagtrie.csv", sep=';')
