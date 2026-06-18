<?php
require_once __DIR__ . "/../header.php";
require_once __DIR__ . "/../../conn.php";
require_once __DIR__ . "/../../jwt.php";

$method = $_SERVER['REQUEST_METHOD'];
$id     = null;

if (isset($_GET['id']) && is_numeric($_GET['id'])) {
    $id = (int)$_GET['id'];
}

// ─── AUTH CHECK ───────────────────────────────────────────────────────────────
try {
    $authUser = require_once __DIR__ . "/../middleware/auth.php";

    if ($authUser->role !== 'admin') {
        http_response_code(403);
        echo json_encode([
            "status"  => "error",
            "message" => "Forbidden - Admin access required"
        ]);
        exit;
    }
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode([
        "status"  => "error",
        "message" => "Unauthorized - Invalid or missing token"
    ]);
    exit;
}

// ─── ROUTES ───────────────────────────────────────────────────────────────────
try {
    switch ($method) {

        // ── GET ───────────────────────────────────────────────────────────────
        case 'GET':
            if ($id) {
                $stmt = $conn->prepare("
                    SELECT id, title, message, type, target_role, is_active, created_at
                    FROM notifications WHERE id = ?
                ");
                $stmt->execute([$id]);
                $notification = $stmt->fetch(PDO::FETCH_ASSOC);

                if (!$notification) {
                    http_response_code(404);
                    echo json_encode([
                        "status"  => "error",
                        "message" => "Notification not found"
                    ]);
                    break;
                }

                echo json_encode(["status" => "success", "data" => $notification]);

            } else {
                $stmt = $conn->prepare("
                    SELECT id, title, message, type, target_role, is_active, created_at
                    FROM notifications ORDER BY created_at DESC
                ");
                $stmt->execute();
                $notifications = $stmt->fetchAll(PDO::FETCH_ASSOC);

                echo json_encode([
                    "status" => "success",
                    "count"  => count($notifications),
                    "data"   => $notifications
                ]);
            }
            break;

        // ── POST ──────────────────────────────────────────────────────────────
        case 'POST':
            $data        = json_decode(file_get_contents("php://input"), true);
            $title       = trim($data['title']       ?? '');
            $message     = trim($data['message']     ?? '');
            $type        = $data['type']              ?? 'general';
            $target_role = $data['target_role']       ?? 'all';
            $is_active   = $data['is_active']         ?? 1;

            if ($title === '' || $message === '') {
                http_response_code(400);
                echo json_encode([
                    "status"  => "error",
                    "message" => "Title and message are required"
                ]);
                break;
            }

            $validTypes = ['reminder', 'cancellation', 'change', 'general', 'info', 'warning', 'alert'];
            if (!in_array($type, $validTypes)) {
                http_response_code(400);
                echo json_encode([
                    "status"  => "error",
                    "message" => "Invalid type. Must be: reminder, cancellation, change, general, info, warning, alert"
                ]);
                break;
            }

            $validTargets = ['admin', 'lecturer', 'student', 'all'];
            if (!in_array($target_role, $validTargets)) {
                http_response_code(400);
                echo json_encode([
                    "status"  => "error",
                    "message" => "Invalid target_role. Must be: admin, lecturer, student, all"
                ]);
                break;
            }

            $stmt = $conn->prepare("
                INSERT INTO notifications (title, message, type, target_role, is_active)
                VALUES (?, ?, ?, ?, ?)
            ");
            $stmt->execute([$title, $message, $type, $target_role, $is_active]);
            $newId = $conn->lastInsertId();

            $stmt = $conn->prepare("
                SELECT id, title, message, type, target_role, is_active, created_at
                FROM notifications WHERE id = ?
            ");
            $stmt->execute([$newId]);

            echo json_encode([
                "status"  => "success",
                "message" => "Notification created successfully",
                "data"    => $stmt->fetch(PDO::FETCH_ASSOC)
            ]);
            break;

        // ── PUT ───────────────────────────────────────────────────────────────
        case 'PUT':
            if (!$id) {
                http_response_code(400);
                echo json_encode([
                    "status"  => "error",
                    "message" => "id is required in query string"
                ]);
                break;
            }

            $find = $conn->prepare("SELECT * FROM notifications WHERE id = ?");
            $find->execute([$id]);
            $notification = $find->fetch(PDO::FETCH_ASSOC);

            if (!$notification) {
                http_response_code(404);
                echo json_encode([
                    "status"  => "error",
                    "message" => "Notification not found"
                ]);
                break;
            }

            $data        = json_decode(file_get_contents("php://input"), true);
            $title       = trim($data['title']   ?? '') ?: $notification['title'];
            $message     = trim($data['message'] ?? '') ?: $notification['message'];
            $type        = $data['type']        ?? $notification['type'];
            $target_role = $data['target_role'] ?? $notification['target_role'];
            $is_active   = $data['is_active']   ?? $notification['is_active'];
            $is_active   = ($is_active === true || $is_active == 1) ? 1 : 0;

            $validTypes = ['reminder', 'cancellation', 'change', 'general', 'info', 'warning', 'alert'];
            if (!in_array($type, $validTypes)) {
                http_response_code(400);
                echo json_encode([
                    "status"  => "error",
                    "message" => "Invalid type. Must be: reminder, cancellation, change, general, info, warning, alert"
                ]);
                break;
            }

            $validTargets = ['admin', 'lecturer', 'student', 'all'];
            if (!in_array($target_role, $validTargets)) {
                http_response_code(400);
                echo json_encode([
                    "status"  => "error",
                    "message" => "Invalid target_role. Must be: admin, lecturer, student, all"
                ]);
                break;
            }

            $stmt = $conn->prepare("
                UPDATE notifications
                SET title = ?, message = ?, type = ?, target_role = ?, is_active = ?
                WHERE id = ?
            ");
            $stmt->execute([$title, $message, $type, $target_role, $is_active, $id]);

            $stmt = $conn->prepare("
                SELECT id, title, message, type, target_role, is_active, created_at
                FROM notifications WHERE id = ?
            ");
            $stmt->execute([$id]);

            echo json_encode([
                "status"  => "success",
                "message" => "Notification updated successfully",
                "data"    => $stmt->fetch(PDO::FETCH_ASSOC)
            ]);
            break;

        // ── DELETE ────────────────────────────────────────────────────────────
        case 'DELETE':
            if (!$id) {
                http_response_code(400);
                echo json_encode([
                    "status"  => "error",
                    "message" => "id is required in query string"
                ]);
                break;
            }

            $stmt = $conn->prepare("SELECT id FROM notifications WHERE id = ?");
            $stmt->execute([$id]);
            if (!$stmt->fetch()) {
                http_response_code(404);
                echo json_encode([
                    "status"  => "error",
                    "message" => "Notification not found"
                ]);
                break;
            }

            $stmt = $conn->prepare("DELETE FROM notifications WHERE id = ?");
            $stmt->execute([$id]);

            echo json_encode([
                "status"  => "success",
                "message" => "Notification deleted successfully"
            ]);
            break;

        default:
            http_response_code(405);
            echo json_encode([
                "status"  => "error",
                "message" => "Method not allowed. Use GET, POST, PUT or DELETE."
            ]);
            break;
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        "status"  => "error",
        "message" => "Server error: " . $e->getMessage()
    ]);
}