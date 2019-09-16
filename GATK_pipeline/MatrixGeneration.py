# Script Owner: Guosng Jia
# Script Description: This script using GATK-Joint_calling_output.vcf file as input file and generate a 
#                    \t seperated Matrix file like below:
#    Chromosome  Site    Ref    SNP    Sample-1    Sample-2    ....
#    supercont6.1    587    T    C   1   0   ....

import vcf
import sys
VcfReader = vcf.Reader(filename=sys.argv[1])
StrainList = VcfReader.samples
FileName = sys.argv[2]
with open(str(FileName),'w') as OUTPUT:
    OUTPUT.write("Chromosome" +"\t"+"Position"+"\t"+"Ref"+"\t"+"Alt"+"\t")
    for i in range(len(StrainList)):
        if i <= len(StrainList)-2:
            OUTPUT.write(str(StrainList[i]) + "\t")
        else:
            OUTPUT.write(str(StrainList[i]) + "\n")
    for record in VcfReader:
        chromosome = record.CHROM
        position = record.POS
        ReferenceSite = record.REF
        SNPSite = record.ALT
        OUTPUT.write(str(chromosome)+"\t"+str(position)+"\t"+str(ReferenceSite)+"\t"+str(SNPSite)+"\t")
        for i in range(len(StrainList)):
            if record.genotype(str(StrainList[i]))['GT'] == "1/1" and i <= len(StrainList) -2:
                OUTPUT.write("1\t")
            elif record.genotype(str(StrainList[i]))['GT'] != "1/1" and i <= len(StrainList) -2:
                OUTPUT.write("0\t")
            elif record.genotype(str(StrainList[i]))['GT'] == "1/1" and i == len(StrainList)-1:
                OUTPUT.write("1\n")
            elif record.genotype(str(StrainList[i]))['GT'] != "1/1" and i == len(StrainList)-1:
                OUTPUT.write("0\n")


