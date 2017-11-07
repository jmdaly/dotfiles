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
	'duotone-darkheath',
	'd8g_01',
	'd8g_04',
	'dark-ruby',
	'devbox-dark-256',
	'developer',
	'derefined',
	'duotone-dark',
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
	'anotherdark',
	'abra',
	'abbott',
	'asuldark',
	'base16-ateliersulphurpool',
	'blackboard',
	'blackdust',
	'blacklight',
	'blue',
	'bluechia',
	'busybee',
	'bvemu',
	'camo',
	'clue', // good for diff
	'colorzone',
	'candycode',
	'chance-of-storm',
	'cobalt',
	'colorsbox-steighties',
	'cool',
	'darkdot',
	'duotone-darkearth', // set background=dark  .. need to implement this ability
	'desertedocean',
	'desertedoceanburnt',
	'distinguished', // good for diff
	'doorhinge',
	'dusk',
	'eclipse',
	'ecostation',
	'ego',
	'elrodeo',
	'evolution',
	'forneus',
	'flatland',
	'flatlandia',
	'fruidle',
	'fruity',
	'birds-of-paradise',
	'gemcolors',
	'golden',
	'gor',
	'gotham',
	'greens',
	'greenvision',
	'guardian',
	'guepardo',
	'herokudoc',
	'herald',
	'hybrid_reverse',
	'hybrid_material',
	'inkpot',
	'kalisi',
	'kib_darktango',
	'lingodirector',
	// 'made_of_code',
	'madeofcode',
	'materialvim',
	'maroloccio',
	'midnight2',
	'MountainDew',
	// 'mellow',
	'mopkai',
	// 'moss',
	'mud',
	'neonwave',
	'nefertiti',
	// 'nicotine',
	'newsprint',
	'neverland-darker',
	// 'nightVision',
	'northland',
	'seoul-256',
	'seoul-256-light',
	// 'olive',
	'onedark', // Not in dir list above
	'openbsd',
	'paintbox',
	'predawn',
	'phd',
	'playroom',
	'pspad',
	'radicalgoodspeed',
	'rdark',
	'radicalgoodspeed',
	'strawimodo',
	'sand',
	'scite',
	'selenitic',
	'sexy-railscasts',
	'sf',
	'shadesofamber',
	'silent',
	'smp',
	'summerfruit',
	'summerfruit256',
	'Sunburst',
	'swamplight',
	'taqua',
	'turbo',
	'two2tango',
	'Tomorrow-Night-Eighties',
	'twilight256',
	'underwater',
	'umber-green', // better with background=light, in dark the blue is annoying
	'VIvid',
	'underwater-mod',
	//'default',
);

// TODO not used yet
$mode = array(
	'256-grayvim'=>'dark',
);

// Get colour directories.
// TODO cache these
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
if (is_writable($log)) {
	array_unshift($lines, $scheme."\n");
	$limit=50; // Number of schemes to remember
	if (count($lines) > $limit) array_splice($lines, $limit);
	$fp = fopen($log, 'w');
	fwrite($fp, join('', $lines));
	fclose($fp);
}
// /Save this


print $scheme;

// vim: sw=4 ts=4 noet :
