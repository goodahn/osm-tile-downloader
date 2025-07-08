# ----------------------------------
#      DOWNLOAD CONFIGURATION
# ----------------------------------

# Zoom level range
MIN_ZOOM=16
MAX_ZOOM=20

# Bounding box for Daejeon, South Korea
MIN_LON=127.3
MAX_LON=127.5
MIN_LAT=36.3
MAX_LAT=36.4

# Tile server URL and output
TILE_SERVER_URL="http://localhost:28080/tile/{z}/{x}/{y}.png"
OUTPUT_DIR="./map_tiles"

# Number of parallel jobs
PARALLEL_JOBS=8