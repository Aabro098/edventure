const express = require('express');
const Message = require('../models/Message');
const router = express.Router();

router.post('/messages', async (req, res) => {
    try {
        const { sourceId, targetId, message } = req.body;
        
        if (!sourceId || !targetId || !message) {
            return res.status(400).json({ message: 'Missing required fields' });
        }

        const newMessage = new Message({
            sourceId,
            targetId,
            message,
            timestamp: new Date()
        });

        await newMessage.save();
        res.status(201).json(newMessage);
    } catch (error) {
        console.error('Error saving message:', error);
        res.status(500).json({ message: 'Failed to save message', error: error.message });
    }
});


router.get('/messages/:sourceId/:targetId', async (req, res) => {
    const { sourceId, targetId } = req.params;

    try {
        const messages = await Message.find({
            $or: [
                { sourceId, targetId },
                { sourceId: targetId, targetId: sourceId }
            ]
        })
        .sort({ timestamp: -1 }) 
        .lean(); 

        res.status(200).json(messages);
    } catch (error) {
        console.error('Error fetching messages:', error);
        res.status(500).json({ message: 'Failed to fetch messages', error: error.message });
    }
});

module.exports = router;