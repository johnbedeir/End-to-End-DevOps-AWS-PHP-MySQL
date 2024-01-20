<?php
include 'database.php';

//User Register

function registerUser($username, $password) {
    global $conn;

    // Hash the password for security
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);

    // Prepare SQL statement to prevent SQL injection
    $stmt = $conn->prepare("INSERT INTO users (username, password) VALUES (?, ?)");
    if ($stmt === false) {
        error_log("Prepare failed: " . $conn->error);
        return false;
    }

    $stmt->bind_param("ss", $username, $hashed_password);
    $result = $stmt->execute();
    if ($result === false) {
        error_log("Execute failed: " . $stmt->error);
    }
    $stmt->close();

    return $result;
}

// User Login
function checkLogin($username, $password) {
    global $conn;

    // Prepare SQL
    $stmt = $conn->prepare("SELECT password FROM users WHERE username = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    
    // Bind result
    $stmt->bind_result($hashed_password);
    $stmt->fetch();
    $stmt->close();

    // Verify password
    return password_verify($password, $hashed_password);
}

?>
