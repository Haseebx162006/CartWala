const mongoose= require('mongoose')


const db = async () => {
    try {
        await mongoose.connect(process.env.DB_URL)
    } catch (error) {
        console.error('Database connection error:', error)
    }
}

module.exports = db;