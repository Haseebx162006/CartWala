const cloudinary = require('cloudinary').v2;
const streamifier = require('streamifier');

// Cloudinary configuration is read from env in config/firebase or here
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

exports.uploadImage = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'No image file uploaded' });
    }

    const buffer = req.file.buffer;

    const uploadStream = cloudinary.uploader.upload_stream(
      { folder: 'cartwala' },
      (error, result) => {
        if (error) {
          console.error('Cloudinary upload error:', error);
          return res.status(500).json({ message: 'Upload failed', error });
        }

        return res.status(200).json({ url: result.secure_url, public_id: result.public_id });
      }
    );

    streamifier.createReadStream(buffer).pipe(uploadStream);
  } catch (error) {
    console.error('uploadImage error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};
