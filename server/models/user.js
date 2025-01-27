const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    email: {
        required: true,
        type: String,
        trim: true,
        validate: {
            validator: (value) => {
                const re = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            message: 'Enter a valid email address',
        }
    },
    password: {
        type: String,
        trim : true,
        requried: true,
        validate: {
            validator: (value) => {
                return value.length > 6;
            },
            message: 'Password cannot be less than 8 characters',
        }
    },
    phone: {
        type: String,
        validate: {
            validator: (value) => {
                const phonePattern = /^9\d{9}$/;
                return phonePattern.test(value);
            },
            message: 'Enter a valid phone number starting with 9 and having 10 digits',
        }
    },
    profileImage: {
        required: false,
        type: String
    },
    address: {
        type: String,
        default: ''
    },
    bio: {
        type: String,
        default: ''
    },
    about : {
        type: String,
        default: ''
    },
    rating: {
        type: Number,
        default: 0
    },
    numberRating: {
        type: Number,
        default: 0
    },
    education: {
        type: String,
        default: ''
    },
    type: {
        type: String,
        default: "user",
    },
    username: {
        type: String,
        unique: true,
        required: true,
        trim: true,
        default: function () {
            return this.name ? this.name.toLowerCase().replace(/[^a-z0-9]/g, '') : '';
        }
    },
    isVerified : {
        type : Boolean,
        default : false
    },
    review: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Review'
    }],

    socketId: {
        type: String,
        required: false, 
    },
    teachingAddress: {
        type: [String],
        default: []
    },
    skills: {
        type: [String],
        validate: {
        validator: function (arr) {
            return arr.every((str) => str.length <= 20); 
        },
        message: 'Must be 20 characters or less.',
        },
    },
    contacts: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        default:[]
    }],
    gender: {
        type: String,
        enum: ['Male', 'Female', 'Others', 'Not to Say','None'],
        default:'None'
    },
});

userSchema.pre('save', async function (next) {
    if (this.isModified('name') || this.isNew) {
        let baseUsername = this.name.toLowerCase().replace(/[^a-z0-9]/g, '_');
        let newUsername = baseUsername;
        let usernameExists = await mongoose.models.User.exists({ username: newUsername });
        while (usernameExists) {
            const randomSuffix = Math.floor(1000 + Math.random() * 9000);
            newUsername = `${baseUsername}_${randomSuffix}`;
            usernameExists = await mongoose.models.User.exists({ username: newUsername });
        }
        this.username = newUsername;
    }
    next();
});

const User = mongoose.model('User', userSchema);
module.exports = User;
