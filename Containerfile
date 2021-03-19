FROM ubi8
LABEL author="Erik Jacobs <erikmjacobs@gmail.com>"

ENV VERSION=2.92.0
#ENV PAT=

# expects /opt/blendtemp to have the tarfile
WORKDIR /opt/blendtemp

RUN yum -y install xz libX11 libXi libXxf86vm libXfixes libXrender libGL
RUN tar -xvf blender-${VERSION}-linux64.tar.xz
RUN mv blender-${VERSION}-linux64 /opt/blender

# final workdir where the binary is
WORKDIR /opt/blender

VOLUME /opt/blender_data/python /opt/blender_data/blend /opt/blender_data/output

CMD /opt/blender/blender -b -P /opt/blender_data/python/script.py -o /opt/blender_data/output/image.png -f 1