<?php
// LAB ONLY — deliberately vulnerable command injection
$host = $_GET['host'] ?? '';
if ($host === '') { echo "usage: ping.php?host=<ip>"; exit; }
// naive sanitization: spaces are stripped
$clean = str_replace(' ', '', $host);
$out = shell_exec("ping -c 1 -W 1 $clean 2>&1");
echo "<pre>" . htmlspecialchars($out ?? 'no output') . "</pre>";
?>
