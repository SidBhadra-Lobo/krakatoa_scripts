<?php

// $servername = "localhost";
// $username = "bakyt";
// $password = "limsbakyt";
// $dbname = "lim";

// //Create connection to sql
// $connect = new mysqli_connect($servername, $username, $password, $dbname);

// //Check connection
// if (!$connect) {
//     die("Connection failed: " . mysqli_connect_error());
// } 
// echo "Connected successfully";


$connect=mysqli_connect('localhost','bakyt','limsbakyt','lim');

if(mysqli_connect_errno($connect))
{
        echo 'Failed to connect';
}



?>