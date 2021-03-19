# Example Blender Render Container for OpenShift

This is a quick hackjob of an example container based on RHEL UBI8 for
rendering with Blender on OpenShift.

## Example Usage

There is already an image built on Quay. If you put a blend file and python
script in the appropriate folders, you can run the following, assuming your
current filesystem location is where you cloned this repository:

```
podman run -u 10010 -v `pwd`/blend:/opt/blender_data/blend:Z -v `pwd`/python:/opt/blender_data/python:Z -v `pwd`/output:/opt/blender_data/output:Z -it quay.io/thoraxe/blender-remote-ubi8:latest
```