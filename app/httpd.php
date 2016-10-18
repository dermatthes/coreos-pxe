<?php
    /**
     * Created by PhpStorm.
     * User: matthes
     * Date: 18.10.16
     * Time: 15:11
     */


    $requestUri = $_SERVER["REQUEST_URI"];

    $workDir = $_ENV["WORK_DIR"];
    $requestUri = $workDir . "/" . $requestUri;

    $remoteAddr = $_SERVER["REMOTE_ADDR"];
    $serverIp = $_ENV["SERVER_IP"];
    $discoveryToken = $_ENV["DISCOVERY_TOKEN"];
    $publicKeyFile = $_ENV["PUBLIC_KEY_FILE"];
    $intPrivateKeyFile = $_ENV["INT_PRIVATE_KEY_FILE"];
    $intPublicKeyFile = $_ENV["INT_PUBLIC_KEY_FILE"];


    $replace = [
            "server_ip" => $serverIp,
            "client_ip" => $remoteAddr,
            "client_ip_dash" => str_replace(".", "-", $remoteAddr),
            "etcd_discovery_token" => $discoveryToken,
            "rsa_public_key" => file_get_contents($publicKeyFile),
            "int_rsa_public_key" => file_get_contents($intPrivateKeyFile),
            "int_rsa_private_key" => base64_encode(file_get_contents($intPrivateKeyFile)),
    ];


    if ( ! file_exists($requestUri)) {
        header ("HTTP/1.0 404 Not Found");
        file_put_contents("php://stdout", "\nE: 404 $requestUri");
        exit;
    }


    $data = file_get_contents($requestUri);
    foreach ($replace as $key => $val) {
        $data = str_replace("%({$key})s", $val, $data);
    }

    header ("Content-Type: text/plain;");
    echo $data;

    file_put_contents("php://stdout", "\nS: 200 $requestUri");