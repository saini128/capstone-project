<?php

// Replace with your Firebase credentials
$firebase_url = 'https://your-firebase-project-id.firebaseio.com';
$collection_name = 'users';

// Fetch data from Firebase Cloud Firestore
$response = file_get_contents("$firebase_url/$collection_name.json");
$data = json_decode($response, true);

// Process data and filter records with 'due' greater than 100
$result = array_filter($data, function ($item) {
    return isset($item['due']) && $item['due'] > 100;
});

// Convert result to JSON
$jsonResult = json_encode($result);

// Output JSON result
header('Content-Type: application/json');
echo $jsonResult;
?>
