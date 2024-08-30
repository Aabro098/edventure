const mongoose = require('mongoose');

const NotificationSchema = new mongoose.Schema({
    sender: { 
      type: String, 
      required: true 
    },
    message: { 
      type: String, 
      required: true 
    },
    dateTime: { 
      type: Date, default: Date.now 
    },
});

module.exports = mongoose.model('Notification', NotificationSchema);
