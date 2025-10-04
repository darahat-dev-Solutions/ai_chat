Great! 🎉 Since your setup involves **Laravel API with Docker deployment on EC2 and phpMyAdmin**, I’ll prepare a professional **README.md** documentation for your project.

I suggest naming it:

```
README_DEPLOY_LARAVEL_DOCKER.md
```

---

Here’s the content:

````markdown
# Laravel API Deployment with Docker on AWS EC2

## Project Overview

This project contains a Laravel API application deployed using Docker on an AWS EC2 instance. phpMyAdmin is also deployed in a separate container for database management. This setup ensures a clean, isolated environment for running Laravel and managing the database securely.

---

## Containers

| Container Name | Image                        | Ports     | Description             |
| -------------- | ---------------------------- | --------- | ----------------------- |
| laravel-api    | darahat42/laravel-api:latest | 80 → 80   | Laravel API application |
| phpmyadmin     | phpmyadmin/phpmyadmin        | 8081 → 80 | Database management UI  |

---

## Security Group Configuration (Inbound Rules)

| Type       | Protocol | Port | Source                             | Description                  |
| ---------- | -------- | ---- | ---------------------------------- | ---------------------------- |
| SSH        | TCP      | 22   | Your IP (e.g., 103.197.153.219/32) | Secure SSH access            |
| HTTP       | TCP      | 80   | 0.0.0.0/0                          | Laravel API public access    |
| HTTPS      | TCP      | 443  | 0.0.0.0/0                          | Web access (optional SSL)    |
| Custom TCP | TCP      | 8081 | Your IP (e.g., 103.197.153.219/32) | phpMyAdmin restricted access |

> **Note:** Always restrict SSH and phpMyAdmin access to your own IP for security.

---

## Docker Commands

### Check running containers

```bash
docker ps
```
````

### Stop and remove container

```bash
docker stop laravel-api
docker rm laravel-api
```

### Start Laravel container on port 80

```bash
docker run -d --name laravel-api -p 80:80 darahat42/laravel-api:latest
```

### Start phpMyAdmin container on port 8081

```bash
docker run -d --name phpmyadmin -p 8081:80 phpmyadmin/phpmyadmin
```

### Access container shell

```bash
docker exec -it laravel-api bash
```

---

## Laravel Setup Inside Container

### Directory Permissions

```bash
cd /var/www/html
mkdir -p bootstrap/cache storage/framework/{cache,sessions,views} storage/logs
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache storage/framework storage/logs
```

### Clear Caches

```bash
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear
```

### Database Configuration

- MySQL is used (not SQLite).
- `.env` example:

```dotenv
DB_CONNECTION=mysql
DB_HOST=172.17.0.1
DB_PORT=3306
DB_DATABASE=your_db
DB_USERNAME=your_user
DB_PASSWORD=your_pass

CACHE_DRIVER=file
APP_KEY=base64:YOUR_APP_KEY_HERE
```

---

## Access URLs

- **Laravel API:** `http://<EC2_PUBLIC_IP>/api/...`
- **phpMyAdmin:** `http://<EC2_PUBLIC_IP>:8081`

---

## Notes & Best Practices

- Always restrict SSH and phpMyAdmin access to specific IPs.
- Ensure `storage` and `bootstrap/cache` are writable by the web server user (`www-data`).
- Clear Laravel caches after any environment or container change.
- For production, consider using **Nginx reverse proxy** for clean URLs and SSL termination.

---

## Deployment via GitHub Actions

- CI/CD workflow builds Docker image, pushes to Docker Hub, and deploys to EC2.
- Automatically handles:

  - Pulling latest Docker image
  - Stopping old containers
  - Setting environment variables
  - Clearing Laravel caches
  - Setting proper permissions

---

**End of Documentation**

```

---

If you want, I can also **create a shorter “quick start” version** for new developers, which shows **commands and URLs only** for rapid deployment.

Do you want me to do that too?
```
