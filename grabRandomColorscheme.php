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
	'd8g_04',
	'devbox-dark-256',
	'xmaslights',
	'adobe',
	'bluez',
	'busierbee',
	'bw',
	'yaml',
	'charged-256',
	'rdark-terminal',
	'colorscheme_template',
	'd8g_01',
	'dark-ruby',
	'enzyme',
	'golded',
	'impact',
	'nerv-ous',
	'pic',
	'potts',
	'rcg_term',
	'thestars',
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
	'cobalt',
	'cool',
	'darkdot',
	//'default',
	'fruidle',
	'desertedocean',
	'desertedoceanburnt',
	'doorhinge',
	'dusk',
	'eclipse',
	'ecostation',
	'flatland',
	'fruity',
	'gor',
	'greens',
	'guardian',
	'guepardo',
	'herald',
	'inkpot',
	'kalisi',
	'kib_darktango',
	'lingodirector',
	'made_of_code',
	'mellow',
	'mopkai',
	'moss',
	'mud',
	'nicotine',
	'nightVision',
	'pspad',
	'rdark',
	'sand',
	'selenitic',
	'sf',
	'smp',
	'summerfruits256',
	'swamplight',
	'herald',
	'two2tango',
	'underwater',
	'underwater-mod',
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
