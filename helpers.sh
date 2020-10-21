ndjson2json () {
    jq  '. | if .attributes.fields then .attributes.fields|=fromjson else . end
              | if .attributes.visState then .attributes.visState|=fromjson else . end
              | if .attributes.kibanaSavedObjectMeta.searchSourceJSON then .attributes.kibanaSavedObjectMeta.searchSourceJSON|=fromjson else . end
              | if .attributes.panelsJSON then .attributes.panelsJSON|=fromjson else . end'
}
json2ndjson () {
    jq -c  '. | if .attributes.fields then .attributes.fields|=tojson else . end
              | if .attributes.visState then .attributes.visState|=tojson else . end
              | if .attributes.kibanaSavedObjectMeta.searchSourceJSON then .attributes.kibanaSavedObjectMeta.searchSourceJSON|=tojson else . end
              | if .attributes.panelsJSON then .attributes.panelsJSON|=tojson else . end'
}
