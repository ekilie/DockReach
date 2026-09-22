<h1>
  <img src="/assets/extension-icon.svg" alt="Project Logo" width="100" height="100" style="vertical-align: middle; margin-right: 10px;">
  DockReach
</h1>

A Docker Desktop extension for managing and monitoring remote Docker environments over SSH.

## Features

- Docker Desktop-like experience for remote hosts (containers, images, volumes, networks)
- SSH tunnel management for remote connections
- Dashboard with resource stats and real-time updates
- Container log viewer with Compose grouping
- Persistent multi-environment settings with quick switching

## Components

This project was scaffolded with the `docker extension init` command using a Go backend and a React frontend.

The extension consists of two main parts:

1. **Backend (Go)**
    - Creates and manages persistent SSH tunnels to remote hosts
    - Proxies Docker CLI commands to the remote daemon over the tunnel
    - Exposes a local API over a Unix socket for the UI

2. **Frontend (React / TypeScript)**
    - Dashboard, Containers, Images, Volumes, Networks, and Environments views
    - Real-time updates with auto-refresh controls
    - Built with Material UI and recharts

Note: This started as an experimental project exploring Docker Desktop extension development and LLM-assisted coding. Modularity and separation of concerns were not the initial priority.

## SSH Authentication and Security Notes

- Your local `~/.ssh` directory is mounted read-only (`~/.ssh:/root/.ssh:ro`) into the extension VM service
- The backend installs its own SSH client (`openssh-client`) and connects from inside the backend container using your mounted keys
- Connections are opened with the configured username and hostname
- All Docker commands run on the remote host through the SSH tunnel
- No external API calls are made
- The codebase is open source so you can audit security practices before use

## Getting Started

1. Build and install the extension:

   ```sh
   make install-extension
   ```

   Or install a published image from Docker Hub.

2. Open Docker Desktop and go to the DockReach tab.
3. Add your remote environments in the Environments page (hostname + username, backed by your SSH keys/config).
4. Select an environment to connect and start managing the remote daemon.

Other useful targets:

```sh
make build-extension
make update-extension
make validate-extension
make debug-ui
```

## Screenshots

Assets in `assets/` cover dashboard, containers, Compose logs, images, volumes, networks, environments, and connection states.

## Contributing

Contributions are welcome. Open an issue or pull request with a clear description of the change, steps to reproduce (for bugs), and any relevant logs.

## Design

- Extension icon created with Midjourney.
- Material UI (MUI) is used per the Docker Extensions design guidelines. See the [Docker Extensions SDK design docs](https://docs.docker.com/extensions/extensions-sdk/design/#step-one-choose-your-framework).

## Warning

Use at your own risk. Review the code and understand the permissions and security implications before granting access to remote hosts.

## License

This project is licensed under the MIT License. See `LICENSE` for details.
