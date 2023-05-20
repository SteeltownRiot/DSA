<html>
<head>
<h1>AWS AMAZON</h1> Name: Sai K Amsanpally
</head> 

<body>
<h1>AWS AMAZON</h1>
<?php 
    $hostname = file_get_contents("http://169.254.169.254/latest/meta-data/public-hostname"); 
    $instance_id = file_get_contents("http://169.254.169.254/latest/meta-data/instance-id"); 
    $zone = file_get_contents("http://169.254.169.254/latest/meta-data/placement/availability-zone"); 
    $secgroup = file_get_contents("http://169.254.169.254/latest/meta-data/security-groups"); 
?> 
<h2>Instance Information</h2> 
<h3>Hostname : <?php echo $hostname; ?></h3> 
<h3>Instance ID : <?php echo $instance_id; ?></h3> 
<h3>Zone : <?php echo $zone; ?></h3> 
<h3>Security Group : <?php echo $secgroup; ?></h3>

</body> 
</html>