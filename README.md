# Docker Compose Setup for Flask Application with MySQL

This project sets up a Flask application with a MySQL database using Docker Compose. The Flask app interacts with the database to manage a simple to-do application.

## Prerequisites

Ensure you have the following installed on your system:
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## Project Structure

```
.
├── Dockerfile                # Used to build the Flask app image
├── docker-compose.yml        # Defines the services, networks, and volumes
├── app/                      # Directory containing the Flask application code
├── requirements.txt          # Python dependencies for the Flask app
```

## Services

The `docker-compose.yml` file defines the following services:

### 1. Flask App (`flask-app`)
- **Build Context**: The current directory (`.`).
- **Exposed Port**: Maps port `5000` in the container to `5001` on the host machine.
- **Environment Variables**:
  - `MYSQL_HOST`: Hostname of the MySQL service (`mysql`).
  - `MYSQL_USER`: MySQL username (`root`).
  - `MYSQL_PASSWORD`: MySQL password (`root`).
  - `MYSQL_DB`: Database name (`todo_app`).
- **Depends On**: Starts only after the MySQL service is healthy.

### 2. MySQL (`mysql`)
- **Image**: Uses the official `mysql:8.0` image.
- **Exposed Port**: Maps port `3306` in the container to `3306` on the host machine.
- **Environment Variables**:
  - `MYSQL_ROOT_PASSWORD`: Root password for MySQL (`root`).
  - `MYSQL_DATABASE`: Name of the database (`todo_app`).
- **Volumes**: Data is persisted using the `mysql-data` volume.
- **Health Check**: Ensures the MySQL service is healthy before the Flask app starts.

## Networks

A custom bridge network named `two-tier` is used for communication between the Flask app and the MySQL database.

## Volumes

- `mysql-data`: Stores the MySQL database files to ensure data persistence.

## Usage

### Step 1: Build and Start the Services

Run the following command to build the images and start the services:
```bash
docker-compose up --build
```

### Step 2: Access the Flask Application

Once the services are up, the Flask application will be accessible at:
```
http://localhost:5001
```

### Step 3: Verify MySQL Service

You can connect to the MySQL service using any MySQL client with the following details:
- **Host**: `localhost`
- **Port**: `3306`
- **Username**: `root`
- **Password**: `root`
- **Database**: `todo_app`

### Step 4: Stop the Services

To stop the services, press `Ctrl+C` in the terminal or run:
```bash
docker-compose down
```

## Deploying LAMP Stack with Docker

To set up a LAMP environment and deploy a PHP application, use the following Dockerfile and docker-compose configuration:

### Dockerfile
```dockerfile
# Use Ubuntu as base image
FROM ubuntu:22.04

# Install Apache, MySQL client, PHP, and necessary extensions
RUN apt update && apt install -y \
    apache2 \
    mysql-client \
    php \
    libapache2-mod-php \
    php-mysql \
    && apt clean

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Copy PHP application files (ensure index.php exists locally)
COPY index.php /var/www/html/

# Expose HTTP port
EXPOSE 80

# Start Apache service
CMD ["apache2ctl", "-D", "FOREGROUND"]
```

### docker-compose.yml
```yaml
version: '3.9'

services:
  lamp:
    build: .
    container_name: lamp-server
    ports:
      - "8080:80"
    volumes:
      - ./index.php:/var/www/html/index.php
    networks:
      - lamp-network

networks:
  lamp-network:
    driver: bridge
```

### Deploy PHP Application
1. Create an `index.php` file with the following content:
   ```php
   <?php
   echo "Welcome to your LAMP server on Docker!";
   phpinfo();
   ?>
   ```

2. Build and start the LAMP stack:
   ```bash
   docker-compose up --build
   ```

3. Access the application in your browser at:
   ```
   http://localhost:8080
   ```

## Troubleshooting

- If the MySQL service is not starting correctly, check the logs:
  ```bash
  docker logs mysql
  ```
- If the Flask app is not connecting to the database, ensure the environment variables are correctly set in the `docker-compose.yml` file.

## License

This project is open-source and available under the [MIT License](LICENSE).


