#!/usr/bin/env node

/*jslint
    node
*/

/**
 * Module dependencies.
 */

import app from "../index.js";
import debug_module from "debug";
const debug = debug_module("node-nlp:server");
import http from "http";

/**
 * Get port from environment and store in Express.
 */

/**
 * Normalize a port into a number, string, or false.
 */

function normalizePort(val) {
    "use strict";
    const port = parseInt(val, 10);

    if (Number.isNaN(port)) {
        // named pipe
        return val;
    }

    if (port >= 0) {
        // port number
        return port;
    }

    return false;
}

const PORT = normalizePort(process.env.PORT || "3000");
app.set("port", PORT);

/**
 * Create HTTP server.
 */

const server = http.createServer(app);

/**
 * Event listener for HTTP server "error" event.
 */

function onError(error) {
    "use strict";
    if (error.syscall !== "listen") {
        throw error;
    }
    const bind = typeof PORT === "string"
        ? "Pipe " + PORT
        : "Port " + PORT;

    // handle specific listen errors with friendly messages
    switch (error.code) {
    case "EACCES":
        console.error(bind + " requires elevated privileges");
        process.exit(1);
        break;
    case "EADDRINUSE":
        console.error(bind + " is already in use");
        process.exit(1);
        break;
    default:
        throw error;
    }
}

/**
 * Event listener for HTTP server "listening" event.
 */

function onListening() {
    "use strict";
    const addr = server.address();
    const bind = typeof addr === "string"
        ? "pipe " + addr
        : "port " + addr.port;
    debug("Listening on " + bind);
}

/**
 * Listen on provided port, on all network interfaces.
 */

server.listen(PORT);
server.on("error", onError);
server.on("listening", onListening);
