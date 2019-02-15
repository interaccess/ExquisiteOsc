"use strict";

let x = 250;
let y = 250;

function setup() {
	createCanvas(500, 500);
	noStroke();
}

function draw() {
	background(0, 0, 255);
	fill(0);
	ellipse(x, y+10, 100, 100);

	loadPixels();

	for (let i=0; i<pixels.length; i+=4) {
		if (i % parseInt(random(32, 64)) === 0 || i % 64 === 0) {
			pixels[i] = 255; // red
			pixels[i+1] = 127; // green
			pixels[i+2] = 0; // blue
			pixels[i+3] = 255; // alpha
		}
	}
	
	updatePixels();

	let img = encode(pixels.buffer);

	fill(0, 255, 0);
	ellipse(x, y, 100, 100);
}

