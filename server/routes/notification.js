const express = require("express");
const mongoose = require("mongoose");
const User = require("../models/user");
const Notification = require("../models/notification");

const router = express.Router();

router.post('/user/:userId/add_notifications', async (req, res) => {
    try {
        const { userId } = req.params;
        const { senderId, message, responseStatus, notificationStatus, dateTime } = req.body;

        if (!senderId || !message) {
            return res.status(400).json({ message: "Missing required fields" });
        }

        const notification = new Notification({
            sender: senderId, 
            message: message,
            responseStatus: responseStatus,
            notificationStatus: notificationStatus,
            dateTime: new Date(dateTime), 
        });

        await notification.save();

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        user.notifications.push(notification._id); 
        await user.save();

        res.status(201).json({ message: "Notification added successfully" });
    } catch (error) {
        console.error('Error adding notification:', error); 
        res.status(500).json({ message: "Server error", error: error.message });
    }
});


router.get('/notifications/:userId', async (req, res) => {
    try {
        const userId = new mongoose.Types.ObjectId(req.params.userId);
        const user = await User.findById(userId)
            .populate({
                path: 'notifications',
                options: { sort: { dateTime: -1 } },
                select: 'sender message notificationStatus responseStatus dateTime' 
            });

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.json(user.notifications);
    } catch (error) {
        res.status(500).json({ error: 'Server error', details: error.message });
    }
});

router.patch('/notifications/:id', async (req, res) => {
    try {
      const notification = await Notification.findById(req.params.id);
      if (!notification) {
        return res.status(404).send({ error: 'Notification not found' });
      }
  
      if (req.body.notificationStatus !== undefined) {
        notification.notificationStatus = req.body.notificationStatus;
      }
  
      await notification.save();
      res.send(notification);
    } catch (error) {
      res.status(400).send(error);
    }
});


module.exports = router;
