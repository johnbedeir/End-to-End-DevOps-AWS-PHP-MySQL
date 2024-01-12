<?php
session_start();

// Include database connection and functions
include '../includes/database.php';
include '../includes/functions.php';

$message = ''; // To store the message to be displayed to the user

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['login'])) {
    $username = $_POST['username'];
    $password = $_POST['password'];

    if (checkLogin($username, $password)) {
        // Login successful, set session variable and redirect to dashboard
        $_SESSION['user_id'] = $username;
        header("Location: dashboard.php");
        exit();
    } else {
        // Login failed, show error message
        $message = 'Invalid username or password.';
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
    
    <header class="app-header">
        <a href="../index.php" class="header-link">Task Management System</a>
    </header>

    <div class="form-container">
        <form action="login.php" method="post">
            Username: <input type="text" name="username"><br>
            Password: <input type="password" name="password"><br>
            <input type="submit" name="login" value="Login">
        </form>
        <p><?php echo $message; ?></p>
    </div>

    <script src="../js/script.js"></script> <!-- Assuming script.js is in the root js directory -->
</body>
</html>
