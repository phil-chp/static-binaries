# Static Binaries

> [!WARNING]
> I do not own any of these programs, please refer to the original repo for each of these, you can find a reference to each in the respective `build.sh` scripts.

## What?

Ever wanted to have a single binary at your disposal that you can run on any linux machine? (x86_64 exclusively for now)

This repo currently ships some pre-built binaries, though you shouldn't trust any ol' pre-built binaries that are served to you.

I made the building process as easy as possible so just build them yourself if you want to be sure.

## Why?

There's a million different solutions to these problem, though from a quick search I couldn't find anything that covered my needs:

- Open source
- Compatible with modern Docker
- POSIX-friendly
- Easy to scale

## How?

### How to build a binary

Just call

```bash
./run.sh
```

### How can I add a binary

Grab the installation process for said binary and the dependencies required for it.

```bash
mkdir <bin_name>
cd <bin_name>
vi build.sh # Put the installation process here
vi deps.txt # Put the dependencies here, one per line
```

> [!NOTE]
> The docker image uesd is Alpine Linux, so make sure to adapt your dependencies for `apk` (Alpine's package manager). If you're not happy with alpine, pacth the [Dockerfile](./Dockerfile)
>
> The `build.sh` process requires the final binary to be in `/out/$BIN_NAME`.

### How to contribute

Feel free, just send a pull request I'll review ASAP.

Please just test the build process before and dont send any binaries.
