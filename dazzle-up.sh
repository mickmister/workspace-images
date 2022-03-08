#! /bin/bash

set -eo pipefail

function removeIgnore {
    yq eval 'del(.ignore[])' dazzle.yaml --inplace
}

function buildCombination {
    combination=$1

    local exists="$(yq e '.combiner.combinations[] | select (.name=="'"$combination"'")' dazzle.yaml)"
    if [[ -z "$exists" ]]; then
        echo "Combination is not defined"
        exit 1
    fi

    refs=$(getRefs "$combination")
    requiredChunks=$(getChunks "$refs" | sort | uniq)   
    availableChunks=$(ls chunks)

    for c in $requiredChunks; do
        printf "$c"
    done

    # echo "Building required chunks $requiredChunks"

    for ac in $availableChunks; do
        if [[ ! "${requiredChunks[*]}" =~ "${ac}" ]]; then
            dazzle project ignore "$ac"
        fi
    done
}

function getRefs {
    local ref=$1
    echo "$ref"

    refs="$(yq e '.combiner.combinations[] | select (.name=="'"$ref"'") | .ref[]' dazzle.yaml)"
    if [[ -z "$refs" ]]; then
        return
    fi

    for ref in $refs; do
        getRefs "$ref"
    done
}

function getChunks {
    for ref in $@; do
        chunks=$(yq e '.combiner.combinations[] | select (.name=="'"$ref"'") | .chunks[]' dazzle.yaml)
        echo "$chunks"
    done
}

REPO=localhost:5000/dazzle

removeIgnore

if [ -n "${1}" ]; then
    buildCombination "$1"
fi

# First, build chunks without hashes
dazzle build $REPO -v --chunked-without-hash
# Second, build again, but with hashes
dazzle build $REPO -v

# Third, create combinations of chunks
if [[ -n "${1}" ]]; then
    dazzle combine $REPO --combination "$1" -v
else
    dazzle combine $REPO --all -v
fi

removeIgnore