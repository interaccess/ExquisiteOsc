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
	text("I'm p5.js", x-25, y);

	var img = get();
	img.loadPixels();
	var imgArray = new Uint8ClampedArray(img.pixels.length * 3);
	for (var i=0; i<imgArray.length; i+=3) {
		imgArray[i] = red(img.pixels[i]);
		imgArray[i+1] = green(img.pixels[i]);
		imgArray[i+2] = blue(img.pixels[i]);
	}
}

