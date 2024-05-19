## Bioconda with Docker and GitHub Actions

[![Create and publish a Docker image to ghcr.io](https://github.com/yangwu91/bioinfo-docker/actions/workflows/ghcr-publish.yml/badge.svg)](https://github.com/yangwu91/bioinfo-docker/actions/workflows/ghcr-publish.yml) [![Create and publish a Docker image to Docker Hub](https://github.com/yangwu91/bioinfo-docker/actions/workflows/dockerhub-publish.yml/badge.svg)](https://github.com/yangwu91/bioinfo-docker/actions/workflows/dockerhub-publish.yml)


This is a Docker image with Bioinformatics utilities preinstalled, enjoy! 

### Environments

* Python=3.11
* R=4
* Built on the latest ubuntu:focal docker
* Used [the BFSU mirror](https://mirrors.bfsu.edu.cn) as default
* Pre-installed some useful applications (_i.e._ wget, vim, git _etc._)
* Pre-installed some latest bioinformatics tools:
  * samtools
  * bowtie2
  * bedtools
  * bwa
  * ~~hisat2~~
  * blast
  * fastqc
  * minimap2
* Pre-installed some R packages:
  * tidyverse
  * ggplot2
  * edgeR
  * DESeq2

### Docker image

```bash
# To pull the image:
docker pull yangwu91/bioinfo
# To use the Docker bash:
docker run -it yangwu91/bioinfo
# For quick one-time use:
docker run -it -v /dev/shm:/dev/shm -v /home/user/data:/workspace yangwu91/bioinfo blastn -query /workspace/query.fasta -db /workspace/db -out /workspace/out.blastn
```

### GitHub Actions

Example workflow to set up Conda with Bioconda and other channels:

```yaml
name: bioinfo
  
on:
  release:
    types: [published]
  
jobs:
  bioconda:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Set up bioconda and other custom channels
      uses: yangwu91/bioinfo@1.0
      with:
          mirror: 'bfsu'
          channels: 'yangwu91'
          packages: 'r2g diamond'
          cmd: 'r2g --version; diamond --version'
          args: 'conda info'
```
