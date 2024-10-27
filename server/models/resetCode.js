const mongoose = require('mongoose');

const resetCodeSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
        unique: true
    },
    code: {
        type: String,
        required: true
    },
    timestamp: {
        type: Date,
        default: Date.now,
        expires: 600 
    }
});

module.exports = mongoose.model('ResetCode', resetCodeSchema);