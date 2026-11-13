---
title: Apps
description: What an app is, which apps you can create, and how to connect to an app server.
---

# Apps

An app is a server that starts with one service installed and set up, such as Redis or MariaDB. You select the app, answer a few settings, and pick a plan. The server sets up the service at first boot.

## Choose an app

| App | Service | Ports | Guide |
| --- | --- | --- | --- |
| **Redis** | An in-memory key-value store | `6379` | [Redis](/apps/redis) |
| **MariaDB** | A MySQL-compatible database server | `3306` | [MariaDB](/apps/mariadb) |
| **Prometheus and Grafana** | Metrics collection and dashboards, at a web address | `80`, `3000` | [Prometheus and Grafana](/apps/prometheus-and-grafana) |

Each region has its own app images. The **New server** page shows the apps of the region that you select.

## Create an app server

1. Go to **Servers**. Click **New server**.
2. Under **Image**, select **Apps**.
3. Under **App**, select the app.
4. Fill in the **settings** section of the app. Leave a password blank, and the server generates one.
5. Select a plan. The page shows only the plans that are large enough for the app.
6. Click **Create server**.

The other steps are the same as for any server. See [Create a server](/servers/create).

The page of an app server shows **Getting started**. It opens the guide of the app.

## First boot

The server sets up the service once, at first boot, after the server is `Active`. Sign in with SSH to see the state. The login message shows one of these lines:

| Message | Meaning |
| --- | --- |
| `Setup is finished.` | The service runs. Its settings are in `/etc/one-click/app.env`. |
| `Setup is still running.` | Wait. Follow the progress with `tail -f /var/log/cloud-init-output.log`. |

## Read the passwords

The server keeps every setting that you need to connect, including the generated passwords, in `/etc/one-click/app.env`. Only `root` can read this file. The passwords do not leave the server, and the console does not show them.

```bash
sudo cat /etc/one-click/app.env
```

## Connect to the service

Frappe Cloud does not open a port for an app server, and it does not give it a web address, unless the app asks for a site name.

| Connect from | Do this |
| --- | --- |
| Another server in the same region | Use the private IPv6 address of the app server. The private network allows all traffic. |
| Your computer, through the VPN | Turn on [WireGuard VPN](/servers/wireguard), then use the private IPv6 address. |
| The internet | Attach a [public address](/servers/networking#attach-a-public-address). If the firewall is on, add a rule for the port of the service. |

::: warning
A public address exposes the service to the internet. The service always requires a password, but limit the firewall rule to the addresses of your clients.
:::

## After creation

An app server is a normal Ubuntu server. You can resize it, take snapshots, and change its firewall. You update the service yourself, as on any Ubuntu server.

## See also

- [Create a server](/servers/create)
- [Images](/servers/images)
- [Networking and firewall](/servers/networking)
- [Connect with SSH](/servers/access)
