# Troika-NF: A Nextflow Wrapper for the Troika Mycobacteria Genomics Analysis Pipeline

*This pipeline is currently in development. Details below are incomplete and subject to change.*

This is a Nextflow-based wrapper for the [Troika](http://github.com/MDU-PHL/troika) pipeline for Mycobacteria genomics analysis.
Its purpose of this wrapper is to enable our use of Troika on available HPC infrastructure, where we have had
difficulty running snakemake pipelines on directly. This pipeline can also modify the way that
data is input into the pipeline and how it is output from the pipeline, to better integrate with
out genomics workflows and infrastructure.

## Usage

```
nextflow run BCCDC-PHL/troika-nf \
  --fastq_input <fastq_input_dir> \
  --outdir <output_dir>
```

### Parameters

| Flag      | Default Value | Description               |
|:----------|--------------:|:--------------------------|
| --min_cov |            40 | Minimum depth of coverage |

## Output
Troika will create an output directory for each sample. This wrapper pipeline will infer the sample ID for each pair of fastq files
based on the leftmost part of the fastq filenames up until the first '_' character.

## Quality Control
Troika has some built-in quality checks. This page will be updated with a more detailed description.

## Troubleshooting
Using this nested pipeline approach can cause some difficulty in obtaining detailed troubleshooting information.
Within the directory where the troika pipeline is invoked as a Nextflow process, a snakemake log will be created under `.snakemake/log`