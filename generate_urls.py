# generate_urls.py
import math
import os
import argparse

def lonlat_to_tile_coords(lon, lat, zoom):
    """경위도를 타일 좌표(x, y)로 변환합니다."""
    n = 2.0 ** zoom
    xtile = int(n * ((lon + 180.0) / 360.0))
    ytile = int(n * (1.0 - math.log(math.tan(math.radians(lat)) + (1.0 / math.cos(math.radians(lat)))) / math.pi) / 2.0)
    return xtile, ytile

def main():
    parser = argparse.ArgumentParser(description="Generate tile URLs for a given bounding box and zoom levels.")
    parser.add_argument("--min_zoom", type=int, required=True, help="Minimum zoom level")
    parser.add_argument("--max_zoom", type=int, required=True, help="Maximum zoom level")
    parser.add_argument("--bbox", type=float, nargs=4, required=True, metavar=('MIN_LON', 'MIN_LAT', 'MAX_LON', 'MAX_LAT'), help="Bounding box")
    parser.add_argument("--url_template", type=str, default="http://localhost:28080/tile/{z}/{x}/{y}.png", help="Tile server URL template")
    parser.add_argument("--output_dir", type=str, default="./map_tiles", help="Output directory for tiles")

    args = parser.parse_args()

    min_lon, min_lat, max_lon, max_lat = args.bbox

    os.makedirs(args.output_dir, exist_ok=True)
    
    for z in range(args.min_zoom, args.max_zoom + 1):
        x_min, y_max = lonlat_to_tile_coords(min_lon, min_lat, z)
        x_max, y_min = lonlat_to_tile_coords(max_lon, max_lat, z)

        for x in range(x_min, x_max + 1):
            for y in range(y_min, y_max + 1):
                # URL과 저장 경로를 공백으로 구분하여 출력
                url = args.url_template.format(z=z, x=x, y=y)
                output_path = f"{args.output_dir}/{z}/{x}/{y}.png"
                print(f"{url} {output_path}")

if __name__ == "__main__":
    main()