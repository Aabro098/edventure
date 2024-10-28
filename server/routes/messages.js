const express = require('express');
const Message = require('../models/Message');
const User = require('../models/user'); 
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
        .lean(); 

        res.status(200).json(messages);
    } catch (error) {
        console.error('Error fetching messages:', error);
        res.status(500).json({ message: 'Failed to fetch messages', error: error.message });
    }
});

router.get('/recent-chats/:userId', async (req, res) => {
    const { userId } = req.params;

    try {
        const recentMessages = await Message.aggregate([
            {
                $match: {
                    $or: [
                        { targetId: userId },
                        { sourceId: userId }
                    ]
                }
            },
            {
                $sort: { timestamp: -1 }
            },
            {
                $group: {
                    _id: {
                        $cond: [
                            { $eq: ['$sourceId', userId] },
                            '$targetId',
                            '$sourceId'
                        ]
                    },
                    lastMessage: { $first: '$$ROOT' }, 
                    lastMessageTime: { $first: '$timestamp' }
                }
            },
            {
                $sort: { lastMessageTime: -1 } 
            }
        ]);

        const senderIds = recentMessages.map(chat => chat._id);

        const users = await User.find({
            _id: { $in: senderIds }
        }).select('name email username bio address about rating numberRating education status type isVerified isAvailable');  

        const recentChats = users.map(user => {
            const recentMessage = recentMessages.find(msg => msg._id.toString() === user._id.toString());
            return {
                user: {
                    _id: user._id,
                    name: user.name,
                    email: user.email,
                    username: user.username,
                    bio: user.bio,
                    address: user.address,
                    about: user.about,
                    rating: user.rating,
                    numberRating: user.numberRating,
                    education: user.education,
                    status: user.status,
                    type: user.type,
                    isVerified: user.isVerified,
                    isAvailable: user.isAvailable
                },
                lastMessage: recentMessage?.lastMessage?.message || '',
                lastMessageTime: recentMessage?.lastMessageTime || null,
            };
        });

        res.status(200).json(recentChats);
    } catch (error) {
        console.error('Error fetching recent chats:', error);
        res.status(500).json({ 
            message: 'Failed to fetch recent chats', 
            error: error.message 
        });
    }
});

module.exports = router;