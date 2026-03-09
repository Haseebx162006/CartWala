const protect = (req, res, next) => {
    try {
        let token;
        const authHeader= req.headers.authorization 
    if(!authHeader || !authHeader.startsWith('Bearer ')){
        return res.status(401).json({message:"Unauthorized"})
    }

    token= authHeader.split(' ')[1]
    } catch (error) {
        return res.status(500).json({message:"Server error"})
    }
}