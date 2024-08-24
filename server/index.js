const express = require("express");
const mongoose = require("mongoose");
const cors = require('cors');
const multer = require('multer');

const DB = "mongodb+srv://arbinstha71:Aabro098@cluster0.m51ocmp.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

const authRouter = require("./routes/auth");

const PORT = 3000;
const HOST = 'localhost';

const app = express();


app.use(cors());
app.use(express.json());
app.use(authRouter);

mongoose
    .connect(DB)
    .then(() => {
        console.log("Connection Successful");
    }).catch((e) => {
        console.log(e);
    })

app.listen(PORT,HOST,() => {
    console.log(`Server is running on http://${HOST}:${PORT}`);
});
