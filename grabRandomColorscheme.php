<?php
$home    = '/home/matt';
$bundles = $home.'/dotfiles/bundles';

$dirs = array(
	"$bundles/vim-colorschemes/colors",
	"$bundles/vim-colors_atelier-schemes/colors",
	"$home/.vim/colors",
);

// Build cache
$files = '';
exec("find ". join(' ', $dirs) ." -type f -iname '*.vim' -exec basename \{\} \;", $files);
//print_r($files);

$scheme=$files[rand(0, count($files)-1)];
$scheme = preg_replace('/\.vim$/', '', $scheme);

print $scheme;

// vim: ts=4 noet :
