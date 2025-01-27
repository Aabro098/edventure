const express = require('express');
const User = require('../models/user'); 
const router = express.Router();


router.post('/updateContacts', async (req, res) => {
    const { userId, newContactId } = req.body;

    try {
        const user = await User.findById(userId);

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        if (!user.contacts.includes(newContactId)) {
            user.contacts.push(newContactId); 
        } else {
            const contactIndex = user.contacts.indexOf(newContactId);
            user.contacts.splice(contactIndex, 1); 
            user.contacts.push(newContactId); 
        }

        if (user.contacts.length > 30) {
            user.contacts.shift();
        }

        await user.save();

        return res.status(200).json({ message: 'Contacts updated successfully', user });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'Error updating contacts', error });
    }
});


router.get('/getContacts/:userId', async (req, res) => {
    const { userId } = req.params;

    try {
        const user = await User.findById(userId).populate('contacts'); 

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        const sortedContacts = [...user.contacts].reverse(); 

        return res.status(200).json({ message: 'Contacts fetched successfully', contacts: sortedContacts });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'Error fetching contacts', error });
    }
});


module.exports = router;
