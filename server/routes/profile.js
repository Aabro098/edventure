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
        res.json(userData);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching user data' });
    }
});


router.get('/search', async (req, res) => {
    try {
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

        res.json(users);
    } catch (error) {
        console.error('Error searching for users:', error);
        res.status(500).json({ error: 'Error searching for users' });
    }
});

router.get('/users', async (req, res) => {
    const currentUserId = req.query.userId; 

    try {
        const users = await User.find({ _id: { $ne: currentUserId } }); 
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: 'Failed to fetch users', error });
    }
});


router.post('/add/skills', async (req, res) => {
  const { userId, skill } = req.body;

  if (!skill || skill.length > 20) {
    return res.status(400).send('Skill must be 20 characters or less.');
  }

  try {
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).send('User not found.');
    }

    if (!user.skills.includes(skill)) {
      user.skills.push(skill);
      await user.save();
      res.status(200).send('Skill added successfully.');
    } else {
      res.status(400).send('Skill already exists.');
    }
  } catch (error) {
    console.error(error);
    res.status(500).send('Server error.');
  }
});


router.delete('/delete/skills', async (req, res) => {
  const { userId, skill } = req.body;

  if (!skill || skill.length > 20) {
    return res.status(400).send('Skill must be 20 characters or less.');
  }

  try {
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).send('User not found.');
    }

    const skillIndex = user.skills.indexOf(skill);

    if (skillIndex === -1) {
      return res.status(400).send('Skill not found.');
    }

    user.skills.splice(skillIndex, 1);
    await user.save();

    res.status(200).send('Skill removed successfully.');
  } catch (error) {
    console.error(error);
    res.status(500).send('Server error.');
  }
});


router.put('/updateGender', async (req, res) => {
  const { userId, gender } = req.body;

  try {
    if (!['Male', 'Female', 'Others', 'None'].includes(gender)) {
      return res.status(400).json({ error: 'Invalid gender value' });
    }

    const updatedUser = await User.findByIdAndUpdate(
      userId,
      { gender },
      { new: true } 
    );

    if (!updatedUser) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json(updatedUser);
  } catch (error) {
    console.error('Error in /updateGender:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});


module.exports = router;
