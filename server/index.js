const express = require("express");
const mongoose = require("mongoose");
const cors = require('cors');
const multer = require('multer');

const DB = "mongodb+srv://arbinstha71:Aabro098@cluster0.m51ocmp.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

const authRouter = require("./routes/auth");
const profile = require("./routes/profile");
const notification = require("./routes/notification");
const placesRoutes = require('./routes/maps_proxy');

const PORT = 3000;
const HOST = 'localhost';

const app = express();


app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(profile);
app.use(notification);
app.use(placesRoutes);

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
