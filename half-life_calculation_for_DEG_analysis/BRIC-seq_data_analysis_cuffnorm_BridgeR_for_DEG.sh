#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -soft -l ljob,lmem
#$ -l s_vmem=16G
#$ -l mem_req=16G

filename_1="cuffnorm_out_XXX_Control" #Required
filename_2="cuffnorm_out_XXX_Knockdown" #Required
gtfFile="/path/to/gencode.v19.annotation.gtf" #Required

cuffnorm -p 8 --compatible-hits-norm -o ${filename_1} ${gtfFile} \
tophat_out_XXX_0h/accepted_hits.bam \
tophat_out_XXX_2h/accepted_hits.bam \
tophat_out_XXX_4h/accepted_hits.bam \
tophat_out_XXX_8h/accepted_hits.bam \
tophat_out_XXX_12h/accepted_hits.bam

cuffnorm -p 8 --compatible-hits-norm -o ${filename_2} ${gtfFile} \
tophat_out_XXX_0h/accepted_hits.bam \
tophat_out_XXX_2h/accepted_hits.bam \
tophat_out_XXX_4h/accepted_hits.bam \
tophat_out_XXX_8h/accepted_hits.bam \
tophat_out_XXX_12h/accepted_hits.bam

# mRNA
gene_list="/path/to/gencode.v19.annotation_symbol_type_list.txt" #Required
python make_map_from_gtf.py ${gtfFile} ${gene_list}

cuffnorm_data_1="./${filename_1}/genes.fpkm_table"
cuffnorm_data_2="./${filename_2}/genes.fpkm_table"
gene_type="mRNA"
result_file_1="BridgeR_input_file_mRNA_${filename_1}.txt"
result_file_2="BridgeR_input_file_mRNA_${filename_2}.txt"
python BridgeR_prep.py ${gene_list} ${cuffnorm_data_1} ${gene_type} ${result_file_1}
python BridgeR_prep.py ${gene_list} ${cuffnorm_data_2} ${gene_type} ${result_file_2}
mkdir BRIC-seq_BridgeR_mRNA
mv ${result_file_1} BRIC-seq_BridgeR_mRNA
mv ${result_file_2} BRIC-seq_BridgeR_mRNA
mv BridgeR_analysis_mRNA.R BRIC-seq_BridgeR_mRNA
cd BRIC-seq_BridgeR_mRNA
Rscript BridgeR_analysis_mRNA_for_DEG.R ./${result_file_1} ./${result_file_2}
cd ..

# lncRNA
gene_type="lncRNA"
result_file_1="BridgeR_input_file_lncRNA_${filename_1}.txt"
result_file_2="BridgeR_input_file_lncRNA_${filename_2}.txt"
python BridgeR_prep.py ${gene_list} ${cuffnorm_data_1} ${gene_type} ${result_file_1}
python BridgeR_prep.py ${gene_list} ${cuffnorm_data_2} ${gene_type} ${result_file_2}
mkdir BRIC-seq_BridgeR_lncRNA
mv ${result_file_1} BRIC-seq_BridgeR_lncRNA
mv ${result_file_2} BRIC-seq_BridgeR_lncRNA
mv BridgeR_analysis_lncRNA.R BRIC-seq_BridgeR_lncRNA
cd BRIC-seq_BridgeR_lncRNA
Rscript BridgeR_analysis_lncRNA_for_DEG.R ./${result_file_1} ./${result_file_2} ../BRIC-seq_BridgeR_mRNA/BridgeR_3_Normalizaion_factor_Control_mRNA.txt

# Output filename: BridgeR_6_HalfLife_Pvalue_estimation.txt
