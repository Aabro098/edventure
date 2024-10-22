const express = require("express");
const mongoose = require("mongoose");
const User = require("../models/user");
const messenger = require("../models/messenger");


io.on("connection", (socket) => {
  
  // Assuming `user_connected` sends userId and socketId
  socket.on("user_connected", async (userData) => {
    const { userId } = userData;
    // Store or manage user connection
  });

  // Handle sending a private message
  socket.on("send_private_message", async (data) => {
    const { senderId, recipientId, message } = data;

    // Look up the recipient by recipientId (assume you have a user store or database)
    const recipient = users[recipientId]; // Use your stored user data

    if (recipient && recipient.socketId) {
      // Emit the private message to the recipient's socket
      io.to(recipient.socketId).emit("receive_private_message", {
        message,
        senderId: data.senderId,
      });

      // Save the message to MongoDB including the socket IDs
      const newMessage = new Message({
        senderId: senderId,
        senderSocketId: socket.id, // Sender's socketId
        recipientId: recipientId,
        recipientSocketId: recipient.socketId, // Recipient's socketId
        message: message,
      });

      await newMessage.save();
      console.log("Message saved to database.");
    } else {
      console.log("Recipient not connected.");
    }
  });

  socket.on("disconnect", () => {
    // Handle disconnects
  });
});
