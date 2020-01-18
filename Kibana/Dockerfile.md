Usage
=====
>`>` docker image build --tag veni-vidi-vici/kibana-7.3.1:windowsserver-1903 ./Kibana  
>`>` docker kill --signal="SIGINT" kibana  
>`>` docker container run -d --rm --name kibana veni-vidi-vici/kibana-7.3.1:windowsserver-1903  
>`>` docker container run -d --rm --name kibana -e ELASTICSEARCH_HOSTS='http://elasticsearch:9288' kibana veni-vidi-vici/kibana-7.3.1:windowsserver-1903  
>`>` docker container run -it --rm --name kibana veni-vidi-vici/kibana-7.3.1:windowsserver-1903 powershell  
>`>` docker exec kibana powershell -Command "Get-Content -Path c:\kibana\config\kibana.yml -Raw"  

**To open the homepage**
>`PS>` $ip = docker container inspect -f '{{ .NetworkSettings.Networks.nat.IPAddress }}' kibana; start "http://$($ip):5601"  

**To open the homepage (using Traefik)**
&nbsp;&nbsp;**Note:** Add this value to the host file in C:\Windows\System32\drivers\etc\hosts (in test and production environments, there is a real DNS system resolving the host names):  
&nbsp;&nbsp;&nbsp;&nbsp;127.0.0.1 kivana.dev.local  
>`PS>` Start-Process -FilePath "http://kibana.dev.local"  
>`PS>` Start-Process -FilePath "http://kibana.dev.local/app/kibana#/management/kibana"
