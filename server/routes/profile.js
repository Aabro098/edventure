const express = require('express');
const jwt = require('jsonwebtoken');
const router = express.Router();
const User = require('../models/user'); 

router.get('/user/:id', async (req, res) => {
    try {
        const user = await User.findById(req.params.id).select('-password');

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        const userData = user.toObject(); 
        userData.id = userData._id.toString(); 
        delete userData._id; 

        res.json(userData);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching user data' });
    }
});


router.get('/search', async (req, res) => {
    try {
        console.log('Search endpoint hit');
        const { query } = req.query;

        if (!query) {
            return res.status(400).json({ error: 'Query parameter is required' });
        }

        const users = await User.find({
            $or: [
                { name: { $regex: query, $options: 'i' } },
                { username: { $regex: query, $options: 'i' } }
            ]
        }).select('name username profileImage bio _id');

        const usersWithId = users.map(user => ({
            id: user._id.toString(),
            name: user.name,
            username: user.username,
            profileImage: user.profileImage,
            bio: user.bio
        }));

        res.json(usersWithId);
    } catch (error) {
        console.error('Error searching for users:', error);
        res.status(500).json({ error: 'Error searching for users' });
    }
});

module.exports = router;

