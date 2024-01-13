<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

session_start();

include '../includes/database.php';
include '../includes/functions.php'; 

// Redirect to login page if the user is not logged in
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

// User's username for the welcome message
$username = $_SESSION['user_id'];

// Fetch tasks from the database
$stmt = $conn->prepare("SELECT id, task FROM tasks WHERE user_id = ? ORDER BY id DESC");
$stmt->bind_param("i", $userId);
$stmt->execute();
$result = $stmt->get_result();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Task Management Dashboard</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
    <header class="app-header">
        <h1>Task Management System</h1>
        <a class="btn" href="logout.php">Logout</a>
    </header>

    <main>
        <h2>Welcome, <?php echo htmlspecialchars($username); ?>!</h2>
        <div>
            <h3>Task Management System App</h3>
            <form action="add_task.php" method="post">
                Title:
                <br> 
                <input type="text" name="title" required>
                <br> 
                Description: 
                <br>
                <textarea type="text" name="description" required></textarea>
                <input type="submit" value="Add Task">
            </form>
        </div>
        <br>
        <div>
            <table>
                <tr>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Actions</th>
                </tr>
                <!-- PHP code to loop through tasks and display them -->
                <?php while ($row = $result->fetch_assoc()): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($row['title']); ?></td>
                        <td><?php echo htmlspecialchars($row['description']); ?></td>
                        <td>
                            <!-- Replace '#' with the actual script for marking a task as completed -->
                            <form action="#" method="post">
                                <input type="hidden" name="task_id" value="<?php echo $row['id']; ?>">
                                <input type="submit" name="complete" value="Complete">
                            </form>
                            <!-- Replace '#' with the actual script for deleting a task -->
                            <form action="delete_task.php" method="post">
                                <input type="hidden" name="task_id" value="<?php echo $row['id']; ?>">
                                <input type="submit" name="delete" value="Delete">
                            </form>
                        </td>
                    </tr>
                <?php endwhile; ?>
            </table>
        </div>
    </main>
</body>
</html>