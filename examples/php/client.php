<?php
require_once 'jsonRPCClient.php';
$client = new jsonRPCClient('http://127.0.0.1:8080/test_application');

// Get result of an existing method.
echo 'Server timestamp is '. $client->server_timestamp() . "\n";

// Get result of a non-existing method via method_missing.
echo 'Method missing works: ' . $client->plus(1) . "\n";

// Synchronous error handling.
try {
	$client->buggy_method();
  //echo 'Your name is <i>'.$myExample->giveMeSomeData('name').'</i><br />'."\n";
	//$myExample->changeYourState('I am using this function from the network');
	//echo 'Your status request has been accepted<br />'."\n";
} catch (Exception $e) {
	echo 'EXCEPTION CAUGHT: ' . nl2br($e->getMessage()) . "\n";
}
?>
