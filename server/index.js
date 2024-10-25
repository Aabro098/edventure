const express = require("express");
const mongoose = require("mongoose");
const cors = require('cors');
const http = require("http");  

const DB = "mongodb+srv://arbinstha71:Aabro098@cluster0.m51ocmp.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

const authRouter = require("./routes/auth");
const profile = require("./routes/profile");
const notification = require("./routes/notification");
const review = require("./routes/review");
const Message = require("./models/Message");

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

const clients = {};

io.on("connection", (socket) => {
    console.log("Socket connected:", socket.id);

    socket.on("/test", (id) => {
        console.log("Registered client ID:", id);
        clients[id] = socket;
        console.log("Current connected clients:", Object.keys(clients));
    });

    socket.on("message", async (msg) => {
        console.log("Received message:", msg);
        const { sourceId, targetId, message } = msg;

        try {
            if (!sourceId || !targetId || !message) {
                throw new Error("Invalid message format");
            }

            const newMessage = new Message({ sourceId, targetId, message });
            await newMessage.save();
            console.log("Message saved to DB:", newMessage);

            if (clients[targetId]) {
                clients[targetId].emit("message", msg);
                console.log(`Message emitted to client ${targetId}:`, msg);
            } else {
                console.error("Target client not connected:", targetId);
            }

        } catch (error) {
            console.error("Error in message handler:", error.message || error);
        }
    });

    socket.on("disconnect", () => {
        console.log("Socket disconnected:", socket.id);

        for (const id in clients) {
            if (clients[id] === socket) {
                console.log("Removing client ID:", id);
                delete clients[id];
                break;
            }
        }

        console.log("Updated clients after disconnect:", Object.keys(clients));
    });
});

server.listen(PORT, () => {
    console.log(`Server is running on http://${HOST}:${PORT}`);
});
