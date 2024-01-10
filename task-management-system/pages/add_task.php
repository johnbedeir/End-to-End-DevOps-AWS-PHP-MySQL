<?php
session_start();

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Include database connection and functions
include '../includes/database.php'; // Adjust the path as necessary
include '../includes/functions.php'; // Adjust the path as necessary

// Check if the user is logged in
if (!isset($_SESSION['user_id'])) {
    // Redirect to login page if not logged in
    header('Location: login.php');
    exit();
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // ... code to validate and sanitize inputs ...

    error_log("Form submitted: Title - " . $_POST['title'] . ", Description - " . $_POST['description']);

    $userId = $_SESSION['user_id'];
    $title = $_POST['title'];
    $description = $_POST['description'];

    if (addTask($userId, $title, $description)) {
        header("Location: dashboard.php?status=success&message=Task added");
        exit();
    } else {
        header("Location: dashboard.php?status=error&message=Failed to add task");
        exit();
    }
    
}

// Redirect back to the dashboard if the script is accessed without posting form data
header('Location: dashboard.php');
exit();
?>
