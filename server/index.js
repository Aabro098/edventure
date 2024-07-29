

const express = require("express");
const mongoose = require("mongoose");
const http = require("http");

const PORT = 3000;

const app = express();

app.listen(PORT, "" , () => {
    console.log(`Connnected to the port ${PORT}`);
})