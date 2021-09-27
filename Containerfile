FROM ubi8
LABEL author="Erik Jacobs <erikmjacobs@gmail.com>"

ENV VERSION=2.93.4
#ENV PAT=

# expects /opt/blendtemp to have the tarfile
WORKDIR /opt/blendtemp

RUN yum -y install xz libX11 libXi libXxf86vm libXfixes libXrender libGL wget
RUN tar -xvf blender-${VERSION}-linux-x64.tar.xz
RUN mv blender-${VERSION}-linux-x64 /opt/blender
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && chmod 755 /usr/local/bin/mc
# final workdir where the binary is
WORKDIR /opt/blender

VOLUME /opt/blender_data/output

ENTRYPOINT [ "render.sh" ]

COPY render.sh /usr/local/sbin
