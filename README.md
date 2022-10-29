# BGChandler
BGChandler is a shinny app which helps researchers in:
 Simplifying deepBGC output (BGC.tsv file)  with visualizations
 enabling users to download Antismash "overview" result from HTML link (output from Antismash) as a csv file
 Downloading fasta sequennces of BGCs detected by DeepBGC and Antismash
 Combinig results of deepBGC and antiSMASH and downloading shared BGCs between them
 
 Requirments
 1-You must have R installed on you device 
 2-You must install anaconda from R to be able to get "Antismash_summary.csv" (It is recommended to remove anaconda if it is allready installed onn your device and reinstall it from R)
 3-You must have Blast Installed in your working directory ( download blast from https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/)
 
 
 HOW TO USE??? You need to upload deepBGC.BGC.tsv and  deepBGC.BGC.gbk (OUTPUTS FROM DeepBGC) to get a summary of DeepBGC output with visualization and  
 multiFASTA file of BGCs detecteed by DeepBGC (DeepBGC.FASTA)
 
 ![image](https://user-images.githubusercontent.com/53595110/198819744-c7f87142-78d1-406d-b1f3-a8079c971b78.png)

 You need to upload deepBGC.BGC.tsv and  deepBGC.BGC.gbk, whole_genome.fasta, LINK to Antismash HTML output (like that https://antismash.secondarymetabolites.org/upload/example/index.html), DeepBGC.FASTA to get the following files:
 1-Antismash_summary.csv (it is the same content of antismash overview page in csv format)
 2-Antismash.fasta (fasta sequence of Antismash BGCs)
 3-Shared.csv (shared BGCs between Deepbgc and Antismash)
