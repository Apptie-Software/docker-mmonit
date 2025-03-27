# Dockerized [Monit](https://mmonit.com/monit/) by Apptie Software

## Summary

M/Monit is a web UI and aggregation utility meant to be used together with Monit

- [Monit website](https://mmonit.com/monit)
- [Our Dockerized Monit](https://github.com/Apptie-Software/docker-monit?tab=readme-ov-file)

>[!IMPORTANT]
> Pay attention to environment variables.
> It's easy to confuse `MMONIT...` (for M/Monit) and `MONIT...` (for Monit)

## Usage

### docker

```sh
docker create \
  --name=mmonit \
  -e MMONIT_PORT=8080 \
  -e MMONIT_DOMAIN= \
  -e MMONIT_URL="https://${MMONIT_DOMAIN}" \
  -e MMONIT_VERSION="4.3.4" \
  -e MMONIT_DATABASE_URL= \
  -e MMONIT_LICENSE_OWNER="you" \
  -e MMONIT_LICENSE_KEY="yours" \
  -e MONIT_USER="admin" \
  -e MONIT_PASS="changeme" \
  -e TZ=Europe/Kyiv \
  --expose 8080 \
  -v </path/to/conf>:/opt/mmonit-${MMONIT_VERSION}/conf \
  --restart unless-stopped \
  Apptie-Software/mmonit
```

### docker-compose

```yml
services:
  mmonit:
    image: Apptie-Software/mmonit
    container_name: mmonit
    environment:
      MMONIT_PORT: 8080
      MMONIT_DOMAIN:
      MMONIT_URL: "https://${MMONIT_DOMAIN}"
      MMONIT_VERSION: "4.3.4"
      MMONIT_DATABASE_URL:
      MMONIT_LICENSE_OWNER: "you"
      MMONIT_LICENSE_KEY: "yours"
      TZ: Europe/Kyiv
      MONIT_USER: "admin"
      MONIT_PASS: "changeme"
    volumes:
      - </path/to/conf>:/opt/mmonit-${MMONIT_VERSION}/conf
    expose:
      - 8080
    restart: unless-stopped
```

## Parameters

### Port

You can set a custom port with `MONIT_PORT`

>[!NOTE]
> Don't forget to put it in `--expose` or `expose:`

### Environment Variables (`-e` or `environment:`)

| Variable        | Function                                |
| ---        | --------                                |
| MMONIT_PORT=8080  | 8080 is the default port, you can set your own. |
| MMONIT_DOMAIN=  | domain/subdomain path of M/Monit |
| MMONIT_URL=  | full url on which M/Monit would be reached |
| MMONIT_VERSION=4.3.4  | 4.3.4 is the latest version at the moment of writing, you can set your own. |
| MMONIT_DATABASE_URL=  | full url for a database connection other than SQLite |
| MMONIT_LICENSE_OWNER=  | M/Monit license owner |
| MMONIT_LICENSE_KEY=  | M/Monit license key |
| TZ=UTC     | Specify a timezone to use EG UTC        |
| MONIT_USER | Username for logging into M/Monit    |
| MONIT_PASS | Password for logging into M/Monit    |

### Volume Mappings (-v)

| Volume  | Function                         |
| ------  | --------                         |
| /etc/monit/config | All the config files reside here |

## Setup

- If provided, Monit configuration is assembled from config files found in `<config>`.

- Otherwise, the configuration will be generated based on existing environment variables.

>[!IMPORTANT]
> `MMONIT_URL`, `MMONIT_USERNAME`, and `MMONIT_PASSWORD` are
> ***required*** to generate config files.

### `/etc/monit/config/httpd.cfg`

`NETWORK` and `NETMASK` are those of the container.

```cfg
set httpd port ${MONIT_PORT}
    allow localhost
    allow "::1"
    allow ${NETWORK}/${NETMASK}
    allow ${MMONIT_USERNAME}:${MMONIT_PASSWORD}
```

### `/etc/monit/config/mmonit.cfg`

```cfg
set monit ${MMONIT_URL}
```

## TODO

- search for the latest M/Monit version on the dist
