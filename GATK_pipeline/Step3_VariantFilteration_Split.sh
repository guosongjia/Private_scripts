#/bin/bash
VariantAfterJointCalling=$1
# Raw SNP selection from total_raw.snps.indes.vcf file
java -jar ~/Software/GATK/gatk-4.0.2.1/gatk-package-4.0.2.1-local.jar SelectVariants \
    -R /data/jiaguosong/references/octosporus_reference/S.octosporus.dna.fa \
    -V $VariantAfterJointCalling \
    --select-type-to-include SNP \
    -O TotalGenotypeGVCFs.raw.snps.vcf
# SNP filter
java -jar ~/Software/GATK/gatk-4.0.2.1/gatk-package-4.0.2.1-local.jar VariantFiltration \
    -R /data/jiaguosong/references/octosporus_reference/S.octosporus.dna.fa \
    -O TotalGenotypeGVCFs.filtered.snps.vcf \
    --variant TotalGenotypeGVCFs.raw.snps.vcf \
    --filter-expression "QD < 2.0 || MQ < 40.0 || FS > 60.0 || SOR > 3.0||MQRankSum < -12.5||ReadPosRankSum < -8.0" \
    --filter-name "SNPFilterSuggestedByGATKForum" \
    --filter-expression "QUAL<30.0||DP<10" \
    --filter-name "LowiDPAndQual"
# Extract PASS SNP sites from filtered vcf file
vcftools --vcf TotalGenotypeGVCFs.filtered.snps.vcf \
         --recode-INFO-all \
         --record \
         --keep-filtered PASS \
         -out TotalGenotypeGVCFs.filtered.PASS.snps
# Raw indel selection from total_raw.snps.indels.vcf file
java -jar ~/Software/GATK/gatk-4.0.2.1/gatk-package-4.0.2.1-local.jar SelectVariants \
    -R /data/jiaguosong/references/octosporus_reference/S.octosporus.dna.fa \
    -V $VariantAfterJointCalling \
    --select-type-to-include INDEL \
    -O TotalGenotypeGVCFs.raw.indels.vcf
# INDEL filter
java -jar ~/Software/GATK/gatk-4.0.2.1/gatk-package-4.0.2.1-local.jar VariantFiltration \
    -R /data/jiaguosong/references/octosporus_reference/S.octosporus.dna.fa \
    -O TotalGenotypeGVCFs.filtered.indels.vcf \
    --variant TotalGenotypeGVCFs.raw.indels.vcf \
    --filter-expression "QD < 2.0 || ReadPosRankSum < -20.0 || InbreedingCoeff < -0.8 || FS > 200.0 || SOR > 10.0" \
    --filter-name "INDELFilterSuggestedByGATKForum" \
    --filter-expression "QUAL<30.0||DP<10" \
    --filter-name "LowiDPAndQual"
# Extract PASS SNP sites from filtered vcf file
vcftools --vcf TotalGenotypeGVCFs.filtered.indels.vcf \
         --recode-INFO-all \
         --record \
         --keep-filtered PASS \
         -out TotalGenotypeGVCFs.filtered.PASS.indels
# Matrix File generation
python MatrixGeneration.py TotalGenotypeGVCFs.filtered.PASS.snps.vcf Pass_SNP.matrix
python MatrixGeneration.py TotalGenotypeGVCFs.filtered.PASS.indels.vcf Pass_INDEL.matrix

