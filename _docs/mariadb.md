---
title: MariaDB
description: Create a MariaDB server, read the admin password, and connect to the database.
---

# MariaDB

This guide shows how to create a MariaDB server and connect to it. MariaDB is a MySQL-compatible database server. Applications that use MySQL connect to it without changes.

## Before you begin

- You need the **Owner**, **Admin**, or **Developer** role.
- The smallest plan for MariaDB has 1 vCPU, 1 GiB of memory, and 10 GiB of disk.

## 1. Create the server

1. Go to **Servers**. Click **New server**.
2. Under **Image**, select **Apps**. Under **App**, select **MariaDB**.
3. Under **MariaDB settings**, fill in the settings:

   | Setting | Value |
   | --- | --- |
   | **Admin password** | The password of the `admin` user. Leave it blank to generate one. |
   | **Database** | Optional. A database to create, such as `shop`. Use lowercase letters, digits, and underscores. |

4. Select a region and a plan. Click **Create server**.

## 2. Read the password

Sign in with [SSH](/servers/access) and read the settings file:

```bash
sudo cat /etc/one-click/app.env
```

| Setting | Value |
| --- | --- |
| `MARIADB_USER` | `admin` |
| `MARIADB_PASSWORD` | The password of `admin`. |
| `MARIADB_DATABASE` | The database that first boot created. It is empty when you typed no name. |

The `admin` user has all privileges and connects from any address. The `root` user signs in only on the server, through the local socket: run `sudo mariadb`.

## 3. Connect

MariaDB listens on port `3306` on every address. From another server in the same region, use the private IPv6 address of the MariaDB server:

```bash
mariadb -h <private IPv6 address> -u admin -p
```

In an application, use a URL such as `mysql://admin:<password>@[<private IPv6 address>]:3306/<database>`.

To connect from outside the region, see [Connect to the service](/apps/#connect-to-the-service). If the firewall is on, allow TCP port `3306`.

## Add a user

Create a user with access to one database only. Run this on the server:

```bash
sudo mariadb -e "CREATE USER 'shop'@'%' IDENTIFIED BY '<password>'; GRANT ALL ON shop.* TO 'shop'@'%';"
```

## What next

**[Apps](/apps/)**: first boot, passwords, and network access for every app.
