from Bio import SeqIO
import sys
import re

FASTA=sys.argv[1]
LIST=sys.argv[2]
PATH=sys.argv[3]
with open(LIST) as input_list:
	fasta_list=list()
	for line in input_list:
		fasta_list.append(line[:-1])


sequence_dict = SeqIO.to_dict(SeqIO.parse(FASTA,"fasta"))
for seq_names in fasta_list:
	for ids,sequences in sequence_dict.items():
		if seq_names == ids:
			SeqIO.write(sequences,str(PATH)+str(seq_names)+".sub_seq.fa","fasta")

