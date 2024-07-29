const express = require("express");
const mongoose = require("mongoose");
const http = require("http");

const DB = "mongodb+srv://arbinstha71:Aabro098@cluster0.m51ocmp.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

const authRouter = require("./routes/auth");

const PORT = 3000;

const app = express();

app.use(authRouter);

mongoose
    .connect(DB)
    .then(() => {
        console.log("Connection Successful");
    }).catch((e) => {
        console.log(e);
    })

app.listen(PORT, () => {
    console.log(`Connected to the port ${PORT}`);
});
