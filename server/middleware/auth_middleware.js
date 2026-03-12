const jwt = require('jsonwebtoken');

const protect = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Unauthorized: no token provided' });
  }

  try {
    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, process.env.SECRET_KEY);
    req.user = decoded;   // { id, iat, exp }
    next();
  } catch (error) {
    return res.status(401).json({ message: 'Unauthorized: invalid token' });
  }
};

module.exports = protect;
