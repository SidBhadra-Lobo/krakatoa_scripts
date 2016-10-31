<?php include 'database.php'; ?>

<?php

// Show that .html page is taking outputs.

// echo $_POST['firstname'];
// echo '<br />';
// echo $_POST['email'];
// print_r($_POST);

// create a variable
$sample1=$_POST['samplename1'];

// $sampleCount=$_POST['sampleCount'] //trying out

$firstname=$_POST['firstname'];
$lastname=$_POST['lastname'];
$email=$_POST['email'];
//automatic date including?
$dateof=date("Y-m-d");

// $check_box=$_POST['check'];



// if(empty($firstname)){ echo 'You seem to be missing something.' };


//Execute the query

mysqli_query($connect, "INSERT INTO samples (samplename,firstname,lastname,email,dateof)
                VALUES('$sample1','$firstname','$lastname','$email','$dateof')");

// $sample2=$_POST['samplename2'];
// $sample3=$_POST['samplename3'];
// $sample4=$_POST['samplename4'];
// $sample5=$_POST['samplename5'];
// $sample6=$_POST['samplename6'];

//     if($sample2 != ''){
//         mysqli_query($connect, "INSERT INTO samples (samplename,firstname,lastname,email,dateof)
//                 VALUES('$sample2','$firstname','$lastname','$email','$dateof')");
//     }
//     if($sample3 != ''){
//         mysqli_query($connect, "INSERT INTO samples (samplename,firstname,lastname,email,dateof)
//                 VALUES('$sample3','$firstname','$lastname','$email','$dateof')");
//     }
//     if($sample4 != ''){
//         mysqli_query($connect, "INSERT INTO samples (samplename,firstname,lastname,email,dateof)
//                 VALUES('$sample4','$firstname','$lastname','$email','$dateof')");
//     }
//     if($sample5 != ''){
//         mysqli_query($connect, "INSERT INTO samples (samplename,firstname,lastname,email,dateof)
//                 VALUES('$sample5','$firstname','$lastname','$email','$dateof')");
//     }
//     // if($sample6 != ''){
//     if($sample6 != ''){
//         mysqli_query($connect, "INSERT INTO samples (samplename,firstname,lastname,email,dateof)
//                 VALUES('$sample6','$firstname','$lastname','$email','$dateof')");
//     }

    if(mysqli_affected_rows($connect) > 0){
    // readfile('simple_form.html');
    echo "<p>Sample Added</p>";
    echo "<a href='simple_form.html'>Go Back</a>";
    } 

else {
    echo "Sample NOT Added<br />";
    echo mysqli_error ($connect);
}

// create a variable
// $samplename=$_POST['samplename2'];



// mysqli_query($connect, "INSERT INTO samples (samplename,firstname,lastname,email,dateof)
//                 VALUES('$samplename','$firstname','$lastname','$email','$dateof')");

//     if(mysqli_affected_rows($connect) > 0){
//     echo "<p>Sample Added</p>";
//     echo "<a href='simple_form.html'>Go Back</a>";
//     } 

// else {
//     echo "Sample NOT Added<br />";
//     echo mysqli_error ($connect);
// }

// // create a variable
// $samplename=$_POST['samplename3'];



// mysqli_query($connect, "INSERT INTO samples (samplename,firstname,lastname,email,dateof)
//                 VALUES('$samplename','$firstname','$lastname','$email','$dateof')");

//     if(mysqli_affected_rows($connect) > 0){
//     echo "<p>Sample Added</p>";
//     echo "<a href='simple_form.html'>Go Back</a>";
//     } 

// else {
//     echo "Sample NOT Added<br />";
//     echo mysqli_error ($connect);
// }






// $servername = "localhost";
// $username = "bakyt";
// $password = "limsbakyt";
// $dbname = "lim";

// //Create connection to sql

// $conn = new mysqli_connect($servername, $username, $password);

// //Check connection
// if (!$conn) {
//     die("Connection failed: " . mysqli_connect_error());
// } 
// echo "Connected successfully";

// //Create database for names

// $sql = "CREATE DATABASE Names";
// if (mysqli_query($conn, $sql)) {
//     echo "Database created successfully";
// } else {
//     echo "Error creating database: " . mysqli_error($conn);
// }

// mysqli_close($conn);

// //Create new connection to databsse //Do this later

// $conn = new mysqli_connect($servername, $username, $password, $dbname);

// //Insert names into Names
// $sql = "INSERT INTO Names (samplename, firstname, lastname)
// VALUES( 'Sample', 'John', 'Doe')";

// if (mysql_query($conn, $sql)) {
//     echo "New record created successfully";
// }

// else {
//     echo "Error: " . $sql . "<br>" . mysqli_error($conn);
// }

// mysqli_close($conn);

?>




