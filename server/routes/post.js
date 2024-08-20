const express = require("express");
const Post = require("../models/post");
const auth = require("../middleware/auth");

const postRouter = express.Router();


postRouter.post('/api/posts', auth, async (req, res) => {
    try {
        const { description, image } = req.body;
        const user = req.user;

        const post = new Post({
            user,
            description,
            image,
        });

        const savedPost = await post.save();
        res.status(201).json(savedPost);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


postRouter.get('/api/posts', auth, async (req, res) => {
    try {
        const posts = await Post.find().populate('user').populate('shares').populate('reports.user');
        res.status(200).json(posts);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


postRouter.get('/api/posts/:id', auth, async (req, res) => {
    try {
        const post = await Post.findById(req.params.id).populate('user').populate('shares').populate('reports.user');
        if (!post) {
            return res.status(404).json({ msg: 'Post not found' });
        }
        res.status(200).json(post);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


postRouter.put('/api/posts/:id', auth, async (req, res) => {
    try {
        const { description, image } = req.body;
        const post = await Post.findById(req.params.id);

        if (!post) {
            return res.status(404).json({ msg: 'Post not found' });
        }

        if (post.user.toString() !== req.user) {
            return res.status(403).json({ msg: 'User not authorized to update this post' });
        }

        if (description) post.description = description;
        if (image) post.image = image;

        const updatedPost = await post.save();
        res.status(200).json(updatedPost);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


postRouter.delete('/api/posts/:id', auth, async (req, res) => {
    try {
        const post = await Post.findById(req.params.id);

        if (!post) {
            return res.status(404).json({ msg: 'Post not found' });
        }

        if (post.user.toString() !== req.user) {
            return res.status(403).json({ msg: 'User not authorized to delete this post' });
        }

        await post.remove();
        res.status(200).json({ msg: 'Post deleted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = postRouter;
