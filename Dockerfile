FROM ubuntu:jammy

MAINTAINER wuyang@drwuyang.top

COPY mirrors/* /tmp/
COPY entrypoint.sh /entrypoint.sh

ENV PATH="/opt/miniconda3/bin:$PATH"
ENV TZ="Asia/Hong_Kong"
ENV DEBIAN_FRONTEND="noninteractive"
ENV RSTUDIO_URL="https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.12.0-369-amd64.deb"
ENV BT2_URL="https://github.com/BenLangmead/bowtie2/releases/download/v2.5.2/bowtie2-2.5.2-linux-x86_64.zip"

RUN apt update -qyy && \
    apt upgrade -qyy && \
    apt install -qyy wget vim curl libcurl4-openssl-dev zip unzip iputils-ping libgl1-mesa-dev build-essential dnsutils bzip2 sed grep gawk tzdata gdebi-core && \
    wget -qO /tmp/miniconda3.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash /tmp/miniconda3.sh -bfp /opt/miniconda3 && \
    conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda update -y --all && \
    conda install -qy python=3.11 r-base=4 conda-build conda-verify requests numpy scipy pandas future beautifulsoup4 biopython matplotlib tqdm samtools bedtools bwa blast fastqc minimap2 jupyterlab r-ggplot2 r-tidyverse bioconductor-edger bioconductor-deseq2 && \
    wget -qO /tmp/bowtie2.zip ${BT2_URL} && \
    unzip /tmp/bowtie2.zip && \
    find ./ -type f -name "bowtie2*" | xargs -i {} mv {} /usr/bin/ && \
    chmod +x /usr/bin/bowtie2* && \
    wget -qO /tmp/rstudio-server.deb ${RSTUDIO_URL} && \
    gdebi -qn /tmp/rstudio-server.deb && \
    apt autoremove -qyy && \
    apt autoclean -qyy && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/apt/* && \
    conda clean -ayq && \
    chmod +x /entrypoint.sh && \
    mkdir -p /workspace && \
    chmod 777 /workspace

EXPOSE 8787
EXPOSE 8888

WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
