"use strict";

var x = 250;
var y = 250;

function setup() {
	createCanvas(500, 500);
}

function draw() {
	background(0, 0, 255);
	fill(0, 255, 0);
	ellipse(x, y, 100, 100);
	fill(0);
	//text("I'm p5.js", x-25, y);

	var img = get();
	img.loadPixels();

	img.pixels[44] = color(255,0,0);
	img.pixels[45] = color(255,0,0);
	img.pixels[46] = color(255,0,0);
	img.pixels[47] = color(255,0,0);
	img.updatePixels();
	image(img, 0, 0);
}

