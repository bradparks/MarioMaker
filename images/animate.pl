#!/usr/local/bin/perl
use Image::Magick;

$q = Image::Magick->new;
$x = $q->Read("goomba01.gif", "goomba02.gif");
warn "$x" if $x;

# $x = $q->Crop(geom=>'16x16+16+16');
# warn "$x" if $x;

$x = $q->Write("goomba.gif");
warn "$x" if $x;

# The script reads three images, crops them, and writes a single
# image as a GIF animation sequence.