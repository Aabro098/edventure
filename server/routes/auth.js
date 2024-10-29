
const express = require("express");
const User = require("../models/user");
const bcryptjs = require('bcryptjs');
const jwt = require("jsonwebtoken");
const multer = require('multer');
const path = require('path');

const authRouter = express.Router();
const uploadsPath = path.join(__dirname, '..', 'uploads');

const app = express();
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

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


const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, 'uploads/'); 
    },
    filename: function (req, file, cb) {
      cb(null, Date.now() + path.extname(file.originalname)); 
    }
});

const upload = multer({ storage: storage });

authRouter.put('/api/update', auth, upload.single('image'), async (req, res) => {
    try {
        const updates = req.body; 
        const user = await User.findById(req.user);

        if (!user) {
        return res.status(404).json({ msg: 'User not found' });
        }

        Object.keys(updates).forEach(key => {
        user[key] = updates[key];
        });

        if (req.file) {
        user.profileImage = req.file.path; 
        }

        await user.save();
        res.json(user);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


authRouter.put('/api/toggle-availability', auth, async (req, res) => {
    try {
        const user = await User.findById(req.user);
        
        if (!user) {
            return res.status(404).json({ msg: 'User not found' });
        }

        user.isAvailable = !user.isAvailable;

        await user.save();

        res.json(user);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = authRouter;
