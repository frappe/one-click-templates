---
title: Prometheus and Grafana
description: Create a monitoring server, open Grafana, and send the metrics of your other servers to it.
---

# Prometheus and Grafana

This guide shows how to create a monitoring server and send the metrics of your servers to it. Prometheus collects and stores the metrics. Grafana shows them in dashboards.

## Before you begin

- You need the **Owner**, **Admin**, or **Developer** role.
- The smallest plan for Prometheus and Grafana has 1 vCPU, 1 GiB of memory, and 10 GiB of disk.

## 1. Create the server

1. Go to **Servers**. Click **New server**.
2. Under **Image**, select **Apps**. Under **App**, select **Prometheus and Grafana**.
3. Under **Prometheus and Grafana settings**, fill in the settings:

   | Setting | Value |
   | --- | --- |
   | **Site name** | Required. The first part of the web address, such as `metrics`. |
   | **Prometheus password** | The password of the `admin` user of Prometheus. Leave it blank to generate one. |
   | **Push password** | The password that your other servers use to send metrics. It opens nothing else. Leave it blank to generate one. |
   | **Grafana password** | The password of the `admin` user of Grafana. Leave it blank to generate one. |

4. Select a region and a plan. Click **Create server**.

The regional proxy serves the server at `https://<site name>.<region domain>` with HTTPS. The server needs no public address for this.

## 2. Read the passwords

Sign in with [SSH](/servers/access) and read the settings file:

```bash
sudo cat /etc/one-click/app.env
```

| Setting | Value |
| --- | --- |
| `SITE_DOMAIN` | The web address of the server. |
| `GRAFANA_USER`, `GRAFANA_PASSWORD` | The Grafana sign-in. The user is `admin`. |
| `PROMETHEUS_USER`, `PROMETHEUS_PASSWORD` | The Prometheus sign-in. The user is `admin`. |
| `PUSH_USER`, `PUSH_PASSWORD` | The login that other servers use to send metrics. The user is `push`. |

## 3. Open Grafana and Prometheus

| Address | Opens | Sign in with |
| --- | --- | --- |
| `https://<site domain>/` | Grafana. Prometheus is already a data source. | `GRAFANA_USER` and `GRAFANA_PASSWORD` |
| `https://<site domain>/prometheus/` | The Prometheus web UI and API. | `PROMETHEUS_USER` and `PROMETHEUS_PASSWORD` |

## 4. Send metrics from a server

Run this command as `root` on each Ubuntu or Debian server that you want to monitor. Use the push password from step 2.

```bash
curl -fsSL https://<site domain>/connect.sh | sudo PUSH_PASSWORD='<push password>' bash
```

The script installs Grafana Alloy at a fixed version and checks its checksum. Alloy reads the CPU, memory, disk, and network metrics of the server every 15 seconds and sends them to Prometheus. Each server shows in Grafana by its hostname.

## Change a password

| Password | Do this |
| --- | --- |
| Grafana | Change it in Grafana: **Profile > Change password**. |
| Prometheus | Run `echo "admin:$(openssl passwd -6)" \| sudo tee /etc/nginx/one-click/prometheus.htpasswd`, then `sudo systemctl reload nginx`. |
| Push | Run `echo "push:$(openssl passwd -6)" \| sudo tee /etc/nginx/one-click/push.htpasswd`, then `sudo systemctl reload nginx`. |

Change the value in `/etc/one-click/app.env` too, so the file stays correct. After a change of the push password, run the script of step 4 again on each server.

## What next

**[Apps](/apps/)**: first boot, passwords, and network access for every app.
