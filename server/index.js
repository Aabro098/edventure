const express = require("express");
const mongoose = require("mongoose");
const cors = require('cors');
const http = require("http");

const DB = "mongodb+srv://arbinstha71:Aabro098@cluster0.m51ocmp.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
const Message = require('./models/Message');

const authRouter = require("./routes/auth");
const profile = require("./routes/profile");
const notification = require("./routes/notification");
const review = require("./routes/review");
const messageRouter = require("./routes/messages");

const PORT = process.env.PORT || 3000;
const HOST = '192.168.1.5';

const app = express();
const server = http.createServer(app);
const io = require('socket.io')(server, {
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
app.use(messageRouter);  

mongoose
    .connect(DB)
    .then(() => {
        console.log("Connection Successful");
    })
    .catch((e) => {
        console.log(e);
    });

const clients = new Map();

io.on("connection", (socket) => {
    console.log("Socket connected:", socket.id);

    socket.on("/test", (id) => {
        console.log("Registered client ID:", id);
        clients.set(id, socket);
        console.log("Current connected clients:", Array.from(clients.keys()));
    });

    socket.on("message", async (msg) => {
        console.log("Received message:", msg);
        const { sourceId, targetId, message } = msg;

        try {
            if (!sourceId || !targetId || !message) {
                throw new Error("Invalid message format");
            }

            const newMessage = new Message({
                sourceId,
                targetId,
                message,
                timestamp: new Date()
            });

            await newMessage.save();
            console.log("Message saved to DB:", newMessage);

            // Send to target client if online
            const targetSocket = clients.get(targetId);
            if (targetSocket) {
                targetSocket.emit("message", {
                    message: message,
                    sourceId: sourceId,
                    targetId: targetId,
                    timestamp: newMessage.timestamp
                });
                console.log(`Message sent to client ${targetId}`);
            } else {
                console.log(`Target client ${targetId} not connected. Message stored in DB.`);
            }
        } catch (error) {
            console.error("Error in message handler:", error);
            socket.emit("error", {
                message: "Error processing message",
                error: error.message
            });
        }
    });

    socket.on("disconnect", () => {
        console.log("Socket disconnected:", socket.id);
        
        for (const [id, sock] of clients.entries()) {
            if (sock === socket) {
                clients.delete(id);
                console.log("Removing client ID:", id);
                break;
            }
        }
        
        console.log("Updated clients after disconnect:", Array.from(clients.keys()));
    });
});

server.listen(PORT, () => {
    console.log(`Server is running on http://${HOST}:${PORT}`);
});