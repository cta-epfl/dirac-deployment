FROM ubuntu

RUN apt update
RUN apt install -y curl wget build-essential
RUN apt install -y systemd

#RUN curl -LO https://github.com/DIRACGrid/DIRACOS2/releases/latest/download/DIRACOS-Linux-x86_64.sh && \
#    bash DIRACOS-Linux-x86_64.sh

RUN adduser --disabled-password dirac


# http://diracproject.web.cern.ch/diracproject/rpm/runit-2.1.2-1.el7.cern.x86_64.rpm
RUN  mkdir -p /package && \
     chmod 1755 /package && \
     cd /package && \
     wget http://smarden.org/runit/runit-2.1.2.tar.gz && \
     gunzip runit-2.1.2.tar && \
     tar -xpf runit-2.1.2.tar && \
     rm runit-2.1.2.tar && \
     cd admin/runit-2.1.2 && \
     ./package/install

RUN mkdir -pv /opt/dirac && \
    chown dirac:dirac /opt/dirac

ADD runsvdir-start /opt/dirac/sbin/runsvdir-start
#ADD runsvdir-start.service /usr/lib/systemd/system/runsvdir-start.service

#RUN systemctl daemon-reload && \
#    systemctl restart runsvdir-start && \
#    systemctl enable runsvdir-start

USER dirac
    
ADD install_site.sh ./install_site.sh
#curl -O https://raw.githubusercontent.com/DIRACGrid/management/master/install_site.sh  && \

RUN mkdir -pv /home/dirac/DIRAC && \
    cd /home/dirac/DIRAC && \
    curl -L https://github.com/DIRACGrid/DIRAC/raw/integration/src/DIRAC/Core/scripts/install_full.cfg -o /home/dirac/DIRAC/install.cfg && \
    bash /install_site.sh -i /opt/dirac -e wheel install.cfg
    #./install_site.sh -i /opt/dirac [-v <x.y.z>] [-e <extension>] [-p <extra-pip-install>] install.cfg



ENTRYPOINT /opt/dirac/sbin/runsvdir-start
