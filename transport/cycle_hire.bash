#!/data/data/com.termux/files/usr/bin/bash


TFL_API_BASE="https://api.tfl.gov.uk"
TFL_API_URL_TEMPLATE="$TFL_API_BASE/BikePoint"

BIKE_POINTS=("BikePoints_215" "BikePoints_140" "BikePoints_96")

FINAL_URL="$TFL_API_URL_TEMPLATE/BikePoints_215"


curl -s -XGET $FINAL_URL

