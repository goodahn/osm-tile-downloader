# Setting up the server
echo "타일 서버 설정 및 실행"

# Change the below link if you want to download the map of other country
wget -c https://download.geofabrik.de/asia/south-korea-latest.osm.pbf
docker run --rm -p 28080:80 -v $(pwd)/south-korea-latest.osm.pbf:/data.osm.pbf -v openstreetmap-data:/var/lib/postgresql/12/main -d overv/openstreetmap-tile-server import
