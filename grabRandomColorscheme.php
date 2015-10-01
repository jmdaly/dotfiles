<?php
$home    = '/home/matt';
$bundles = $home.'/dotfiles/bundles';

$dirs = array(
	"$bundles/vim-colorschemes/colors",
	"$bundles/vim-colors_atelier-schemes/colors",
	"$home/.vim/colors",
);

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
	'enzyme',
	'golded',
	'impact',
	'mango',
	'nerv-ous',
	'oceanblack256',
	'pic',
	'potts',
	'psql',
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
	'base16-ateliersulphurpool',
	'busybee',
	'caramel',
	'bluechia',
	'cobalt',
	'cool',
	'darkdot',
	'desertedocean',
	'desertedoceanburnt',
	'playroom',
	'doorhinge',
	'dusk',
	'eclipse',
	'ecostation',
	'flatland',
	'fruidle',
	'fruity',
	'gor',
	'greens',
	'guardian',
	'guepardo',
	'herald',
	'kib_darktango',
	'inkpot',
	'kalisi',
	'kib_darktango',
	'lingodirector',
	'made_of_code',
	'maroloccio',
	'mellow',
	'mopkai',
	'moss',
	'mud',
	'nefertiti',
	'nicotine',
	'nightVision',
	'olive',
	'phd',
	'pspad',
	'radicalgoodspeed',
	'rdark',
	'sand',
	'selenitic',
	'sf',
	'shadesofamber',
	'smp',
	'summerfruits',
	'summerfruits256',
	'swamplight',
	'two2tango',
	'underwater',
	'underwater-mod',
	//'default',
);

// TODO not used yet
$mode = array(
	'256-grayvim'=>'dark',
);

if ($use_whitelist) {
	$scheme=$whitelist[rand(0, count($whitelist)-1)];
} else {
	// Build cache
	$files = '';
	exec("find ". join(' ', $dirs) ." -type f -iname '*.vim' -exec basename \{\} \;", $files);
	//print_r($files);

	$scheme = '';
	while (true) {
		$scheme=$files[rand(0, count($files)-1)];
		$scheme = preg_replace('/\.vim$/', '', $scheme);
		$scheme = trim($scheme);
		if (array_search($scheme, $blacklist) === false) break;
	}
}

print $scheme;

// vim: sw=4 ts=4 noet :
