const express = require("express");
const mongoose = require("mongoose");
const User = require("../models/user");
const Review = require("../models/review");

const router = express.Router();

router.post('/submit_review', async (req, res) => {
    const { id, senderId, description, rating } = req.body;

    if (!id || !senderId || !description || !rating) {
        return res.status(400).json({ success: false, message: 'All fields are required' });
    }

    try {
        const newReview = new Review({
        id,
        senderId,
        description,
        rating,
        });

        await newReview.save();
        res.status(200).json({ success: true, message: 'Review submitted successfully' });
    } catch (err) {
        console.error('Error submitting review:', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
});

router.get('/reviews/:userId', async (req, res) => {
const userId = req.params.userId;

try {
    const reviews = await Review.find({ senderId: userId });
    res.status(200).json(reviews);
} catch (err) {
    console.error('Error fetching reviews:', err);
    res.status(500).json({ success: false, message: 'Server error' });
}
});

module.exports = router;