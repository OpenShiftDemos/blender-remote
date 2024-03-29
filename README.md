# Blender Render Container for Kubernetes

This is a Blender headless/remote renderer image, based on RHEL UBI, designed to
run in Kubernetes environments. It pulls an asset-embedded .blend file from a
webserver and uploads the output to an S3 bucket.

## Prerequisites
You will need an asset-embedded .blend file on an accessible webserver.
Authentication is currently NOT SUPPORTED.

You will need a Minio S3 endpoint available for the output to be stored. Other
S3 endpoints currently are NOT SUPPORTED.
## Example Local Usage
The following example, for testing purposes, assumes you already have an image
built and hosted in an accessible registry. Specific environment variables are required:

* `DEBUG`: when set to `1` will use `-x` mode for the internal bash script
* `BLEND_LOCATION`: The URL of the .blend file that will be fetched for processing
* `RENDER_TYPE`: May **ONLY** be set to either `image` or `animation`
* `S3_ENDPOINT`: The url of the S3 API endpoint
* `S3_KEY`: The user/key used to authenticate to the S3 API endpoint
* `S3_SECRET`: The secret used to authenticate to the S3 API endpoint

```
podman run --rm \
-e BLEND_LOCATION=http://192.168.1.235:8080/fedora.blend \
-e RENDER_TYPE=image \
-e S3_ENDPOINT=http://192.168.1.235:9000 \
-e S3_KEY=testuser_key \
-e S3_SECRET=testuser_secret \
quay.io/openshiftdemos/blender-remote
```

## Example Minio
If you want to quickly test locally with Minio, you can run an ephemeral Minio
server with the following:

```
podman run -p 9000:9000 -p 9001:9001 \
  quay.io/minio/minio server /data --console-address ":9001"
```

The default admin is `minioadmin` with password `minioadmin` and you can use
those values for your `S3_KEY` and `S3_SECRET`.

## Example Webserver
If you have Node.js installed, you can use the `http-server` Node module to
serve the `examples` folder of this repo:

```
cd examples
http-server .
```

## Example Kubernetes usage
If you have a Kubernetes cluster handy, there is an example `Job` and
`ConfigMap` that can be used. It assumes the image hosted in Quay. Modify the
`example-animation-configmap.yaml` or `example-image-configmap.yaml` to suit
your environment, and then:

```
kubectl create -f k8s/example-TYPE-configmap.yaml
kubectl create -f k8s/example-job.yaml
```