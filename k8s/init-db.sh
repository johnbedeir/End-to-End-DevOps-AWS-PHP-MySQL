#!/bin/bash

# SQL query
SQL_QUERY="
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    task VARCHAR(255) NOT NULL,
    due_date DATE,
    completed BOOLEAN DEFAULT false,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
"

# Connect to the database and execute query
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_DATABASE" -e "$SQL_QUERY"

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "Table created successfully"
else
    echo "Error occurred in table creation"
fi
