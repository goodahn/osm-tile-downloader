#!/bin/bash

# ==============================================================================
# 지도 타일 병렬 다운로드 스크립트 (최적화 버전)
# ==============================================================================

# --- 설정 변수 (명령줄 인자로 덮어쓸 수 있음) ---

# 1. 다운로드할 줌 레벨 범위
MIN_ZOOM=16
MAX_ZOOM=20

# 2. 타일을 다운로드 받고 싶은 영역 경계 (예시: 대전)
MIN_LON=127.3
MAX_LON=127.5
MIN_LAT=36.3
MAX_LAT=36.4

# 3. 타일 서버 URL 및 출력 폴더
TILE_SERVER_URL="http://localhost:28080/tile/{z}/{x}/{y}.png"
OUTPUT_DIR="./map_tiles"

# 4. 동시에 다운로드할 작업 수 (CPU 코어 수에 맞게 조절)
PARALLEL_JOBS=8


# --- 스크립트 본체 ---
echo "===== 지도 타일 다운로드를 시작합니다 ====="
echo "대상 줌 레벨: $MIN_ZOOM ~ $MAX_ZOOM"
echo "대상 지역 (경위도): $MIN_LON, $MIN_LAT ~ $MAX_LON, $MAX_LAT"
echo "다운로드 폴더: $OUTPUT_DIR"
echo "병렬 작업 수: $PARALLEL_JOBS"
echo "=========================================="

# 1. Python 스크립트로 다운로드할 URL과 파일 경로 목록 생성
echo "다운로드할 타일 URL 목록을 생성합니다..."
URL_LIST_FILE=$(mktemp) # 임시 파일 생성
python3 generate_urls.py \
    --min_zoom $MIN_ZOOM \
    --max_zoom $MAX_ZOOM \
    --bbox $MIN_LON $MIN_LAT $MAX_LON $MAX_LAT \
    --url_template "$TILE_SERVER_URL" \
    --output_dir "$OUTPUT_DIR" > "$URL_LIST_FILE"

TOTAL_FILES=$(wc -l < "$URL_LIST_FILE")
echo "총 ${TOTAL_FILES}개의 타일을 다운로드합니다."


# 2. xargs를 사용하여 병렬로 다운로드
echo "다운로드를 시작합니다 (병렬 작업: $PARALLEL_JOBS)..."
cat "$URL_LIST_FILE" | xargs -n 2 -P "$PARALLEL_JOBS" bash -c '
    URL="$0"
    OUTPUT_FILE="$1"
    
    # 파일이 존재하지 않을 경우에만 다운로드
    if [ ! -f "$OUTPUT_FILE" ]; then
        # 타일 저장 폴더 생성
        mkdir -p "$(dirname "$OUTPUT_FILE")"
        
        # wget으로 다운로드
        wget -q --tries=2 --timeout=5 -O "$OUTPUT_FILE" "$URL" || rm -f "$OUTPUT_FILE"
    fi
'

# 임시 파일 삭제
rm "$URL_LIST_FILE"

echo "===== 모든 다운로드가 완료되었습니다. ====="