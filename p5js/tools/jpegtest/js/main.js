var x, y;

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
	var img2 = encode(img.pixels);
}

