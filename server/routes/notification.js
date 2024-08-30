const express = require("express");
const mongoose = require("mongoose");
const User = require("../models/user");
const Notification = require("../models/notification");

const router = express.Router();

router.post('/user/:userId/add_notifications', async (req, res) => {
    try {
        const { userId } = req.params;
        const { senderId, message } = req.body;

        const notification = new Notification({
            sender: senderId,
            message: message,
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


router.get('/user/notifications/:userId', async (req, res) => {
    const { userId } = req.params;
    try {
        const user = await User.findById(userId).populate({
            path: 'notifications',
            options: { sort: { dateTime: -1 } } 
        });

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.json(user.notifications);
    } catch (error) {
        console.error('Error fetching notifications:', error); 
        res.status(500).json({ error: 'Server error', details: error.message });
    }
});

module.exports = router;
