import sys
from Bio import SeqIO
FASTA = sys.argv[1]
sequence_dict = SeqIO.to_dict(SeqIO.parse(FASTA,"fasta"))
for id,seq in sequence_dict.items():
    print id + "\t" + str(len(seq))
