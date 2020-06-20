# ELK based dashboards for F5 WAFs
This is community supported repo providing ELK based dashboards for F5 WAFs.
## How it works?
ELK stands for elasticsearch, logstash, and kibana. Logstash receives logs from F5 WAF normalizes them and stores in elasticsearch index. Kibana allows to visualize and navigate through logs using purpose built dashboards.
## Requirements
The provided Kibana dashboards require a minimum version of 7.4.2. If you are using the provided [docker-compose.yaml](docker-compose.yaml) file, this version requirement is met.
## Installation
It is assumed you have ELK stack up and running. Use template from "logstash/conf.d" to create a new logstash pipeline to injest logs and store them in elasticsearch. Once logs are in index import files from "kibana" folder to create all necessary objects including index pattern, visualization and dashboards.
## Quick Start
### Deploying ELK Stack
Use docker-compose to deploy your own ELK stack.
```
$ docker-compose -f docker-compose.yaml up -d
```
### Dashboards Installation
Import dashboards to kibana through UI (Kibana->Management->Saved Objects) or use API calls below.
```
KIBANA_URL=https://your.kibana:5601
jq -s . kibana/overview-dashboard.ndjson | jq '{"objects": . }' | \
curl -k --location --request POST "$KIBANA_URL/api/kibana/dashboards/import" \
    --header 'kbn-xsrf: true' \
    --header 'Content-Type: text/plain' -d @- \
    | jq

jq -s . kibana/false-positives-dashboards.ndjson | jq '{"objects": . }' | \
curl -k --location --request POST "$KIBANA_URL/api/kibana/dashboards/import" \
    --header 'kbn-xsrf: true' \
    --header 'Content-Type: text/plain' -d @- \
    | jq
```
### NGINX App Protect Configuration
NGINX App Protect doesn't require any special logging configuration besides logging destination should point to the logstash instance. Take a look to official docs for [examples](https://docs.nginx.com/nginx-app-protect/admin-guide/#centos-7-4-installation)
## Supported WAFs
* NGINX App Protect
## Screenshots
### Overview Dashboard
![screenshot1](https://user-images.githubusercontent.com/23067500/72393114-c7c25080-36e6-11ea-81c4-655f4c936476.png)
![screenshot2](https://user-images.githubusercontent.com/23067500/72392972-4cf93580-36e6-11ea-8392-1b80d59b8276.png)
![screenshot3](https://user-images.githubusercontent.com/23067500/72392979-4ff42600-36e6-11ea-9cb9-22b8ba737de0.png)
### False Positives Dashboard
![screenshot1](https://user-images.githubusercontent.com/23067500/81446488-d6b68e00-912f-11ea-9f60-0821c2010e46.png)
![screenshot2](https://user-images.githubusercontent.com/23067500/81446490-d918e800-912f-11ea-9223-a3cf7818cdcf.png)
![screenshot3](https://user-images.githubusercontent.com/23067500/81446492-dae2ab80-912f-11ea-94a2-e99fd7423883.png)
