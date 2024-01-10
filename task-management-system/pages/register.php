<?php
session_start();

// Include database connection and functions
include '../includes/database.php';
include '../includes/functions.php';

$message = '';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST['username'];
    $password = $_POST['password'];

    if (!empty($username) && !empty($password)) {
        // Call function to register user
        if (registerUser($username, $password)) {
            $message = 'Registered successfully!';
            // Redirect to login page or anywhere you want
            header('Location: login.php');
        } else {
            $message = 'Registration failed. Username might already be taken.';
        }
    } else {
        $message = 'Username and password are required.';
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>

    <header class="app-header">
        <a href="../index.php" class="header-link">Task Management System</a>
    </header>

    <div class="form-container">
        <form action="register.php" method="post">
            Username: <input type="text" name="username"><br>
            Password: <input type="password" name="password"><br>
            <input type="submit" name="register" value="Register">
        </form>
        <p><?php echo $message; ?></p>
    </div>
</body>
</html>
