<?php
//store user data ACROSS PAGES
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
// CONNECT TO DB
$conn = new PDO("mysql:host=localhost;dbname=lectra;charset=utf8mb4", "root", "");
$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
?>