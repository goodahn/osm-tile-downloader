<div align="right">
  <b><a href="README.md">English</a></b> | <a href="README.ko.md">한국어</a>
</div>

# OSM Tile Downloader

This project provides a set of scripts to download map tiles from an OpenStreetMap tile server for a specified geographic area and zoom level range.

It is designed to work with a local tile server set up via Docker, but can be configured to use any tile server.

## Features

-   **Parallel Downloads:** Utilizes `xargs` to download multiple tiles concurrently
-   **Customizable Region:** Easily configure the geographic bounding box (latitude/longitude) and zoom levels
-   **Local Tile Server:** A setup script to run a local OpenStreetMap tile server using Docker
-   **Efficient:** Prevent duplicated download of tiles

## Prerequisites

Before you begin, ensure you have the following installed:

-   [Docker](https://www.docker.com/get-started)
-   wget
-   [Python 3](https://www.python.org/downloads/)

## Setup

1.  **Set up the local tile server (one-time setup):**

    This script will download the latest OpenStreetMap data for South Korea and start a Docker container to serve the map tiles locally.
    - If you want to download tiles of other country, you need to modify setup.sh and download the proper pbf file.
    ```bash
    bash setup.sh
    ```

    The server will be available at `http://localhost:28080`.

## Usage

1.  **Configure the download parameters:**

    Open `download_tiles.sh` and modify the following variables to define the desired map area and zoom levels:
    ```bash
    # 1. Zoom level range to download
    MIN_ZOOM=16
    MAX_ZOOM=20

    # 2. Bounding box for the area to download (Example: Daejeon, South Korea)
    ## To find the bounding box for your area of interest, you can use a tool like [bboxfinder.com](bboxfinder.com).
    MIN_LON=127.3
    MAX_LON=127.5
    MIN_LAT=36.3
    MAX_LAT=36.4

    # 3. Tile server URL and output directory
    ## You can also use public tile servers. For example, to use the standard OpenStreetMap server,
    ## change the URL to https://tile.openstreetmap.org/{z}/{x}/{y}.png.
    ## Note: Be sure to respect the tile usage policy of any public server you use.
    TILE_SERVER_URL="http://localhost:28080/tile/{z}/{x}/{y}.png"
    OUTPUT_DIR="./map_tiles"

    # 4. Number of parallel download jobs (adjust to your CPU core count)
    PARALLEL_JOBS=8
    ```

2.  **Run the download script:**

    ```bash
    bash download_tiles.sh
    ```

    The script will create a list of tile URLs and then download them into the `map_tiles` directory, organized by zoom level and coordinates (`{z}/{x}/{y}.png`).

## How It Works

The project consists of two main scripts:

-   `generate_urls.py`: A Python script that calculates the required tile coordinates (x, y) for the given bounding box and zoom levels. It outputs a list of tile URLs and their corresponding destination file paths.
-   `download_tiles.sh`: A shell script that orchestrates the download process. It calls `generate_urls.py` to get the list of tiles and then uses `wget` and `xargs` to perform a fast, parallel download.

## License

This project is licensed under the terms of the LICENSE file.
