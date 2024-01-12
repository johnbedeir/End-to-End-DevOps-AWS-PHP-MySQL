# End to End DevOps Project - PHP & MySQL

This project demonstrates an end-to-end setup for a PHP and MySQL application, leveraging Apache2 as the web server. Follow these instructions to run the application locally on your Linux machine.

## Prerequisites

Before you begin, ensure you have the following installed on your Linux machine:

- Apache2
- PHP 8.2
- MySQL
- Composer

## 1. Running the Application Locally

### Step 1: Install Composer

Download and install Composer globally:

```bash
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
```

### Step 2: Initialize Composer

Navigate to your project directory and initialize Composer:

```bash
cd task-management-system
composer init
```

### Step 3: Install Dependencies

Install the necessary PHP packages:

```bash
composer install
composer require vlucas/phpdotenv
```

### Step 4: Install Apache

Install Apache2:

```bash
sudo apt install apache2
```

### Step 5: Install PHP with MySQL Support

Install PHP 8.2 along with the required modules:

```bash
sudo apt-get install php8.2 php8.2-mysql php8.2-cli php8.2-common
sudo apt-get install php-mysql
sudo a2enmod php8.2
sudo systemctl restart apache2
```

## Running the Application

After completing the setup, place your PHP project files in the appropriate Apache directory (commonly `/var/www/html`). Then, navigate to `localhost` or the respective IP address in your web browser to view your application.

## Troubleshooting

If you encounter any issues, ensure that:

- All services (Apache2, MySQL) are running.
- PHP version compatibility is checked.
- File permissions are set correctly in the Apache directory.

For detailed logs, check Apache's error log usually located at `/var/log/apache2/error.log`.

Sure, I can help you with that. Here's a section you can add to your README.md file to guide users on how to run the Docker container and communicate with a local SQL server using the `--network=host` option. This assumes that the users have Docker installed on their system.

---

## 2. Running the Application in a Docker Container

This project includes an Ansible playbook that automates the process of building and running a Docker container for the application. To run the container and enable it to communicate with your local SQL server, follow these steps:

### Prerequisites

- Docker
- Ansible
- Make sure MySQL is running locally and accessible.

### Using the Ansible Playbook

1. **Run the Ansible Playbook:** This playbook will build the Docker image and run the container with the necessary configurations. Navigate to the directory containing the playbook and run:

   ```bash
   ansible-playbook docker-build-playbook.yml
   ```

   This playbook performs the following tasks:

   - Stops any currently running container named `task-mgm-system-app`.
   - Removes the stopped container and its image.
   - Builds a new Docker image from the Dockerfile located in the `task-management-system/` directory.
   - Runs a new container from this image with the name `task-mgm-system-app`.

2. **Verify Container Execution:** After the playbook execution, ensure the Docker container is running:

   ```bash
   docker ps
   ```

### Connecting to Local SQL Server

- The container is configured to use `--network=host`, which means it shares the network with the host machine. Therefore, it can directly communicate with services running on the host, such as your local SQL server.
- If your SQL server is listening on `localhost`, `127.0.0.1` the application within the Docker container should be able to connect to it using `localhost` or the local IP address as the host address.

### Troubleshooting

- If the container fails to connect to the local SQL server, verify that the SQL server is configured to accept connections from localhost `/etc/mysql/mysql.conf.d/mysqld.cnf`

  ```
  bind-address: 127.0.0.1
  ```

- Ensure that any firewalls or security groups are configured to allow traffic on the SQL server's port.
- Check Docker and SQL server logs for any error messages that might provide more insight.
