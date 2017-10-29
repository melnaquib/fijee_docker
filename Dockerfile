FROM ubuntu:precise
MAINTAINER Mustafa Elnaquib <melnaquib@gmail.com>

# Setup NodeSource Official PPA
RUN apt-get update && \
    apt-get install -y --force-yes \
      apt-transport-https \
      software-properties-common \
      python-software-properties \
      build-essential \
      curl \
      git \
      lsb-release \
      python-all
      
RUN add-apt-repository -y ppa:akshmakov/fijee-dev-ppa
RUN apt-add-repository -y ppa:ubuntu-toolchain-r/test

RUN apt-get update

RUN apt-get -y install build-essential cmake git
RUN apt-get -y install gcc-4.8 g++-4.8
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50

RUN apt-get -y install dolfin-yann-dev
#RUN apt-get -y install dolfin-dev

RUN apt-get -y install libeigen3-dev libcgal-dev libvtk5-dev libviennacl-dev python-vtk libnifti-dev libtrilinos-dev libgsl0-dev

#libmetis-dev, -dev from 14.04
COPY files/libmetis*.deb /tmp/
RUN dpkg -i /tmp/libmetis*.deb

RUN git clone https://github.com/Fijee-Project/Fijee
WORKDIR Fijee

#batch Fijee/*/CMakeLists.txt
#install( TARGETS FijeeBiophysics EXPORT FijeeTargets LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib )
COPY files/cmake_files.patch /tmp/
RUN git apply /tmp/cmake_files.patch

RUN mkdir build 
RUN cd build && cmake .. && make -j4
