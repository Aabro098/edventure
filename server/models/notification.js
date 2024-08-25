const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const NotificationSchema = new Schema({
  userName: {
    type: String,
    required: true
  },
  photo: {
    type: String,
    required: true
  },
  notificationMessage: {
    type: String,
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const Notification = mongoose.model('Notification', NotificationSchema);
module.exports = Notification;
