# BGChandler
BGChandler is a shinny app which help researchers in:
 Simplifying deepBGC output (BGC.tsv file)  with visualizations
 enable users to download Antismash overview result as a csv file
 Downloading BGC.Fasta files from DeepBGC and Antismash output
 Combinig results of deepBGC and antiSMASH and downloading shared BGCs between them
 
 Requirments
 1-You must have R installed on you device 
 2-You must install anaconda from R to be able to get "Antismash_summary.csv"
 3-You must have blast nstalled in your working directory
 
 
 HOW TO USE??? You need to upload deepBGC.BGC.tsv and  deepBGC.BGC.gbk (OUTPUTS FROM DeepBGC) to get a summary of DeepBGC output with visualization and  
 multiFASTA file of BGCs detecteed by DeepBGC (DeepBGC.FASTA)
 ![image](https://user-images.githubusercontent.com/53595110/198819744-c7f87142-78d1-406d-b1f3-a8079c971b78.png)

 You need to upload deepBGC.BGC.tsv and  deepBGC.BGC.gbk, whole_genome.fasta, LINK to Antismash HTML output, DeepBGC.FASTA to get the following files:
 1-Antismash_summary.csv (it is the same content of antismash overview page in csv format)
 2-Antismash.fasta (fasta sequence of Antismash BGCs)
 3-Shared.csv (shared BGCs between Deepbgc and Antismash)
