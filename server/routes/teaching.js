const express = require('express');
const mongoose = require('mongoose');
const User = require('../models/user'); 
const router = express.Router();


router.post('/addTeachingAddress', async (req, res) => {
  const { userId, address } = req.body;

  if (!userId || !address) {
    return res.status(400).json({ error: 'userId and address are required.' });
  }

  try {
    const user = await User.findByIdAndUpdate(
      userId,
      { $push: { teachingAddress: address } }, 
      { new: true } 
    );

    if (!user) {
      return res.status(404).json({ error: 'User not found.' });
    }

    res.status(200).json({
      message: 'Teaching address added successfully.',
      user,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while adding the address.' });
  }
});


router.delete('/deleteTeachingAddress', async (req, res) => {
  const { userId, address } = req.body;

  if (!userId || !address) {
    return res.status(400).json({ error: 'userId and address are required.' });
  }

  try {
    const user = await User.findByIdAndUpdate(
      userId,
      { $pull: { teachingAddress: address } }, 
      { new: true } 
    );

    if (!user) {
      return res.status(404).json({ error: 'User not found.' });
    }

    res.status(200).json({
      message: 'Teaching address deleted successfully.',
      user,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while deleting the address.' });
  }
});


router.post('/getUnverifiedUsers', async (req, res) => {
  const { userId, address } = req.body;

  try {
      let objectIdUserId;
      try {
          objectIdUserId = new mongoose.Types.ObjectId(userId);
      } catch (error) {
          return res.status(400).json({ message: 'Invalid user ID format' });
      }

      const users = await User.find({
          isVerified: false,
          _id: { $ne: objectIdUserId }, 
          teachingAddress: { $in: [address] }, 
      });

      if (users.length > 0) {
          return res.status(200).json({ users });
      } else {
          return res.status(404).json({
              message: 'No users found with the provided address.',
          });
      }
  } catch (err) {
      console.error('Error in getVerifiedUsers:', err);
      return res.status(500).json({ message: 'Server error' });
  }
});


router.post('/getVerifiedUsers', async (req, res) => {
    const { userId, address } = req.body;

    try {
        let objectIdUserId;
        try {
            objectIdUserId = new mongoose.Types.ObjectId(userId);
        } catch (error) {
            return res.status(400).json({ message: 'Invalid user ID format' });
        }

        const users = await User.find({
            isVerified: true,
            _id: { $ne: objectIdUserId }, 
            teachingAddress: { $in: [address] }, 
        });

        if (users.length > 0) {
            return res.status(200).json({ users });
        } else {
            return res.status(404).json({
                message: 'No verified users found with the provided address.',
            });
        }
    } catch (err) {
        console.error('Error in getVerifiedUsers:', err);
        return res.status(500).json({ message: 'Server error' });
    }
});


router.post('/filterUsers', async (req, res) => {
  try {
    const { userId, address, filters } = req.body;

    if (!filters || typeof filters !== 'object') {
      return res.status(400).json({ error: 'Invalid filter parameters' });
    }

    const objectIdUserId = new mongoose.Types.ObjectId(userId);

    const baseQuery = { teachingAddress: address };

    if (filters.gender) {
      baseQuery.gender = { $eq: filters.gender };
    }

    if (filters.skills && Array.isArray(filters.skills)) {
      baseQuery.skills = { $in: filters.skills.map(skill => new RegExp(skill, 'i')) };
    }

    const [verifiedUsers, unverifiedUsers] = await Promise.all([
      User.find({ 
        ...baseQuery, 
        _id: { $ne: objectIdUserId },
        isVerified: true 
      }).select('-password'),
      User.find({ 
        ...baseQuery,
        _id: { $ne: objectIdUserId }, 
        isVerified: false 
      }).select('-password'),
    ]);

    res.json({
      verifiedUsers,
      unverifiedUsers,
    });
  } catch (error) {
    console.error('Error in /filterUsers:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});


router.post('/enroll', async (req, res) => {
  const { userId, classId } = req.body;
  console.log(req.body);

  try {
    const user = await User.findById(userId);
    console.log(user);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    if (user.enrolledClasses.includes(classId)) {
      return res.status(400).json({ message: 'User is already enrolled in this class' });
    }

    user.enrolledClasses.push(classId);

    await user.save();
    console.log(res.statusCode);
    res.status(200).json({ message: 'Successfully enrolled in the class' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'An error occurred while enrolling the user' });
  }
});


module.exports = router;
