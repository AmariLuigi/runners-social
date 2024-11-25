# Runners Social - A Social Running Platform

A real-time social platform for runners to connect, share runs, and track progress together.

## Features

- **User Authentication**
  - JWT-based authentication
  - Secure password hashing
  - Profile management

- **Friend System**
  - Send/accept friend requests
  - Block/unblock users
  - Track shared running statistics
  - View shared run history

- **Run Sessions**
  - Create individual or group runs
  - Real-time location sharing
  - Track run statistics
  - Support for both planned and impromptu runs

- **Real-time Features**
  - Live location updates
  - Instant notifications
  - Real-time chat during runs

## Tech Stack

### Backend
- Node.js
- Express.js
- MongoDB
- Socket.IO
- JWT Authentication

### Frontend (Coming Soon)
- Flutter
- Provider State Management
- Google Maps Integration
- Socket.IO Client

## Getting Started

### Prerequisites
- Node.js (v14 or higher)
- MongoDB (v4.4 or higher)
- npm or yarn

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/runners-social.git
cd runners-social
```

2. Install backend dependencies
```bash
cd backend
npm install
```

3. Set up environment variables
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Start the development server
```bash
npm run dev
```

### Environment Variables

Create a `.env` file in the backend directory with the following variables:
```env
PORT=3000
MONGODB_URI=mongodb://localhost:27017/runners_social
JWT_SECRET=your_jwt_secret
```

## API Documentation

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/profile` - Get user profile

### Friends
- `POST /api/friends/request` - Send friend request
- `POST /api/friends/handle-request` - Accept/decline request
- `GET /api/friends/list` - Get friends list
- `GET /api/friends/stats/:friendId` - Get shared statistics
- `GET /api/friends/runs/:friendId` - Get shared run history

### Run Sessions
- `POST /api/sessions` - Create run session
- `GET /api/sessions/:id` - Get session details
- `PATCH /api/sessions/:id/status` - Update session status
- `POST /api/sessions/:id/location` - Update location

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
