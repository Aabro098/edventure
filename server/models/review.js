const mongoose = require('mongoose');

const reviewSchema = mongoose.Schema({
  user: {
    type: Schema.Types.ObjectId,
    ref: 'User', 
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  rating: {
    type: Number,
    required: true,
    min: 1,
    max: 5,
  },
});

const Review = mongoose.model('Review', reviewSchema);

module.exports = Review;
