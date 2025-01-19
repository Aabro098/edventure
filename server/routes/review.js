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

        const user = await User.findById(id);

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        user.review.push(newReview._id);
        const totalRating = user.rating + rating;
        const numberRatingCount = user.numberRating + 1 ;
        user.rating = totalRating;
        user.numberRating = numberRatingCount;

        await user.save();

        res.status(200).json({ success: true, message: 'Review submitted successfully' });
    } catch (err) {
        console.error('Error submitting review:', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
});

router.delete('/delete_review', async (req, res) => {
    const { reviewId, userId, senderId, rating } = req.body;

    if (!reviewId || !userId || !senderId || !rating) {
        return res.status(400).json({ success: false, message: 'All fields are required' });
    }

    try {
        const review = await Review.findById(reviewId);

        if (!review) {
            return res.status(404).json({ success: false, message: 'Review not found' });
        }

        const user = await User.findById(userId);

        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        user.review.pull(reviewId);

        const totalRating = user.rating - rating;
        const numberRatingCount = user.numberRating - 1;

        user.rating = totalRating;
        user.numberRating = numberRatingCount;

        await user.save();

        await review.remove();

        res.status(200).json({ success: true, message: 'Review deleted and ratings updated successfully' });
    } catch (err) {
        console.error('Error deleting review:', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
});


router.get('/reviews/:userId', async (req, res) => {
    const userId = req.params.userId;

    try {
        const user = await User.findById(userId).populate('review');
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        res.status(200).json(user.review);
    } catch (err) {
        console.error('Error fetching reviews:', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
});


module.exports = router;