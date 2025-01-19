const express = require("express");
const User = require("../models/user");
const bcryptjs = require('bcryptjs');
const jwt = require("jsonwebtoken");
const multer = require('multer');
const path = require('path');
const cors = require('cors');
const fs = require('fs');

const authRouter = express.Router();

const app = express();
app.use(cors());

app.use('/uploads', express.static(path.join(__dirname, '..', 'uploads')));

const auth = require("../middleware/auth");

authRouter.post('/api/signup' , async (req,res) =>{
    try{
        const {name , email , password} = req.body;
        const existingUser = await User.findOne({email});

        if(existingUser){
            return res
            .status(400)
            .json({msg : "User with same email already exist"});
        }

        const hashedPassword = await bcryptjs.hash(password , 8);

        let user = new User({
            email , 
            password : hashedPassword,
            name,
        })
        user = await user.save();
        res.status(200).json(user);
    }catch(e){
        res.status(500).json({error : e.message});
    }
});

authRouter.post('/api/signin' , async (req,res) =>{
    try{
        const {email , password} = req.body;
        const user = await User.findOne({email});

        if(!user){
            return res
            .status(400)
            .json({msg : "User does not exist"});
        }

        const isMatch = await bcryptjs.compare(password , user.password);

        if(!isMatch){
            return res
            .status(400)
            .json({msg : "Incorrect password"});
        }

        const token = jwt.sign({id : user._id},"passwordKey");

        res.json({token , ...user._doc});

    }catch(e){
        res.status(500).json({error : e.message});
    }
});

authRouter.post('/isTokenValid' , async (req,res) =>{
    try{
        const token = req.header('x-auth-token');
        if(!token){
            return res
            .json(false);
        }
        const verified = jwt.verify(token , "passwordKey");
        if(!verified){
            return res
            .json(false);
        }

        const user = await User.findById(verified.id);
        if(!user){
            return res
            .json(false);
        }

        res.json(true);

    }catch(e){
        res.status(500).json({error : e.message});
    }
});

authRouter.get('/', auth , async (req,res)=>{
    const user = await User.findById(req.user);
    res.json({...user._doc , token : req.token});
});


authRouter.put('/api/update', auth, async (req, res) => {
    try {
        if (!req.user) {
            return res.status(401).json({
                success: false,
                message: 'No user ID found in request'
            });
        }

        const user = await User.findById(req.user); 
        console.log('Found user:', user);
        
        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'User not found'
            });
        }

        const allowedUpdates = ['email', 'name', 'phone', 'address', 'education', 'bio', 'about'];
        Object.keys(req.body).forEach(key => {
            if (allowedUpdates.includes(key)) {
                user[key] = req.body[key];
            }
        });

        await user.save();

        res.status(200).json({
            success: true,
            message: 'Profile updated successfully',
            user: user
        });
    } catch (err) {
        console.error('Update error:', err);
        
        res.status(500).json({
            success: false,
            message: 'Error updating profile',
            error: err.message
        });
    }
});


const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/');
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + path.extname(file.originalname)) 
    }
});

const upload = multer({
    storage: storage,
});


authRouter.put('/api/updateProfile', auth, upload.single('profileImage'), async (req, res) => {
    let oldImagePath = null;

    try {
        if (!req.user) {
            return res.status(401).json({
                success: false,
                message: 'No user ID found in request'
            });
        }

        const user = await User.findById(req.user);
        if (!user) {
            throw new Error('User not found');
        }

        console.log('Processing update for user:', user._id);
        console.log('New file received:', req.file);
        console.log('Current profile image:', user.profileImage);

        if (req.file && user.profileImage) {
            try {
                oldImagePath = path.join(__dirname, '..', user.profileImage);
                console.log('Attempting to delete old image at:', oldImagePath);
                
                const fileExists = await fs.access(oldImagePath)
                    .then(() => true)
                    .catch(() => false);

                if (fileExists) {
                    await fs.unlink(oldImagePath);
                    console.log('Successfully deleted old image');
                } else {
                    console.log('Old image file not found');
                }
            } catch (error) {
                console.error('Error while handling old image:', {
                    errorMessage: error.message,
                    errorCode: error.code,
                    errorPath: error.path,
                    errorStack: error.stack
                });
            }
        }

        if (req.file) {
            const normalizedPath = req.file.path.replace(/\\/g, '/');
        
            user.profileImage = normalizedPath.split('uploads/')[1] 
                ? `uploads/${normalizedPath.split('uploads/')[1]}`
                : normalizedPath;
            
            console.log('New profile image path:', user.profileImage);
        }

        await user.save();

        const profileImageUrl = req.file 
            ? `${req.protocol}://${req.get('host')}/${user.profileImage}`
            : null;

        res.status(200).json({
            success: true,
            message: 'Profile image updated successfully',
            profileImageUrl
        });

    } catch (error) {
        console.error('Profile update error:', {
            errorMessage: error.message,
            errorStack: error.stack,
            userId: req.user
        });

        if (req.file) {
            try {
                await fs.unlink(req.file.path);
                console.log('Cleaned up new file after error');
            } catch (unlinkError) {
                console.error('Error cleaning up new file:', unlinkError);
            }
        }

        res.status(500).json({
            success: false,
            message: 'Error updating profile image',
            error: error.message
        });
    }
});


authRouter.delete('/deleteProfileImage', auth, async (req, res) => {
    try {
        if (!req.user) {
            return res.status(401).json({
                success: false,
                message: 'No user ID found in request',
            });
        }

        const user = await User.findById(req.user);
        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'User not found',
            });
        }

        if (!user.profileImage) {
            return res.status(400).json({
                success: false,
                message: 'No profile image to delete',
            });
        }

        try {
            const imagePath = path.join(__dirname, '..', user.profileImage);
            console.log('Attempting to delete profile image:', imagePath);

            if (fs.existsSync(imagePath)) {
                fs.unlinkSync(imagePath);
                console.log('Profile image deleted successfully from server.');
            } else {
                console.warn('Profile image file does not exist on server:', imagePath);
            }

            user.profileImage = null;
            await user.save();

            return res.status(200).json({
                success: true,
                message: 'Profile image deleted successfully',
            });
        } catch (fileError) {
            console.error('Error deleting file:', fileError);
            
            user.profileImage = null;
            await user.save();
            
            return res.status(200).json({
                success: true,
                message: 'Profile image reference removed, but file deletion may have failed',
                warning: fileError.message
            });
        }
    } catch (error) {
        console.error('Error in delete profile image route:', error);
        return res.status(500).json({
            success: false,
            message: 'Error deleting profile image',
            error: error.message,
        });
    }
});


module.exports = authRouter;
