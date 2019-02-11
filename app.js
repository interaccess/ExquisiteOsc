"use strict";

var strokeLifetime = 10000;

var express = require("express");
var osc = require("node-osc");
var jpeg = require("jpeg-js")
var app = express();
var http = require("http").Server(app);
var port = 8080;

var io = require("socket.io")(http, { 
	// default -- pingInterval: 1000 * 25, pingTimeout: 1000 * 60
	// low latency -- pingInterval: 1000 * 5, pingTimeout: 1000 * 10

	pingInterval: 1000 * 5,
	pingTimeout: 1000 * 10
});

var oscServer, oscClient;
var isConnected = false;

// ~ ~ ~ ~
	
app.use(express.static("public")); 

app.get("/", function(req, res) {
	res.sendFile(__dirname + "/public/index.html");
});

http.listen(port, function() {
	console.log("\nNode app started. Listening on port " + port);
});

io.sockets.on('connection', function (socket) {
    console.log('connection');
    socket.on("config", function (obj) {
        isConnected = true;
        oscServer = new osc.Server(obj.server.port, obj.server.host);
        oscClient = new osc.Client(obj.client.host, obj.client.port);
        oscClient.send('/status', socket.sessionId + ' connected');
        oscServer.on('message', function(msg, rinfo) {
            socket.emit("message", msg);
        });
        socket.emit("connected", 1);
    });
    socket.on("message", function (obj) {
        oscClient.send.apply(oscClient, obj);
    });
    socket.on('disconnect', function(){
        if (isConnected) {
            oscServer.kill();
            oscClient.kill();
        }
    });
});

// ~ ~ ~ ~

// https://www.npmjs.com/package/jpeg-js

function decodeJpeg(img, useArray) { // Buffer or Uint8Array, bool
    var jpegData = fs.readFileSync(img);
    var rawImageData = jpeg.decode(jpegData, useArray); // true for Uint8Array
    return rawImageData;
}

function encodeJpeg(width, height, compression) { // int, int, int 1-100
    var frameData = new Buffer(width * height * 4);
    var i = 0;
    while (i < frameData.length) {
      frameData[i++] = 0xFF; // red
      frameData[i++] = 0x00; // green
      frameData[i++] = 0x00; // blue
      frameData[i++] = 0xFF; // alpha - ignored in JPEGs
    }
    var rawImageData = {
      data: frameData,
      width: width,
      height: height
    };
    var jpegImageData = jpeg.encode(rawImageData, compression);
    return jpegImageData;
}

class Frame {
	constructor() {
		this.strokes = [];
	}
}

class Layer {
    constructor() {
        this.frames = [];
    }

    getFrame(index) {
    	if (!this.frames[index]) {
    		//console.log("Client asked for frame " + index +", but it's missing.");
    		for (var i=0; i<index+1; i++) {
    			if (!this.frames[i]) {
    				var frame = new Frame();
    				this.frames.push(frame); 
    				//console.log("* Created frame " + i + ".");
    			}
    		}
    	}
        //console.log("Retrieving frame " + index + " of " + this.frames.length + ".");
        return this.frames[index];
    }

    addStroke(data) {
        //try {
    	var index = data["index"];
    	if (!isNaN(index)) {
    		this.getFrame(index); 

    		this.frames[index].strokes.push(data); 
            console.log("<<< Received a stroke with color (" + data["color"] + ") and " + data["points"].length + " points.");
    	}
        //} catch (e) {
            //console.log(e.data);
        //}
    }
}

var layer = new Layer();

setInterval(function() {
	var time = new Date().getTime();

	for (var i=0; i<layer.frames.length; i++) {
		for (var j=0; j<layer.frames[i].strokes.length; j++) {
			if (time > layer.frames[i].strokes[j]["timestamp"] + strokeLifetime) {
				layer.frames[i].strokes.splice(j, 1);
				console.log("X Removing frame " + i + ", stroke " + j + ".");
			}
		}
	}
}, strokeLifetime);

// ~ ~ ~ ~

// https://socket.io/get-started/chat/

io.on('connection', function(socket){
    console.log('A user connected.');
    //~
    socket.on('disconnect', function(){
        console.log('A user disconnected.');
    });
    //~
    socket.on("clientStrokeToServer", function(data) { 
    	//console.log(data);
        try { // json coming from Unity needs to be parsed...
            var newData = JSON.parse(data);
            layer.addStroke(newData);
        } catch (e) { // ...but json coming from JS client does not need to be
            layer.addStroke(data);
        }
    });
    //~
    socket.on("clientRequestFrame", function(data) {
        //console.log(data["num"]);
        var index = data["num"];
        if (index != NaN) {
        	var frame = layer.getFrame(index);
        	if (frame && frame.strokes.length > 0) {
        		io.emit("newFrameFromServer", frame.strokes);
                console.log("> > > Sending a new frame " + frame.strokes[0]["index"] + " with " + frame.strokes.length + " strokes.");
        	}
    	}
    });
});
