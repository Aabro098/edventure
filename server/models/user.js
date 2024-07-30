const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
    name : {
        type : String,
        required : true,
        trim : true,
    },
    email : {
        required : true,
        type : String,
        trim : true,
        validate : {
            validator : (value)=>{
                const re = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            message : 'Enter a valid email address',
        }
    },
    password : {
        type : String,
        requried : true,
        validate : {
            validator : (value)=>{
                return value.length > 6 ;
            },
            message : 'Password cannot be less than 8 characters',
        }
    },
    profileImage : {
        required : false,
        type : String
    },
    coverImage : {
        required : false,
        type : String
    },
    address : {
        type : String,
        default : ''
    },
    bio : {
        type : String,
        default : ''
    },
    rating : {
        type : Number ,
        default : 0.0
    },
    education : {
        type : String,
        default : ''
    },
    status : {
        type : String,
        default : ''
    },
    type : {
        type : String,
        default : "user",
    }
});

const User = mongoose.model('User',userSchema);
module.exports = User;