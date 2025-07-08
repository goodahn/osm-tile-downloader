<div align="right">
  <a href="README.md">English</a> | <b><a href="README.ko.md">한국어</a></b>
</div>

# OSM 타일 다운로더

이 프로젝트는 지정된 지리적 영역과 줌 레벨 범위에 대해 OpenStreetMap 타일 서버에서 지도 타일을 다운로드하는 스크립트 모음을 제공합니다.

Docker를 통해 설정된 로컬 타일 서버와 함께 작동하도록 설계되었지만 모든 타일 서버를 사용하도록 구성할 수 있습니다.

## 주요 기능

-   **병렬 다운로드:** `xargs`를 활용하여 병렬 다운로드
-   **사용자 정의 지역:** 다운로드할 지리적 경계 상자(위도/경도) 및 줌 레벨 구성
-   **로컬 타일 서버:** Docker를 사용하여 로컬 OpenStreetMap 타일 서버를 실행
-   **효율성:** 중복 다운로드 제거

## 요구 사항

시작하기 전에 다음이 설치되어 있는지 확인하십시오.

-   [Docker](https://www.docker.com/get-started)
-   wget
-   [Python 3](https://www.python.org/downloads/)

## 설정

1.  **로컬 타일 서버 설정 (최초 1회):**

    이 스크립트는 대한민국의 최신 OpenStreetMap 데이터를 다운로드하고 지도 타일을 로컬에서 제공하는 Docker 컨테이너를 시작합니다.

    ```bash
    bash setup.sh
    ```

    서버는 `http://localhost:28080`에서 사용할 수 있습니다.

## 사용법

1.  **다운로드 매개변수 구성:**

    `download_tiles.sh` 파일을 열고 다음 변수를 수정하여 원하는 지도 영역과 줌 레벨을 정의합니다.

    ```bash
    # 1. 다운로드할 줌 레벨 범위
    MIN_ZOOM=16
    MAX_ZOOM=20

    # 2. 다운로드할 영역의 경계 상자 (예: 대한민국 대전)
    MIN_LON=127.3
    MAX_LON=127.5
    MIN_LAT=36.3
    MAX_LAT=36.4

    # 3. 타일 서버 URL 및 출력 디렉토리
    TILE_SERVER_URL="http://localhost:28080/tile/{z}/{x}/{y}.png"
    OUTPUT_DIR="./map_tiles"

    # 4. 병렬 다운로드 작업 수 (CPU 코어 수에 맞게 조정)
    PARALLEL_JOBS=8
    ```

2.  **다운로드 스크립트 실행:**

    ```bash
    bash download_tiles.sh
    ```

    스크립트는 타일 URL 목록을 생성한 다음 `map_tiles` 디렉토리에 줌 레벨과 좌표(`{z}/{x}/{y}.png`)별로 정리하여 다운로드합니다.

## 작동 방식

이 프로젝트는 두 가지 주요 스크립트로 구성됩니다.

-   `generate_urls.py`: 주어진 경계 상자와 줌 레벨에 필요한 타일 좌표(x, y)를 계산하는 Python 스크립트입니다. 타일 URL 목록과 해당 대상 파일 경로를 출력합니다.
-   `download_tiles.sh`: 다운로드 프로세스를 총괄하는 셸 스크립트입니다. `generate_urls.py`를 호출하여 타일 목록을 가져온 다음 `wget` 및 `xargs`를 사용하여 빠르고 병렬적인 다운로드를 수행합니다.

## 라이선스

이 프로젝트는 LICENSE 파일의 조건에 따라 라이선스가 부여됩니다.
