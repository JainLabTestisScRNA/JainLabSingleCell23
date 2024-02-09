## Notes

### Dependencies

This should automatically run an external workflow for obtaining Dfam repeats for _Mus musculus_. See `config/config.yaml` for details on parameters for this. A github personal access token is usually required to access this resource. Please run `export GITHUB_TOKEN=<some token>` either in your analysis session or within your `.bashrc`.

It also depends on manually installed Cellranger installation. Alter this path via the `config/config.yaml` file.

A folder named `data/` is expectected in the top level directory. This holds fastqs, and is therefore not amenable to version control via git. This must be downloaded separately.

As of this writing, the workflow is developed for snakemake versions < 8.0. This primarily matters for the cluster submission functionality. This expects that you provide a profile via `--profile <your profile name>`. Some changes to the resource request blocks in each rule may be required to move this snakemake 8.0+ and/or to run this on clusters other than Rutgers' Amarel cluster.

This expects conda/mamba and singularity/apptainer to deploy other software dependencies.

### Runs

#### Initial run

Juvenile data (experiment 6417) uses the cell multiplexing workflow, which takes a config. 

#### Adult run

First run of adult data uses straight-up cellranger count. I manually renamed the adult fqs (experiment 8721) to include the Lane designator (e.g. ...\_L001\_...) so this works with cellranger count. We are still analyzing these data, but there may be some quality issues with this one, so it may be removed.

#### Subsequent Adult runs

9646-1/2 and 9682-1/2 also use the cell multiplexing workflow.
