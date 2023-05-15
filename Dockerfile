FROM inseefrlab/onyxia-rstudio:r4.2.3

WORKDIR ${HOME}/ESA-Nowcasting-2023
COPY . .

RUN apt-get update && \
    # System libs
    apt-get install -y --no-install-recommends \
        libcurl4-openssl-dev \
        libglpk-dev \
        openjdk-8-jdk && \
    # Install Python
    /rocker_scripts/install_python.sh && \
    # Install Python dependencies 
    pip install -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cpu && \
    # Configure renv to use RSPM to download packages by default 
    echo 'options(renv.config.repos.override = getOption("repos"))' >> ${R_HOME}/etc/Rprofile.site && \
    # Install R dependencies
    Rscript -e "renv::restore()" && \
    # Fix permissions 
    chown -R ${USERNAME}:${GROUPNAME} ${HOME}
    
# Fix permissions
RUN chmod -R 777 /ESA-Nowcasting-2023
