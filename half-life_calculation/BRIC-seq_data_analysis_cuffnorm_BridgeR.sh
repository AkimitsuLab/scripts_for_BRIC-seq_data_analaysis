#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -soft -l ljob,lmem
#$ -l s_vmem=16G
#$ -l mem_req=16G

filename="cuffnorm_out_XXX" #Required
gtfFile="/path/to/gencode.v19.annotation.gtf" #Required

cuffnorm -p 8 --compatible-hits-norm -o ${filename} ${gtfFile} \
tophat_out_XXX_0h/accepted_hits.bam \
tophat_out_XXX_2h/accepted_hits.bam \
tophat_out_XXX_4h/accepted_hits.bam \
tophat_out_XXX_8h/accepted_hits.bam \
tophat_out_XXX_12h/accepted_hits.bam


# mRNA
gene_list="/path/to/gencode.v19.annotation_symbol_type_list.txt" #Required
python make_map_from_gtf.py ${gtfFile} ${gene_list}

cuffnorm_data="./${filename}/genes.fpkm_table"
gene_type="mRNA"
result_file="BridgeR_input_file_mRNA.txt"
python BridgeR_prep.py ${gene_list} ${cuffnorm_data} ${gene_type} ${result_file}
mkdir BRIC-seq_BridgeR_mRNA
mv ${result_file} BRIC-seq_BridgeR_mRNA
mv BridgeR_analysis_mRNA.R BRIC-seq_BridgeR_mRNA
cd BRIC-seq_BridgeR_mRNA
Rscript BridgeR_analysis_mRNA.R ./BridgeR_input_file_mRNA.txt
cd ..

# lncRNA
gene_type="lncRNA"
result_file="BridgeR_input_file_lncRNA.txt"
python BridgeR_prep.py ${gene_list} ${cuffnorm_data} ${gene_type} ${result_file}
mkdir BRIC-seq_BridgeR_lncRNA
mv ${result_file} BRIC-seq_BridgeR_lncRNA
mv BridgeR_analysis_lncRNA.R BRIC-seq_BridgeR_lncRNA
cd BRIC-seq_BridgeR_lncRNA
Rscript BridgeR_analysis_lncRNA.R ./BridgeR_input_file_lncRNA.txt ../BRIC-seq_BridgeR_mRNA/BridgeR_3_Normalizaion_factor_Control_mRNA.txt

# Output filename: BridgeR_5C_HalfLife_calculation_R2_selection.txt
