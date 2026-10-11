# Friendica Dev Container

This dev container provides a complete Friendica development environment using Docker Compose from the `.docker` folder.

## Quick Start

### Opening in VS Code

1. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Open the repository in VS Code
3. Click the **Dev Containers** button in the bottom-left corner
4. Select **Reopen in Container**

The container will start automatically and run the post-create setup.

## Services

- **PHP 8.2** - PHP-FPM with all Friendica dependencies (xdebug enabled)
- **Nginx** - Web server on port 8080
- **MariaDB** - Database server on port 3306
- **phpMyAdmin** - Database UI on port 8086
- **Redis** - Cache server

## Access Points

- **Friendica Application**: http://localhost:8080
- **phpMyAdmin**: http://localhost:8086
  - User: `root` / Password: `root` (or `friendica` / `friendica`)
- **MariaDB CLI**: `docker compose exec db mariadb -ufriendica -pfriendica friendica`

## Configuration

### Environment Variables

The container uses environment variables from `.docker/.dist.env`. To customize them:

1. Copy `.docker/.dist.env` to `.docker/.env.local`
2. Edit `.docker/.env.local` with your desired settings
3. Rebuild the dev container (Ctrl+Shift+P → "Dev Containers: Rebuild Container")

### PHP Configuration

PHP configuration is loaded from `.docker/php/php.ini`. You can modify this file and rebuild the container.

## Development Workflow

### Install Dependencies

```bash
composer install
```

### Run Database Migrations

```bash
bin/console autoinstall -f /tmp/autoinstall.config.php
```

### Access Database

```bash
mysql -h127.0.0.1 -ufriendica -pfriendica friendica
```

### View Logs

```bash
# PHP logs
docker compose logs -f php

# Nginx logs
docker compose logs -f nginx

# Database logs
docker compose logs -f db
```

## Debugging with Xdebug

Xdebug is pre-configured in the container. To enable debugging:

1. In VS Code, open the Run and Debug panel (Ctrl+Shift+D)
2. Select "Listen for Xdebug"
3. Click the green "Start Debugging" button
4. Set breakpoints in your code and reload the page

### Debug Configuration

Xdebug is configured with:
- Mode: `debug`
- Port: `9003`
- Client host: `host.docker.internal` (Docker Desktop) / resolved automatically for Linux

## Troubleshooting

### Container won't start

Rebuild the container:
```bash
Ctrl+Shift+P → "Dev Containers: Rebuild Container"
```

### Database connection issues

Ensure the database is healthy:
```bash
docker compose ps
```

If the database shows as unhealthy, check logs:
```bash
docker compose logs db
```

### Composer install fails

Clear the composer cache:
```bash
docker compose exec php composer clearcache
docker compose exec php composer install
```

### Port conflicts

If ports 8080, 8086, or 3306 are already in use, set custom ports in `.docker/.env.local`:
```bash
SERVER_PORT=8081
PHPMYADMIN_PORT=8087
MYSQL_PORT=3307
```

## File Structure

```
.devcontainer/
├── devcontainer.json          # Dev container configuration
├── docker-compose.yml         # Dev container compose overrides
└── README.md                  # This file

.docker/
├── compose.yaml               # Main Docker Compose configuration
├── .dist.env                  # Default environment variables
├── php/
│   ├── Dockerfile            # PHP-FPM Docker image
│   └── php.ini               # PHP configuration
├── nginx/
│   └── nginx.conf            # Nginx configuration
└── mariadb/
    └── 01-init.sh            # Database initialization script
```

## Additional Resources

- [Dev Containers Documentation](https://containers.dev/)
- [Friendica Repository](https://github.com/ne20002/friendica)
- [Docker Compose Reference](https://docs.docker.com/compose/)
