# ELK based dashboards for F5 WAFs
This is community supported repo providing ELK based dashboards for F5 WAFs.

## How does it work?
ELK stands for elasticsearch, logstash, and kibana. Logstash receives logs from the F5 WAF, normalizes them and stores them in the elasticsearch index. Kibana allows you to visualize and navigate through logs using purpose built dashboards.

## Requirements
The provided Kibana dashboards require a minimum version of 7.4.2. If you are using the provided [docker-compose.yaml](docker-compose.yaml) file, this version requirement is met.

## Installation Overview
It is assumed you will be running ELK using the Quick Start directions below. The template in "logstash/conf.d" will create a new logstash pipeline to ingest logs and store them in elasticsearch. If you use the supplied `docker-compose.yaml`, this template will be copied into the docker container instance for you. Once the WAF logs are being ingested into the index, you will need to import files from the [kibana](kibana/) folder to create all necessary objects including the index pattern, visualization and dashboards.

## Quick Start
### Deploying ELK Stack
Use docker-compose to deploy your own ELK stack.
```
$ docker-compose -f docker-compose.yaml up -d
```

---
**NOTE**

The ELK stack docker container will likely exceed the default host's virtual memory system limits. Use [these directions](https://www.elastic.co/guide/en/elasticsearch/reference/5.0/vm-max-map-count.html#vm-max-map-count) to increase this limit on the docker host machine. If you do not, the ELK container will continually restart itself and never fully initialize.

---

### Dashboards Installation
Import dashboards to kibana through UI (Kibana->Management->Saved Objects) or use API calls below.
```
KIBANA_URL=http://your.kibana:5601
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
The logstash log ingestion pipeline in this solution assumes that you have configured NGINX App Protect to use the `default` log format, which is essentially a comma-delimited scheme. If you are using a custom logging profile JSON file, be sure that the default format is being used. Also, ensure that the logging destination in the `app_protect_security_log` directive in your `nginx.conf` file is configured with the hostname or ip address of the logstash instance, and the correct TCP port (the default in this solution is 5144). Take a look to official docs for [examples](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#policy-configuration-overview). 

**NOTE**
The logstash listener in this solution is configured to listen for TCP syslog messages on a custom port (5144). If you have deployed NGINX App Protect on an SELinux protected system (such has Red Hat or CentOS), you will need to configure SELinux to allow remote syslog messages on a custom port. See the [configuration instructions](https://docs.nginx.com/nginx-app-protect/admin-guide/#syslog-to-custom-port) for an example of how to accomplish this.

### BIG-IP Configuration
BIG-IP logging profile must be configured to use "splunk" logging format.
```
# tmsh list security log profile LOG_TO_ELK

security log profile LOG_TO_ELK {
    application {
            ...omitted...
            remote-storage splunk
            servers {
                logstash.domain:logstash-port { }
            }
        }
    }
}
```
## Supported WAFs
* NGINX App Protect
* BIG-IP ASM, Advanced WAF
## Screenshots
### Overview Dashboard
![screenshot1](https://user-images.githubusercontent.com/23067500/72393114-c7c25080-36e6-11ea-81c4-655f4c936476.png)
![screenshot2](https://user-images.githubusercontent.com/23067500/72392972-4cf93580-36e6-11ea-8392-1b80d59b8276.png)
![screenshot3](https://user-images.githubusercontent.com/23067500/72392979-4ff42600-36e6-11ea-9cb9-22b8ba737de0.png)
### False Positives Dashboard
![screenshot1](https://user-images.githubusercontent.com/23067500/81446488-d6b68e00-912f-11ea-9f60-0821c2010e46.png)
![screenshot2](https://user-images.githubusercontent.com/23067500/81446490-d918e800-912f-11ea-9223-a3cf7818cdcf.png)
![screenshot3](https://user-images.githubusercontent.com/23067500/81446492-dae2ab80-912f-11ea-94a2-e99fd7423883.png)
