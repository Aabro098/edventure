const express = require("express");
const User = require("../models/user");
const bcryptjs = require('bcryptjs');
const jwt = require("jsonwebtoken");
const multer = require('multer');
const path = require('path');
const cors = require('cors');

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


authRouter.put('/api/updateProfile', auth , upload.single('profileImage'), async (req, res) => {
    try {      
        if (!req.user) {
            return res.status(401).json({
                success: false,
                message: 'No user ID found in request'
            });
        }

        const user = await User.findById(req.user); 
        console.log('Found user:', user);
        

        if (req.file && user.profileImage) {
            try {
                fs.unlinkSync(user.profileImage); 
            } catch (error) {
                console.log('Error deleting old profile image:', error.message);
            }
        }

        if (req.file) {
            user.profileImage = req.file.path.replace(/\\/g, '/'); 
        }

        await user.save();

        res.status(200).json({
            success: true,
            message: 'Profile image updated successfully',
            profileImageUrl: `${req.protocol}://${req.get('host')}/${user.profileImage}`
        });
    } catch (error) {
        console.error('Error updating profile image:', error.message);
        if (req.file) {
            try {
                fs.unlinkSync(req.file.path);
            } catch (unlinkError) {
                console.error('Error cleaning up file:', unlinkError);
            }
        }
        res.status(500).json({ success: false, message: 'Error updating profile image', error: error.message });
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

        if (user.profileImage) {
            const imagePath = user.profileImage;
            console.log('Attempting to delete profile image:', imagePath);

            if (fs.existsSync(imagePath)) {
                try {
                    fs.unlinkSync(imagePath); 
                    console.log('Profile image deleted successfully from server.');
                } catch (error) {
                    console.error('Error deleting profile image from server:', error.message);
                    return res.status(500).json({
                        success: false,
                        message: 'Error deleting profile image from server',
                    });
                }
            } else {
                console.warn('Profile image file does not exist on server:', imagePath);
            }

            user.profileImage = undefined; 
            await user.save();

            return res.status(200).json({
                success: true,
                message: 'Profile image deleted successfully',
            });
        } else {
            return res.status(400).json({
                success: false,
                message: 'No profile image to delete',
            });
        }
    } catch (error) {
        console.error('Error deleting profile image:', error.message);
        res.status(500).json({
            success: false,
            message: 'Error deleting profile image',
            error: error.message,
        });
    }
});


module.exports = authRouter;
