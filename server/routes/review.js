const express = require("express");
const mongoose = require("mongoose");
const User = require("../models/user");
const Review = require("../models/review");

const router = express.Router();


router.post('/submit_review', async (req, res) => {
    console.log('Request body:', req.body);
    const { _id, senderId, description, rating } = req.body;  // Changed from id to _id
  
    if (!_id || !senderId || !description || !rating) {
      return res.status(400).json({ success: false, message: 'All fields are required' });
    }
  
    try {
      // Ensure _id and senderId are ObjectIds using mongoose.Types.ObjectId()
      const userId = mongoose.Types.ObjectId(_id);  // Changed from id to _id
      const senderIdObj = mongoose.Types.ObjectId(senderId);
      
      // Create and save the new review
      const newReview = new Review({
        id: userId,  // Keep as id since that's how it's defined in your schema
        senderId: senderIdObj,
        description,
        rating,
      });
  
      await newReview.save();
  
      // Find the user being reviewed
      const user = await User.findById(userId);
  
      if (!user) {
        return res.status(404).json({ success: false, message: 'User not found' });
      }
  
      // Rest of your code remains the same...
      user.review.push(newReview._id);
      user.rating = (user.rating * user.numberRating + rating) / (user.numberRating + 1);
      user.numberRating += 1;
  
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

        await Review.findByIdAndDelete(reviewId);

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