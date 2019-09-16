#/bin/bash
mkdir vcfFile
strainList=($(cat ./strainList))
#bamFileList=($(find ./bamFile/*.bwa.sorted.rmdup.fixed.RGadded.bam))

for ((i=0;i<=${#strainList[@]}-1;i++));do
    java -jar ~/Software/GATK/gatk-4.0.2.1/gatk-package-4.0.2.1-local.jar HaplotypeCaller  \
    -I ./bamFile/${strainList[i]}.bwa.sorted.rmdup.fixed.RGadded.bam \
    -R /data/jiaguosong/references/octosporus_reference/S.octosporus.dna.fa \
    -ERC GVCF \
    -O ./vcfFile/${strainList[i]}.raw.snps.indels.g.vcf
    echo "--variant ./vcfFile/"${strainList[i]}".raw.snps.indels.g.vcf" >> ./vcfFile/Total.g.vcf.List
done

# gVCF file merge
java -jar ~/Software/GATK/gatk-4.0.2.1/gatk-package-4.0.2.1-local.jar CombineGVCFs \
    -R /data/jiaguosong/references/octosporus_reference/S.octosporus.dna.fa \
    -O ./vcfFile/TotalGenotypeGVCFs.raw.snps.indels.g.vcf \
    --variant ./vcfFile/DY214.raw.snps.indels.g.vcf \
    --variant ./vcfFile/DY32062.raw.snps.indels.g.vcf \
    --variant ./vcfFile/DY32063.raw.snps.indels.g.vcf \
    --variant ./vcfFile/DY32064.raw.snps.indels.g.vcf \
    --variant ./vcfFile/DY32065.raw.snps.indels.g.vcf \
    --variant ./vcfFile/DY33013.raw.snps.indels.g.vcf \
    --variant ./vcfFile/DY33014.raw.snps.indels.g.vcf \
    --variant ./vcfFile/DY39685.raw.snps.indels.g.vcf \
    --variant ./vcfFile/DY39686.raw.snps.indels.g.vcf \
    --variant ./vcfFile/DY39687.raw.snps.indels.g.vcf
# Joint SNP calling using GenotypeGVCFs
java -jar ~/Software/GATK/gatk-4.0.2.1/gatk-package-4.0.2.1-local.jar GenotypeGVCFs \
    -R /data/jiaguosong/references/octosporus_reference/S.octosporus.dna.fa \
    -V ./vcfFile/TotalGenotypeGVCFs.raw.snps.indels.g.vcf \
    -O ./vcfFile/TotalGenotypeGVCFs.raw.snps.indels.vcf

    
