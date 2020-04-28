<?php
if(!defined('DS')) { define('DS', DIRECTORY_SEPARATOR); }

function getTsv($name) {
	$here = __DIR__ . DS;
	$filename = $here . $name . '.tsv';
	$contents = file_get_contents($filename);
	$rows = explode(PHP_EOL, $contents);
	array_pop($rows);
	$headers = explode("\t", array_shift($rows));
	$data = [];
	foreach($rows as $line) {
		$row = explode("\t", $line);
		$datum = [];
		foreach($headers as $index => $header) {
			$datum[$header] = $row[$index];
		}
		$data[] = $datum;
	}

	return $data;
}

$consonants = getTsv('consonants');
$vowels = array_merge(getTsv('vowels'), getTsv('diphthongs'));

function toTable($data) {
?>
<table>
	<thead>
		<tr>
		<?php foreach($data[0] as $header => $value): ?>
			<th><?php echo $header; ?></th>
		<?php endforeach; ?>
		</tr>
	</thead>
	<tbody>
		<?php foreach($data as $row): ?>
		<tr>
			<?php foreach($row as $header => $value): ?>
				<td><?php echo $value; ?></td>
			<?php endforeach; ?>
		</tr>
		<?php endforeach; ?>
	</tbody>
</table>
<?php
}

ob_start();
?>
# Current Standard

## Consonants

<?php echo toTable($consonants); ?>

## Vowels

<?php echo toTable($vowels); ?>

<?php
$page = ob_get_clean();

file_put_contents(__DIR__ . DS . 'alphabet.md', $page);
