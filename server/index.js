require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const cors = require('cors');
const http = require("http"); 
const path = require("path");

const DB = process.env.DB;

const Message = require('./models/Message');

const authRouter = require("./routes/auth");
const profile = require("./routes/profile");
const resetPassword = require("./routes/resetPassword");
const review = require("./routes/review");
const messageRouter = require("./routes/messages");
const addressRouter = require("./routes/teaching");
const contacts = require("./routes/contacts");

const PORT = process.env.PORT || 3000;
const HOST = '192.168.61.104';

const app = express();
app.use('/uploads', express.static('uploads'));

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
app.use(review);
app.use(messageRouter);  
app.use(resetPassword);
app.use(addressRouter);
app.use(contacts);


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

server.listen(PORT,'0.0.0.0', () => {
    console.log(`Server is running on http://${HOST}:${PORT}`);
});