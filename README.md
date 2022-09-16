## Docker knife


Normally application images are tiny, distroless and hard to do any live debugging on issues.A image baked in with tools to debug any type of issues on demand


> Running local (if AMD64 - M1 mac) 

`docker run -d docker.io/stevengonsalvez/docker-knife:amd64`

> For ARM

`docker run -d docker.io/stevengonsalvez/docker-knife:latest`


> debugging

`docker exec -it <container> bash`


> SSH to container and a simple http server provisioned, to allow to run this in Azure webapps 