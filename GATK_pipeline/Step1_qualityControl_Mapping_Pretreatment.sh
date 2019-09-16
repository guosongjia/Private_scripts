#/bin/bash
mkdir fqFileAfterQC
mkdir qualityControl
mkdir bamFile
fastqPath=/data/fastq_octosporus
strainList=($(cat ./strainList))
for ((i=0;i<=${#strainList[@]}-1;i++));do
    echo "Now processing " ${strainList[i]}
# Reads quality control using fastp
    fastp -i $fastqPath/${strainList[i]}_1.fq.gz \
          -I $fastqPath/${strainList[i]}_2.fq.gz \
          -o ./fqFileAfterQC/${strainList[i]}_fastp_1.fq.gz \
          -O ./fqFileAfterQC/${strainList[i]}_fastp_2.fq.gz \
          --html ./qualityControl/${strainList[i]}.html \
          --json ./qualityControl/${strainList[i]}.json
# Reads mapping using bwa mem
    bwa mem -t 4 \
            /data/jiaguosong/references/octosporus_reference/bwa_index/S.octosporus.dna.fa \
            ./fqFileAfterQC/${strainList[i]}_fastp_1.fq.gz  ./fqFileAfterQC/${strainList[i]}_fastp_2.fq.gz > ./bamFile/${strainList[i]}.bwa.sam
    echo "***Sam=>Bam=>Sorted=>Index"
    samtools view -bS ./bamFile/${strainList[i]}.bwa.sam > ./bamFile/${strainList[i]}.bwa.bam
    samtools sort ./bamFile/${strainList[i]}.bwa.bam ./bamFile/${strainList[i]}.bwa.sorted
    samtools index ./bamFile/${strainList[i]}.bwa.sorted.bam
    rm ./bamFile/${strainList[i]}.bwa.sam
    rm ./bamFile/${strainList[i]}.bwa.bam
    echo "***GATK_Picard markduplication reads"
# Mark Duplicate reads
    java -jar ~/Software/GATK/gatk-4.0.2.1/gatk-package-4.0.2.1-local.jar  MarkDuplicates \
        -I./bamFile/${strainList[i]}.bwa.sorted.bam \
        -O./bamFile/${strainList[i]}.bwa.sorted.rmdup.bam \
        -M./bamFile/${strainList[i]}_marked_dup_matrics.txt
# Calculate insert size and draw insert size distribution histogram
    java -jar ~/Software/GATK/gatk-4.0.2.1/gatk-package-4.0.2.1-local.jar CollectInsertSizeMetrics \
        -I ./bamFile/${strainList[i]}.bwa.sorted.rmdup.bam \
        -O ./qualityControl/${strainList[i]}.insert_size_metrics.txt \
        -H ./qualityControl/${strainList[i]}.insert_size_histogram.pdf \
        -M=0.5
# Fix mate reads information
    java -jar ~/Software/GATK/gatk-4.0.2.1/gatk-package-4.0.2.1-local.jar  FixMateInformation \
        -I ./bamFile/${strainList[i]}.bwa.sorted.rmdup.bam \
        -O ./bamFile/${strainList[i]}.bwa.sorted.rmdup.fixed.bam 
# Add @RG annotation for bam files
    java -jar ~/Software/GATK/gatk-4.0.2.1/gatk-package-4.0.2.1-local.jar AddOrReplaceReadGroups \
        -I ./bamFile/${strainList[i]}.bwa.sorted.rmdup.fixed.bam \
        -O ./bamFile/${strainList[i]}.bwa.sorted.rmdup.fixed.RGadded.bam \
        -RGLB ${strainList[i]} \
        -RGPL illumina \
        -RGPU unit1 \
        -RGSM ${strainList[i]}
    samtools index ./bamFile/${strainFile[i]}.bwa.sorted.rmdup.fixed.RGadded.bam
# Delete intermediate bam files during data pretreatment
    rm ./bamFile/${strainList[i]}.bwa.sorted.bam
    rm ./bamFile/${strainList[i]}.bwa.sorted.bam.bai
    rm ./bamFile/${strainList[i]}.bwa.sorted.rmdup.bam
    rm ./bamFile/${strainList[i]}.bwa.sorted.rmdup.fixed.bam
done
