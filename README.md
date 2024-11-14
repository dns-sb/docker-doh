# Docker Image for DNS Over HTTPS Service

## DNS.SB DOH Server

```bash
docker run -itd --name doh-server \
    -p 8053:8053 \
    -e UPSTREAM_DNS_SERVER=udp:185.222.222.222:53 \
ghcr.io/dns-sb/docker-doh
```

## Docker configuration:

```yaml
services:
  doh-server:
    image: ghcr.io/dns-sb/docker-doh:latest
    container_name: doh-server
    #volumes:
      # Uncomment the following line to use a custom configuration file, make sure you have the file in the same directory as the docker-compose.yml first, chgange the path to the file if needed. Configuration file can be found here: https://github.com/dns-sb/docker-doh/blob/master/server-custom/doh-server.conf
      #- ./doh-server.conf:/server-custom/doh-server.conf
    ports:
      - 8053:8053
    #environment:
      #DEBUG: "0"
      # Upstream DNS server: proto:host:port
      # We are using DNS.SB servers as default,
      # Here is the list of addresses: https://dns.sb/guide/
      #UPSTREAM_DNS_SERVER: "udp:185.222.222.222:53"
      #DOH_HTTP_PREFIX: "/dns-query"
      #DOH_SERVER_LISTEN: ":8053"
      #DOH_SERVER_TIMEOUT: "10"
      #DOH_SERVER_TRIES: "3"
      #DOH_SERVER_VERBOSE: "false"
    healthcheck:
      test: ["CMD", "curl", "-fsS", "http://127.0.0.1:8053/dns-query?name=example.com&type=A"]
      interval: 30s
      timeout: 5s
      retries: 3
    restart: always

  watchtower:
    container_name: watchtower
    image: containrrr/watchtower:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_POLL_INTERVAL=86400
    restart: always
```

## Credits
- DOH Server: https://github.com/m13253/dns-over-https
- docker-doh: https://github.com/satishweb/docker-doh