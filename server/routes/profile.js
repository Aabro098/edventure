const express = require('express');
const jwt = require('jsonwebtoken');
const router = express.Router();
const User = require('../models/user'); 

// Fetch user data by ID
router.get('/user/:id', async (req, res) => {
    try {
        const user = await User.findById(req.params.id).select('-password'); // Corrected from _id to id

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        const userData = user.toObject();
        res.json(userData);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching user data' });
    }
});

// Search for users excluding the current user
router.get('/search', async (req, res) => {
    try {
        console.log('Search endpoint hit');
        const { query, userId } = req.query; 

        if (!query || !userId) {
            return res.status(400).json({ error: 'Query and userId parameters are required' });
        }

        const users = await User.find({
            _id: { $ne: userId }, 
            $or: [
                { name: { $regex: query, $options: 'i' } },
                { username: { $regex: query, $options: 'i' } }
            ]
        }).select('name username profileImage bio _id'); 

        console.log(users);
        res.json(users);
    } catch (error) {
        console.error('Error searching for users:', error);
        res.status(500).json({ error: 'Error searching for users' });
    }
});

module.exports = router;
