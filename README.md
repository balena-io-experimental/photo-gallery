# balenablocks/photo-gallery

A blocks that allows you to display a photo slideshow on a webpage over a web server. Out of the box you can use Google Photo Albums, Dropbox Photo Album and Apple Photos. The images are downloaded automatically and auto updated in case of changes.

## Supported Albums

### Google Photos Albums

Go to [https://photos.google.com](https://photos.google.com) and select the album that you want to share.

Click in the share button, click in the `Create link` button and copy the the url.

### Dropbox Photo Albums

On the [dropbox](https://www.dropbox.com/home) website, go to the folder that contains the photos and click on `Share Folder` and then `Copy link`. This will the URL you will need to add to balenaCloud.

### Apple iCloud Photo Album

Create a photo album and copy the share url, similar to `https://www.icloud.com/sharedalbum/#ALBUM-ID`

### USB drive Photo Album

Place your photos on a USB stick and plug it into the Raspberry Pi. Each time all previous existing photos will be removed and replaced by the new ones.

- Set `GALLERY_URL` to `USBDRIVE` to use this mode.
- Make sure to update `CRON_SCHEDULE` accordingly or else image changes will only be picked up at reboot.

## Usage

Include this snippet in your `docker-compose.yml` file under 'services':

```yml
photos:
  image: bhcr.io/balenablocks/photo-gallery-<arch>/<version> # where <arch> is one of aarch64, armv7hf, rpi or amd64 and <version>(optional) is a specific version of this block
  privileged: true # required for UDEV to find plugged in peripherals such as a USB mouse
  restart: always
  ports:
    - "8888"
```

e.g For running on Raspberry Pi 3B+ which is `armv7hf` use `image:balenablocks/photo-gallery:armv7hf`

You can also set your `docker-compose.yml` to build a `Dockerfile.template` file, and use the build variable `%%BALENA_ARCH%%` so that the correct image is automatically built for your device.

`docker-compose.yml`

```yml
version: "2.1"
services:
  photos:
    privileged: true
    restart: always
    build: ./
    ports:
      - "8888"
```

`Dockerfile.template`

```dockerfile
FROM bh.cr/balenablocks/photo-gallery-%%BALENA_ARCH%%
```

### Supported Architectures

- `armv7hf`
- `rpi`
- `aarch64`
- `amd64`

## Setting up the photo album

- On balenaCloud, go to **Device variables D(x)** and add the following:

| ENV VAR                 | Description                                                                                        | Options                                     | Default        |
| ----------------------- | -------------------------------------------------------------------------------------------------- | ------------------------------------------- | -------------- |
| PORT                    | Web server port.                                                                                   |                                             | 8888           |
| GALLERY_URL             | Gallery URL for **google photos**, **dropbox images**, **apple photos** or **usb drive**.          |                                             |                |
| GALLERY_SLIDESHOW_DELAY | Slideshow delay in milliseconds                                                                    |                                             | 10000          |
| GALLERY_IMAGE_STYLE     | `Contain` shows the entire image on the screen. `Cover` zooms the image filling the entire screen. | contain, cover                              | cover          |
| GALLERY_EFFECT          | Transition effects                                                                                 | fade, horizontal, vertical, kenburns, false | fade           |
| CRON_SCHEDULE           | Cron scheduler to reload images to get changes                                                     |                                             | 0 */12 * * * |
| SHUFFLE_SLIDESHOW       | Shiffle images to display randomly                                                                 | true, false                                 | false          |
| RESIZE_WIDTH            | \* Resize image width or height (larger side) in pixels                                            |                                             | 1000px         |
| COMPRESS_QUALITY        | \* Image compression                                                                               | 0 - 100                                     | 90             |

    * Only available for iCloud photos

Note that after some performance tests on the Raspberry Pi 2 & 3, the combination of `GALLERY_IMAGE_STYLE = contain` and `GALLERY_EFFECT = fade or kenburns` can make the transition effects choppy.
