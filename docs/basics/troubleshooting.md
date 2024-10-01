# Troubleshooting

- If your setup isn't working, and you can not figure out the reason why, running
`podman compose down -v` will remove the relevant containers and volumes,
allowing you to run `podman compose up` again from a clean slate.
- You can run `./bootstrap.sh` again to check the setup and detected paths for your source code destination
- In extreme cases, clean everything: `podman system prune --all`
- If you start your stable containers (not the master) and it wants to install Nextcloud even if it is not the first start, you may have removed the configuration with the last `podman compose down` command. Try to use `podman compose stop` instead or give the stable setup named values yourself.

## Logs

- You can use `podman compose logs -f` to follow the logs of all containers
- You can use `podman compose logs -f nextcloud` to follow the logs of the Nextcloud container
