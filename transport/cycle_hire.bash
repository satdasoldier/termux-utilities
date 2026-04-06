#!/data/data/com.termux/files/usr/bin/bash

DEBUG=0

TFL_API_BASE="https://api.tfl.gov.uk"
TFL_API_URL_TEMPLATE="$TFL_API_BASE/BikePoint"

BIKE_POINTS_PREFIX="BikePoints_"

if [[ "$#" -le 0 ]]; then
	echo "Usage: cycle_hire.bash <bike_point_id_int1> <bike_point_id_int2> ... <bike_point_id_intN>"
	exit 1
fi

res="STATION NAME|BIKES AVAILABLE (EBIKES)|DOCKS AVAILABLE\n"

if [[ "$DEBUG" == "1" ]]; then
	echo "Args: $@"
fi

for bike_point_id in "$@"; do
	BIKE_POINT_ID="${BIKE_POINTS_PREFIX}${bike_point_id}"
	FINAL_URL="$TFL_API_URL_TEMPLATE/$BIKE_POINT_ID"

	if [[ "$DEBUG" == "1" ]]; then
		echo "Calling $FINAL_URL"
	fi

	result=$(curl -s -XGET $FINAL_URL)

	empty_docks=$(echo $result | jq -r '.additionalProperties[] | select(.key == "NbEmptyDocks") | .value')
	total_docks=$(echo $result | jq -r '.additionalProperties[] | select(.key == "NbDocks") | .value')
	num_ebikes=$(echo $result | jq -r '.additionalProperties[] | select(.key == "NbEBikes") | .value')
	num_bikes=$(echo $result | jq -r '.additionalProperties[] | select(.key == "NbBikes") | .value')
	common_name=$(echo $result | jq -r '.commonName')

	temp=$res

	res="$res$common_name|$num_bikes($num_ebikes)|$empty_docks/$total_docks\n"

	if [[ "$DEBUG" == "1" ]]; then
		echo -e "$res"
	fi
done

echo -e $res | column -t -s'|'


