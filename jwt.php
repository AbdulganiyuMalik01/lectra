<?php
require_once __DIR__ . '/vendor/autoload.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$secret_key = 'lecktra_super_secret_jwt_key_2026_secure_string_xyz_abc_123';

if (!function_exists('createToken')) {
    function createToken($user)
    {
        global $secret_key;

        $payload = [
            'id'    => $user['id'],
            'email' => $user['email'],
            'role'  => $user['role'],
            'iat'   => time(),
            'exp'   => time() + 3600
        ];

        return JWT::encode($payload, $secret_key, 'HS256');
    }
}

if (!function_exists('verifyToken')) {
    function verifyToken($token)
    {
        global $secret_key;

        try {
            $decoded = JWT::decode($token, new Key($secret_key, 'HS256'));
            return $decoded;
        } catch (Exception $e) {
            return null;
        }
    }
}