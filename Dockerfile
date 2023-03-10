FROM ubuntu:jammy

MAINTAINER wuyang@drwu.ga

COPY mirrors/* /tmp/
COPY entrypoint.sh /entrypoint.sh

ENV PATH="/opt/miniconda3/bin:$PATH"
ENV TZ="Asia/Hong_Kong"
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update -qyy && \
    apt upgrade -qyy && \
    apt install -qyy wget vim curl libcurl4-openssl-dev zip unzip iputils-ping libgl1-mesa-dev build-essential dnsutils bzip2 sed grep gawk tzdata && \
    wget -qO /tmp/miniconda3.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash /tmp/miniconda3.sh -bfp /opt/miniconda3 && \
    conda config --add channels defaults && \
	conda config --add channels bioconda && \
	conda config --add channels conda-forge && \
    conda update -y --all && \
    conda install -qy python=3.10 r-base=4 conda-build conda-verify requests  numpy scipy pandas future beautifulsoup4 biopython matplotlib tqdm samtools bowtie2 bedtools bwa hisat2 blast fastqc minimap2 r-ggplot2 r-tidyverse bioconductor-edger bioconductor-deseq2 && \
    apt autoremove -qyy && \
    apt autoclean -qyy && \
    rm -rf /tmp/miniconda3.sh /var/lib/apt/lists/* /var/cache/apt/* && \
    conda clean -ayq && \
    chmod +x /entrypoint.sh && \
    mkdir -p /workspace && \
    chmod 777 /workspace

WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
