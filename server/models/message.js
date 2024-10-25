const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
    sourceId: {
        type: String,
        required: true
    },
    targetId: {
        type: String,
        required: true
    },
    message: {
        type: String,
        required: true
    },
    timestamp: {
        type: Date,
        default: Date.now
    }
});

const Message = mongoose.model('Message', messageSchema);
module.exports = Message;