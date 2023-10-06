rule cellranger_mkref:
  input:
    fasta = rules.genome_plus_tes_cat_genome_and_tes.output,
    gtf = rules.genome_plus_tes_make_transcripts_and_consensus_tes_gtf.output.gtf
  output:
    directory("results/cellranger/cellranger_custom_ref")
  threads:
    48
  params:
    cellranger_path = config.get("CELLRANGER_PATH"),
    mem = 128
  resources:
    time=360,
    mem=128000,
    cpus=48
  shell:
    """
    mkdir -p results/cellranger/ &&
    cd results/cellranger/ &&
    {params.cellranger_path}/cellranger mkref --genome=cellranger_custom_ref --fasta=../../{input.fasta} --genes=../../{input.gtf} --nthreads={threads} --memgb={params.mem}
    """

rule cellranger_multi:
    """
    This moves directories, so ensure that the config uses absolute paths.
    """
    input:
        idx = rules.cellranger_mkref.output,
        fqs = config.get("JUVENILE_CELLRANGER_FQS"),
        csv = "config/cellranger_config.csv"
    output:
        directory("results/cellranger/multi/")
    threads:
        48
    params:
        cellranger_path = config.get("CELLRANGER_PATH"),
        mem = 128
    resources:
        time="18:00:00",
        mem=128000,
        cpus=48,
    shell:
        """
        cd results/cellranger &&
        {params.cellranger_path}/cellranger multi --id=multi --csv ../../{input.csv} --localcores={threads} --localmem={params.mem} --disable-ui --jobmode local 
        """

rule cellranger_count:
    """
    This moves directories, so ensure that the config uses absolute paths.
    """
    input:
        idx = rules.cellranger_mkref.output,
        fqdir = config.get("ADULT_CELLRANGER_FQ_DIR"),
    output:
        directory("results/cellranger/count/{sample}/")
    threads:
        48
    params:
        cellranger_path = config.get("CELLRANGER_PATH"),
        mem = 128,
        sample_fq_prefix = lambda wc: config.get("ADULT_CELLRANGER_SAMPLES").get(wc.sample),
    resources:
        time="18:00:00",
        mem=128000,
        cpus=48,
    shell:
        """
        mkdir -p results/cellranger/count/ &&
        cd results/cellranger/count/ &&
        {params.cellranger_path}/cellranger count --transcriptome=../../../{input.idx} --id={wildcards.sample} --fastqs={input.fqdir} --sample={params.sample_fq_prefix} --localcores={threads} --localmem={params.mem} --disable-ui --jobmode local 
        """