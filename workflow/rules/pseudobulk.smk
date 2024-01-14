rule adult_pseudobulkify:
    input:
        rules.cellranger_count.output
    output:
        rds = "results/pseudobulk/adult/{sample}.se.rds"
    threads:
        24
    conda:
        "../envs/basic_scrna.yaml"
    resources:
        time="9:00:00",
        mem=128000,
        cpus=24,
    script:
        "../scripts/adult_pseudobulkify.R"

