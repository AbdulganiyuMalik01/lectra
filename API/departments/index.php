<?php
require_once __DIR__ . "/../../header.php";
require_once __DIR__ . "/../../conn.php";
require_once __DIR__ . "/../../jwt.php";

// Admin only
$authUser = require_once __DIR__ . "/../middleware/auth.php";
if ($authUser->role !== 'admin') {
    http_response_code(403);
    echo json_encode(["status" => "error", "message" => "Forbidden - Admin access required"]);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {

    // ─── GET ALL or ONE ───────────────────────────
    case 'GET':
        if (isset($_GET['id'])) {
            $stmt = $conn->prepare("SELECT * FROM departments WHERE id = ?");
            $stmt->execute([$_GET['id']]);
            $dept = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$dept) {
                http_response_code(404);
                echo json_encode(["status" => "error", "message" => "Department not found"]);
                exit;
            }

            echo json_encode(["status" => "success", "data" => $dept]);

        } else {
            $stmt = $conn->query("SELECT * FROM departments ORDER BY name ASC");
            echo json_encode([
                "status" => "success",
                "data"   => $stmt->fetchAll(PDO::FETCH_ASSOC)
            ]);
        }
        break;

    // ─── CREATE ───────────────────────────────────
    case 'POST':
        $data       = json_decode(file_get_contents("php://input"), true);
        $name       = $data['name']       ?? null;
        $faculty_id = $data['faculty_id'] ?? null;

        if (!$name || !$faculty_id) {
            http_response_code(400);
            echo json_encode(["status" => "error", "message" => "name and faculty_id are required"]);
            exit;
        }

        $stmt = $conn->prepare("INSERT INTO departments (name, faculty_id) VALUES (?, ?)");
        $stmt->execute([$name, $faculty_id]);

        echo json_encode([
            "status"  => "success",
            "message" => "Department created",
            "data"    => [
                "id"         => $conn->lastInsertId(),
                "name"       => $name,
                "faculty_id" => $faculty_id
            ]
        ]);
        break;

    // ─── UPDATE ───────────────────────────────────
    case 'PUT':
        $id   = $_GET['id'] ?? null;
        $data = json_decode(file_get_contents("php://input"), true);

        if (!$id) {
            http_response_code(400);
            echo json_encode(["status" => "error", "message" => "id is required in query string"]);
            exit;
        }

        $fields = [];
        $values = [];

        if (isset($data['name']))       { $fields[] = "name = ?";       $values[] = $data['name']; }
        if (isset($data['faculty_id'])) { $fields[] = "faculty_id = ?"; $values[] = $data['faculty_id']; }

        if (empty($fields)) {
            http_response_code(400);
            echo json_encode(["status" => "error", "message" => "No fields provided to update"]);
            exit;
        }

        $values[] = $id;
        $stmt = $conn->prepare("UPDATE departments SET " . implode(", ", $fields) . " WHERE id = ?");
        $stmt->execute($values);

        echo json_encode(["status" => "success", "message" => "Department updated"]);
        break;

    // ─── DELETE ───────────────────────────────────
    case 'DELETE':
        $id = $_GET['id'] ?? null;

        if (!$id) {
            http_response_code(400);
            echo json_encode(["status" => "error", "message" => "id is required in query string"]);
            exit;
        }

        $stmt = $conn->prepare("DELETE FROM departments WHERE id = ?");
        $stmt->execute([$id]);

        echo json_encode(["status" => "success", "message" => "Department deleted"]);
        break;

    default:
        http_response_code(405);
        echo json_encode(["status" => "error", "message" => "Method not allowed"]);
        break;
}