#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { prepare_input_tsv } from './modules/troika.nf'
include { troika } from './modules/troika.nf'

workflow {
  ch_fastq_input = Channel.fromFilePairs( params.fastq_search_path, flat: true ).filter{ !( it[0] =~ /Undetermined/ ) }.map{ it -> [it[0].split('_')[0], it[1], it[2]] }
  prepare_input_tsv(ch_fastq_input)
  troika(ch_fastq_input.map{ it -> [it[1], it[2]] }.collect().combine(prepare_input_tsv.out.collectFile(name: 'input.tsv')).map{ it -> [it[-1], it[0..-2]]})


}