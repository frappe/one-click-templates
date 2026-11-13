---
title: Redis
description: Create a Redis server, read its password, and connect to it from your servers.
---

# Redis

This guide shows how to create a Redis server and connect to it. Redis is an in-memory key-value store. Use it as a cache, a queue, or a session store for your applications.

## Before you begin

- You need the **Owner**, **Admin**, or **Developer** role.
- The smallest plan for Redis has 0.5 vCPU, 512 MiB of memory, and 5 GiB of disk.

## 1. Create the server

1. Go to **Servers**. Click **New server**.
2. Under **Image**, select **Apps**. Under **App**, select **Redis**.
3. Under **Redis settings**, type a **Password**, or leave it blank to generate one.
4. Select a region and a plan. Click **Create server**.

## 2. Read the password

Sign in with [SSH](/servers/access) and read the settings file:

```bash
sudo cat /etc/one-click/app.env
```

| Setting | Value |
| --- | --- |
| `REDIS_PASSWORD` | The password that clients send with `AUTH`. |

If the login message shows `Setup is still running.`, wait one minute and sign in again.

## 3. Connect

Redis listens on port `6379` on every address. From another server in the same region, use the private IPv6 address of the Redis server:

```bash
redis-cli -h <private IPv6 address> -a '<password>' ping
```

The command returns `PONG`. In an application, use a URL such as `redis://:<password>@[<private IPv6 address>]:6379/0`.

To connect from outside the region, see [Connect to the service](/apps/#connect-to-the-service). If the firewall is on, allow TCP port `6379`.

## Change the password

1. Edit `/etc/redis/one-click.conf`. Change the `requirepass` line.
2. Run `sudo systemctl restart redis-server`.
3. Change `REDIS_PASSWORD` in `/etc/one-click/app.env`, so the file stays correct.

## What next

**[Apps](/apps/)**: first boot, passwords, and network access for every app.
