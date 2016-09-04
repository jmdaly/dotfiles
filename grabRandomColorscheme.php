<?php
$home    = $_SERVER['HOME'];
$bundles = $home.'/dotfiles/bundles';

function getColourDirs($base) {
	$dirs = array();
	$d = dir($base);
	while (false !== ($entry = $d->read())) {
		$path = $base . '/' . $entry;
		$cpath = $path . '/colors';
		if (is_dir($cpath))
			$dirs[] = $cpath;
	}
	return $dirs;
}

function findAllColourSchemes(array $dirs = array()) {
	$files = array();

	// MUCH faster than shelling out to find (confirmed in benchmark).  Likely
	// not as fast as building an sqlite cache though
	foreach ($dirs as $dir) {
		$d = dir($dir);
		while (false !== ($entry = $d->read())) {
			$path = $dir . '/' . $entry;
			if (is_file($path))
				$files[] = $path;
		}
	}

	// Files is now an array of paths to colour schemes
	return $files;
}

function pathToScheme($path) {
	$scheme = preg_replace('/\.vim$/', '', basename($path));
	$scheme = trim($scheme);
	return $scheme;
}

function grabRandomColourScheme($use_whitelist = false, array $files = array(), array $whitelist = array(), array $blacklist = array()) {
	$scheme = '/dev/null';
	if ($use_whitelist) {
		$scheme=$whitelist[rand(0, count($whitelist)-1)];
	} else {
		for ($i=5; $i>0; $i++) { // Limit attempts
			$scheme=pathToScheme($files[rand(0, count($files)-1)]);
			if (array_search($scheme, $blacklist) === false) break;
		}
	}
	return $scheme;
}

// Script example.php
$opts = getopt("w");
$use_whitelist=array_key_exists('w', $opts);


// Colour schemes that are just awefule
$blacklist = array(
	'256-grayvim',
	'256-jungle',
	'adobe',
	'bluez',
	'busierbee',
	'bw',
	'charged-256',
	'ciscoacl',
	'colorscheme_template',
	'd8g_01',
	'd8g_04',
	'dark-ruby',
	'devbox-dark-256',
	'developer',
	'derefined',
	'enzyme',
	'golded',
	'heroku-terminal',
	'impact',
	'mango',
	'nerv-ous',
	'oceanblack256',
	'pic',
	'potts',
	'psql',
	'otaku',
	'rcg_term',
	'rdark-terminal',
	'textmate16',
	'thestars',
	'visualstudio',
	'wargrey',
	'xmaslights',
	'yaml',
	'zen',
	'zephyr', 'miko',
);

// Not yet used, but a place to save the ones
// I find interesting
$whitelist = array(
	'3dglasses',
	'ChocolateLiquor',
	'PapayaWhip',
	'abra',
	'asuldark',
	'base16-ateliersulphurpool',
	'blackboard',
	'bluechia',
	'busybee',
	'camo',
	'colorzone',
	'candycode',
	'cobalt',
	'cool',
	'darkdot',
	'desertedocean',
	'desertedoceanburnt',
	'doorhinge',
	'dusk',
	'eclipse',
	'ecostation',
	'evolution',
	'forneus',
	'flatland',
	'flatlandia',
	'fruidle',
	'fruity',
	'gemcolors',
	'golden',
	'gor',
	'gotham',
	'greens',
	'guardian',
	'guepardo',
	'herokudoc',
	'herald',
	'inkpot',
	'kalisi',
	'kib_darktango',
	'lingodirector',
	'made_of_code',
	'madeofcode',
	'maroloccio',
	'MountainDew',
	// 'mellow',
	'mopkai',
	// 'moss',
	'mud',
	'nefertiti',
	// 'nicotine',
	'newsprint',
	'nightVision',
	'northland',
	'seoul-256',
	'seoul-256-light',
	// 'olive',
	'onedark', // Not in dir list above
	'paintbox',
	'phd',
	'playroom',
	'pspad',
	'radicalgoodspeed',
	'rdark',
	'sand',
	'scite',
	'selenitic',
	'sexy-railscasts',
	'sf',
	'shadesofamber',
	'silent',
	'smp',
	'softbluev2',
	'summerfruit',
	'summerfruit256',
	'Sunburst',
	'swamplight',
	'two2tango',
	'Tomorrow-Night-Eighties',
	'underwater',
	'underwater-mod',
	//'default',
);

// TODO not used yet
$mode = array(
	'256-grayvim'=>'dark',
);

// Get colour directories
$dirs = getColourDirs($bundles);
$files = findAllColourSchemes($dirs);
$scheme = '';
for ($i = 3; $i>0; $i--) { // Limit number of attempts
	$scheme = grabRandomColourScheme($use_whitelist, $files, $whitelist, $blacklist);
	// Make sure this scheme exists.
	foreach ($files as $f) {
		if (strstr($f, $scheme)) break 2;
	}
}

//
// Save this
$log = __DIR__ . '/colourschemes.log';
if (file_exists($log))
	$lines = file($log);
else
	$lines = array();
array_unshift($lines, $scheme."\n");
$limit=50; // Number of schemes to remember
if (count($lines) > $limit) array_splice($lines, $limit);
$fp = fopen($log, 'w');
fwrite($fp, join('', $lines));
fclose($fp);
// /Save this


print $scheme;

// vim: sw=4 ts=4 noet :
