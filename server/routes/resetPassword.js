const express = require('express');
const router = express.Router();
require('dotenv').config();
const nodemailer = require('nodemailer');
const ResetCode = require('../models/resetCode');

const transporter = nodemailer.createTransport({
    service: 'gmail',
    host: "smtp.gmail.com",
    port: 587,
    secure: false,
    auth: {
        user: process.env.USER,
        pass: process.env.APP_PASSWORD
    }
});

function generate4DigitCode() {
    return Math.floor(1000 + Math.random() * 9000);
}

router.post('/send-reset-code', async (req, res) => {
    try {
        const { email } = req.body;
        
        if (!email) {
            return res.status(400).json({ 
                success: false, 
                message: 'Email is required' 
            });
        }

        const resetCode = generate4DigitCode();
        
        await ResetCode.findOneAndDelete({ email });

        await ResetCode.create({
            email,
            code: resetCode.toString()
        });

        const mailOptions = {
            from: {
                name: 'EdVenture Support Team',
                address: process.env.USER
            },
            to: email,
            subject: '🔒 Reset Your Password - Code Inside!',
            html: `
                <div style="font-family: Arial, sans-serif; line-height: 1.6;">
                    <h2 style="color: #333;">Hello,</h2>
                    <p>We noticed that you requested to reset your EdVenture password. Please use the following code to reset it:</p>
                    <div style="font-size: 1.4em; font-weight: bold; color: #4CAF50; margin: 20px 0;">
                        Your Reset Code: <span>${resetCode}</span>
                    </div>
                    <p style="font-size: 0.9em; color: #777;">For your security, this code will expire in 10 minutes.<br>
                    If you did not request a password reset, please ignore this email.</p>
                    <br>
                    <p>Best Regards,<br>The EdVenture Support Team</p>
                </div>
            `
        };

        await transporter.sendMail(mailOptions);

        res.status(200).json({
            success: true,
            message: 'Reset code sent successfully',
            email: email
        });

    } catch (error) {
        console.error('Error sending reset code:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to send reset code'
        });
    }
});


router.post('/verify-code', async (req, res) => {
    try {
        const { email, code } = req.body;

        if (!email || !code) {
            return res.status(400).json({
                success: false,
                message: 'Email and code are required'
            });
        }

        const resetData = await ResetCode.findOne({ email });
        
        if (!resetData) {
            return res.status(400).json({
                success: false,
                message: 'No reset code found for this email or code has expired'
            });
        }

        if (resetData.code === code.toString()) {
            await ResetCode.deleteOne({ email });
            
            return res.status(200).json({
                success: true,
                message: 'Code verified successfully'
            });
        } else {
            return res.status(400).json({
                success: false,
                message: 'Invalid reset code'
            });
        }

    } catch (error) {
        console.error('Error verifying code:', error);
        res.status(500).json({
            success: false,
            message: 'Server error while verifying code'
        });
    }
});


router.post('/resend-code', async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({
                success: false,
                message: 'Email is required'
            });
        }

        await ResetCode.findOneAndDelete({ email });

        const resetCode = generate4DigitCode();
        
        await ResetCode.create({
            email,
            code: resetCode.toString()
        });

        const mailOptions = {
            from: {
                name: 'EdVenture Support Team',
                address: process.env.USER
            },
            to: email,
            subject: '🔒 Your New Reset Code',
            html: `
                <div style="font-family: Arial, sans-serif; line-height: 1.6;">
                    <h2 style="color: #333;">Hello,</h2>
                    <p>Here is your new password reset code:</p>
                    <div style="font-size: 1.4em; font-weight: bold; color: #4CAF50; margin: 20px 0;">
                        Your Reset Code: <span>${resetCode}</span>
                    </div>
                    <p style="font-size: 0.9em; color: #777;">For your security, this code will expire in 10 minutes.</p>
                    <br>
                    <p>Best Regards,<br>The EdVenture Support Team</p>
                </div>
            `
        };

        await transporter.sendMail(mailOptions);

        res.status(200).json({
            success: true,
            message: 'New reset code sent successfully',
            email: email
        });

    } catch (error) {
        console.error('Error resending code:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to resend reset code'
        });
    }
});

module.exports = router;