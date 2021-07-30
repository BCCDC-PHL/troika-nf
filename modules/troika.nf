process prepare_input_tsv {

  tag { sample_id }

  executor 'local'

  input:
    tuple val(sample_id), path(reads_1), path(reads_2)

  output:
    path("${sample_id}_input.tsv")

  script:
    """
    echo "${sample_id},\$(readlink ${reads_1}),\$(readlink ${reads_2})" | tr ',' \$'\\t' > ${sample_id}_input.tsv
    """
}

process troika {

  publishDir "${params.outdir}", mode: 'copy', pattern: "output/*", saveAs: { it.split("/")[1] }
  publishDir "${params.outdir}", mode: 'copy', pattern: "*.{tab,toml}"
  publishDir "${params.outdir}", mode: 'copy', pattern: "troika.log"

  input:
    tuple path(input_file), path(reads)

  output:
    path("output/*", type: 'dir')
    path("*.{tab,toml}")
    path("troika.log")

  script:
    resistance_only = params.resistance_only ? "--resistance_only" : ""
    detect_species = params.detect_species ? "--detect_species" : ""
    """
    mkdir output
    troika \
      --input_file ${input_file} \
      --jobs ${params.jobs} \
      --kraken_threads ${task.cpus} \
      --kraken_db ${params.kraken_db} \
      --snippy_threads ${task.cpus} \
      ${resistance_only} \
      ${detect_species} \
      --min_cov ${params.min_cov} \
      --min_aln ${params.min_aln} \
      --workdir .
    pushd output
    while IFS=\$'\\t' read -r sample_id
    do 
      ln -s ../\${sample_id} .
    done < <(cut -d \$'\\t' -f 1 ../input.tsv)
    popd
    """
}