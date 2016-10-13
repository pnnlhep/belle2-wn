FROM pnnlhep/osg-base
MAINTAINER Malachi Schram "malachi.schram@pnnl.gov"

## INSTALL PACKAGES
RUN yum install -y fuse cvmfs cvmfs-config-osg; echo user_allow_other > /etc/fuse.conf

## Setup AUTOFS
RUN echo "/cvmfs /etc/auto.cvmfs" >> /etc/auto.master
RUN service autofs restart

## Setup CVMFS
RUN echo 'CVMFS_REPOSITORIES="belle.cern.ch"' >> /etc/cvmfs/default.local 
RUN ls /cvmfs/belle.cern.ch

## Copy repo
RUN mkdir -p /tmp/cvmfs/belle.cern.ch/sl6/
RUN cd /tmp/cvmfs/belle.cern.ch/sl6/
RUN rsync -lr /cvmfs/belle.cern.ch/sl6/tools ./ 

## Not sure I need this anymore
ADD ./start.sh /etc/start.sh
RUN chmod +x /etc/start.sh

CMD ["/etc/start.sh"]
