# Kibana dashboards for F5 App Protect WAF
This is community supported repo to integrate all kinds of F5 WAF flavours to ELK stack for visualization purposes.
Intergration includes two parts. Custom logstash pipeline to injest, normalize and send WAF logs to elasticsearch. Pre-defined kibana dashboards to visualize WAF activity. Elasticsearch configuration is not affected.
Therefore in order to get this all working you need:
* Have ELK stack up and running
* Create custom logstash pipeline from template in "logstash/conf.d" folder
* Import dashboards from "kibana" folder to kibana
* Setup F5 WAF to send logs to logstash
## Supported WAFs
* NGINX App Protect
## Dashboards Installation
In case if you have ELK stack up and running  import dashboards to kibana through UI or API calls.
```
KIBANA_URL=https://your.kibana:5601
jq -s . kibana/overview-dashboard.ndjson | jq '{"objects": . }' | \
curl -k --location --request POST "$KIBANA_URL/_plugin/kibana/api/kibana/dashboards/import" \
    --header 'kbn-xsrf: true' \
    --header 'Content-Type: text/plain' -d @- \
    | jq

jq -s . kibana/false-positives-dashboards.ndjson | jq '{"objects": . }' | \
curl -k --location --request POST "$KIBANA_URL/_plugin/kibana/api/kibana/dashboards/import" \
    --header 'kbn-xsrf: true' \
    --header 'Content-Type: text/plain' -d @- \
    | jq
```
Otherwise you can deploy ELK stack  using docker-compose tool and then import dashboards.
```
docker-compose -f docker-compose.yaml up
```
## NGINX App protect configuration
NGINX App Protect doesn't require any special logging configuration besides logging destination should point to logstash instance. Take a look to official docs for [samples](https://docs.nginx.com/nginx-app-protect/admin-guide/#centos-7-4-installation)
## Screenshots
### Overview Dashboard
![screenshot1](https://user-images.githubusercontent.com/23067500/72393114-c7c25080-36e6-11ea-81c4-655f4c936476.png)
![screenshot2](https://user-images.githubusercontent.com/23067500/72392972-4cf93580-36e6-11ea-8392-1b80d59b8276.png)
![screenshot3](https://user-images.githubusercontent.com/23067500/72392979-4ff42600-36e6-11ea-9cb9-22b8ba737de0.png)
### False Positives Dashboard
![screenshot1](https://user-images.githubusercontent.com/23067500/81446488-d6b68e00-912f-11ea-9f60-0821c2010e46.png)
![screenshot2](https://user-images.githubusercontent.com/23067500/81446490-d918e800-912f-11ea-9223-a3cf7818cdcf.png)
![screenshot3](https://user-images.githubusercontent.com/23067500/81446492-dae2ab80-912f-11ea-94a2-e99fd7423883.png)
