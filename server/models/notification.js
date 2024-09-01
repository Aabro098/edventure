const mongoose = require('mongoose');

const NotificationSchema = new mongoose.Schema({
  sender: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  message: { type: String, required: true },
  notificationStatus: { type: Boolean, default: false },
  responseStatus: { type: Boolean, default: false },
  dateTime: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Notification', NotificationSchema);
