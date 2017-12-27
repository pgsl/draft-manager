# PGSL Draft Manager

## Getting Started

1. Install docker [https://www.docker.com](https://www.docker.com)
2. Configure Dnsmasq: [https://passingcuriosity.com/2013/dnsmasq-dev-osx/](https://passingcuriosity.com/2013/dnsmasq-dev-osx/)
3. Install the SSL certificate (docker/nginx/ssl/futurefund.dev.crt) to your keychain.
4. Copy and configure the `.env` file (this file is gitignored):

        cp docker/example.env .env
        vi .env

5. Run the following commands:

        docker-compose up
        docker-compose exec web rails db:create
        docker-compose exec web rails db:schema:load
        docker-compose exec web rails db:seed

6. Visit [https://draft-manager.futurefund.dev](https://draft-manager.futurefund.dev)

### Common Tasks

Open a command prompt to run `rails` commands:

```shell
docker-compose exec web bash
```

Or run the commands from your shell:

```shell
docker-compose exec web rails test
```

Connect to the development database (make sure mysql is not running locally):

```shell
mysql -u root -p -h 127.0.0.1
```

Using the debugger with byebug:

```shell
docker attach draftmanager_web_1
```

## Testing

This application does not have any tests.

