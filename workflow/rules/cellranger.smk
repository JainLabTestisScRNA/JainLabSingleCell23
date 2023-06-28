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

FQS = ["data/6417-DJ-1-CMO_GTCGTAAA-AGCCTACT_S2_R1_001.fastq.gz", "data/6417-DJ-1-CMO_GTCGTAAA-AGCCTACT_S2_R2_001.fastq.gz", "data/6417-DJ-1-GEX_TGCAATGT-TTCGACAA_S1_R1_001.fastq.gz", "data/6417-DJ-1-GEX_TGCAATGT-TTCGACAA_S1_R2_001.fastq.gz"]

rule cellranger_multi:
    """
    This moves directories, so ensure that the config uses absolute paths.
    """
    input:
        idx = rules.cellranger_mkref.output,
        fqs = FQS,
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