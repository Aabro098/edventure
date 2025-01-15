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


module.exports = router;
