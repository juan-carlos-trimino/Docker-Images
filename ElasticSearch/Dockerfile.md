Usage
=====
>`>` docker container run -it --rm -p 9200:9200 -p 9300:9300 -v c:\docker-volumes\elasticsearch\data:c:\data veni-vidi-vici/elasticsearch-7.3.1:windowsserver cmd  
>`>` docker container run -it --rm -p 9200:9200 -p 9300:9300  veni-vidi-vici/elasticsearch-7.3.1:windowsserver cmd

**To test if Elasticsearch is running, send an HTTP request to port 9200 on localhost**
>`>` curl -X GET http://localhost:9200/  
>`>` curl localhost:9200/_nodes/stats/process?pretty  
>`PS>` $ip = docker container inspect -f '{{ .NetworkSettings.Networks.nat.IPAddress }}' elasticsearch; iwr -Uri http://$($ip):9200  
>`PS>` Invoke-RestMethod -Uri http://localhost:9200

**To open the homepage (with Traefik)**  
&nbsp;&nbsp;**Note:** Add this value to the host file in **C:\Windows\System32\drivers\etc\hosts** (in test and production environments, there is a real DNS system resolving the host names):  
&nbsp;&nbsp;&nbsp;&nbsp;127.0.0.1 elasticsearch.dev.local  

>`PS>` Start-Process -FilePath "http://elasticsearch.dev.local"
