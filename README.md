# Docker-Pandoc-extra

This repository builds a lightweight Docker image based on [`pandoc/extra:latest-alpine`](https://hub.docker.com/r/pandoc/extra), with `make` added.
(GNU make is missing from the base image.)

## Build

Build the image locally:

```sh
docker build -t pandoc-extra .
```

## Use

The default entrypoint for the image is Pandoc, which allows you to run Pandoc commands directly.

Convert a Markdown file to HTML:

```sh
docker run --rm -v "$PWD:/data" pandoc-extra source.md -o output.html
```

To run an interactive shell, you need to override the default entrypoint:

```sh
docker run --rm -it -v "$PWD:/data" --entrypoint /bin/sh pandoc-extra
```


### Run Makefile
Run a Makefile in the mounted project directory. Override the inherited Pandoc entrypoint so Docker runs `make` instead:

```sh
docker run --rm -v "$PWD:/data" --entrypoint make pandoc-extra
```

### Use in GitLab CI

The base image defines Pandoc as its entrypoint. GitLab CI must override it so the runner can execute the job shell; then invoke `make` in the `script` section:

```yaml
build:
  image:
    name: drdpham/pandoc-extra:latest
    entrypoint: [""]
  script:
    - make
```

The job's `make` command runs the `Makefile` from the checked-out project directory.

## Maintenance

To enable publishing, open the GitHub repository's **Settings > Secrets and variables > Actions** and add these repository secrets:

- `DOCKERHUB_USERNAME`: Docker Hub username.
- `DOCKERHUB_TOKEN`: Docker Hub access token with permission to push images.

Add the repository variable `DOCKERHUB_IMAGE` with the Docker Hub image name, for example `your-dockerhub-user/pandoc-extra`.

The GitHub Actions workflow builds the image on pull requests targeting `main` without publishing it. Pushes to `main` publish the `latest` tag, and pushes of version tags such as `v1.0.0` publish the matching version tag.
