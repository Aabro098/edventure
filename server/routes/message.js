
const express = require('express');
const Message = require('../models/Message');
const router = express.Router();

router.post('/messages', async (req, res) => {
  const { sourceId, targetId, message } = req.body;

  try {
    const newMessage = new Message({
      sourceId,
      targetId,
      message,
    });

    await newMessage.save();
    res.status(201).json(newMessage);
  } catch (error) {
    res.status(500).json({ message: 'Failed to save message', error });
  }
});


router.get('/messages/:sourceId/:targetId', async (req, res) => {
  const { sourceId, targetId } = req.params;

  try {
    const messages = await Message.find({
      $or: [
        { sourceId, targetId },
        { sourceId: targetId, targetId: sourceId },
      ],
    }).sort({ timestamp: 1 }); 

    res.status(200).json(messages);
  } catch (error) {
    res.status(500).json({ message: 'Failed to fetch messages', error });
  }
});

module.exports = router;
