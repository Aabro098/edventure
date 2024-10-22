const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const MessageSchema = new Schema({
  senderId: {
    type: String,
    required: true,
  },
  senderSocketId: {
    type: String, 
    required: true,
  },
  recipientId: {
    type: String,
    required: true,
  },
  recipientSocketId: {
    type: String, 
    required: true,
  },
  message: {
    type: String,
    required: true,
  },
  timestamp: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Message', MessageSchema);
