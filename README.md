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

## Docker Compose Configuration

The `docker-compose.yml` file defines the following services:

### 1. Flask App (`flask-app`)
- **Build Context**: The current directory (`.`).
- **Container Name**: `flask-app`.
- **Exposed Port**: Maps port `5000` in the container to `5001` on the host machine.
- **Environment Variables**:
  - `MYSQL_HOST`: Hostname of the MySQL service (`mysql`).
  - `MYSQL_USER`: MySQL username (`root`).
  - `MYSQL_PASSWORD`: MySQL password (`root`).
  - `MYSQL_DB`: Database name (`todo_app`).
- **Depends On**: Starts only after the MySQL service is healthy.
- **Networks**: Part of the `two-tier` network for communication with MySQL.

### 2. MySQL (`mysql`)
- **Image**: Uses the official `mysql:8.0` image.
- **Container Name**: `mysql`.
- **Exposed Port**: Maps port `3306` in the container to `3306` on the host machine.
- **Environment Variables**:
  - `MYSQL_ROOT_PASSWORD`: Root password for MySQL (`root`).
  - `MYSQL_DATABASE`: Name of the database (`todo_app`).
- **Volumes**: Data is persisted using the `mysql-data` volume.
- **Health Check**: Ensures the MySQL service is healthy before the Flask app starts.
  - **Command**: Uses `mysqladmin` to check the connection.
  - **Interval**: 10 seconds.
  - **Retries**: 5 attempts.
  - **Start Period**: 30 seconds delay before the first check.

### Volumes
- `mysql-data`: Stores the MySQL database files to ensure data persistence.

### Networks
- `two-tier`: A custom bridge network for communication between the Flask app and the MySQL database.

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

### Step 5: Persistent Data

The MySQL database data is stored in the `mysql-data` volume. This ensures that data is not lost when the container is stopped or removed.

## Troubleshooting

- **MySQL Service Not Starting**:
  - Check the MySQL logs using:
    ```bash
    docker logs mysql
    ```

- **Flask App Not Connecting to MySQL**:
  - Ensure the environment variables in `docker-compose.yml` are correctly set.
  - Verify the `MYSQL_HOST` matches the name of the MySQL service (`mysql`).

- **Network Issues**:
  - Ensure both services are part of the same network (`two-tier`).

## License

This project is open-source and available under the [MIT License](LICENSE).


