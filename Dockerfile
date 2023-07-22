FROM ubuntu:latest
RUN apt-get install -f
RUN apt-get update \
    && apt-get install -y build-essential libelf-dev \
    && apt-get install -y wget pkg-config file \
    && apt-get install -y libicu-dev libncurses5 \
&& apt-get install -y sudo
# Download and install GT.M
RUN mkdir /tmp/tmp && mkdir -p /home/vista/EHR && mkdir /home/vista/EHR/o && mkdir /home/vista/EHR/r && mkdir /home/vista/EHR/g
RUN mkdir /usr/lib/fis-gtm && mkdir /usr/lib/fis-gtm/V7.1-001_x86_64
RUN cd /tmp/tmp && pwd && ls
COPY gtm_V71001_linux_x8664_pro.tar.gz /tmp/tmp 
RUN tar -xvf /tmp/tmp/gtm_V71001_linux_x8664_pro.tar.gz -C /usr/lib/fis-gtm/V7.1-001_x86_64
# RUN mv /usr/lib/fis-gtm/gtm_V71001_linux_x8664_pro /usr/lib/fis-gtm/V7.1-001_x86_64
WORKDIR /usr/lib/fis-gtm/V7.1-001_x86_64 
RUN ./configure
# Set up GT.M profile
COPY env /home/vista
WORKDIR /
# Set aliases
RUN echo 'export vista_home="/home/vista/EHR"' >> ~/.bashrc
RUN echo 'export gtm_dist="/usr/lib/fis-gtm/V7.1-001_x86_64"' >> ~/.bashrc
RUN echo 'export gtm_zinterrupt="I \$\$JOBEXAM^ZU(\$ZPOSITION)"' >> ~/.bashrc
RUN echo 'export gtm_zquit_anyway=1' >> ~/.bashrc
RUN echo 'export gtmgbldir="$vista_home/g/mumps.gld"' >> ~/.bashrc
RUN echo 'export gtmroutines="$vista_home/o($vista_home/r) $gtm_dist/libgtmutil.so"' >> ~/.bashrc
RUN echo 'export gtm_side_effects=1'>> ~/.bashrc
RUN echo 'export gtm_boolean=1' >> ~/.bashrc
RUN echo 'export gtm_log="/var/log"' >> ~/.bashrc
RUN echo 'alias GTM="$gtm_dist/mumps -direct"' >> ~/.bashrc \
    && echo 'alias gtm="$gtm_dist/mumps -direct"' >> ~/.bashrc \
    && echo 'alias mupip="$gtm_dist/mupip"' >> ~/.bashrc \
    && echo 'alias gde="$gtm_dist/mumps -r ^GDE"' >> ~/.bashrc \
    && echo 'alias GDE="$gtm_dist/mumps -r ^GDE"' >> ~/.bashrc \
    && echo 'alias lke="$gtm_dist/lke"' >> ~/.bashrc \
    && echo 'alias dse="$gtm_dist/dse"' >> ~/.bashrc \
    && echo 'alias LKE="$gtm_dist/lke"' >> ~/.bashrc \
    && echo 'alias DSE="$gtm_dist/dse"' >> ~/.bashrc \
    && echo 'alias rundown="$gtm_dist/mupip rundown -r \"*\""' >> ~/.bashrc
RUN echo  mupip rundown -r "*"
RUN apt install -y openssh-server
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN apt-get install net-tools
EXPOSE 22
ENTRYPOINT ["/bin/bash", "-l"]
