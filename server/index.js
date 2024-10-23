const express = require("express");
const mongoose = require("mongoose");
const cors = require('cors');
const http = require("http");  

const DB = "mongodb+srv://arbinstha71:Aabro098@cluster0.m51ocmp.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

const authRouter = require("./routes/auth");
const profile = require("./routes/profile");
const notification = require("./routes/notification");
const review = require("./routes/review");

const PORT = process.env.PORT || 3000;
const HOST = '192.168.1.5';

const app = express();
var server = http.createServer(app);
var io = require('socket.io')(server, {
    cors: {
        origin: '*',
    },
});

app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(profile);
app.use(notification);
app.use(review);

mongoose
    .connect(DB)
    .then(() => {
        console.log("Connection Successful");
    }).catch((e) => {
        console.log(e);
});

io.on("connection", socket => {  
    console.log("Socket connected");
    console.log(socket.id ,'has joined');
    socket.on("/test",(msg)=>{
        console.log(msg);        
    })
});

server.listen(PORT, () => {
    console.log(`Server is running on http://${HOST}:${PORT}`);
});
