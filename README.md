# Runners Social - A Social Running Platform

A real-time social platform for runners to connect, share runs, and track progress together.

## Features

- **User Authentication**
  - JWT-based authentication
  - Secure password hashing
  - Profile management
  - Email verification
  - Password reset

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

### Frontend
- Flutter 3.24.5
- Dart 3.5.4
- BLoC State Management
- Clean Architecture
- Auto Route Navigation
- Material Design 3

## Getting Started

### Prerequisites
- Node.js (v14 or higher)
- MongoDB (v4.4 or higher)
- npm or yarn
- Flutter SDK (3.24.5 or higher)
- Dart SDK (3.5.4 or higher)

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

3. Set up backend environment variables
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Start the backend development server
```bash
npm run dev
```

5. Install frontend dependencies
```bash
cd ../frontend
flutter pub get
```

6. Run the frontend application
```bash
flutter run -d chrome  # For web
# or
flutter run  # For mobile devices
```

### Environment Variables

Backend `.env`:
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
- `POST /api/auth/reset-password` - Request password reset
- `POST /api/auth/verify-email` - Verify email address

### Friends
- `POST /api/friends/request` - Send friend request
- `POST /api/friends/handle-request` - Accept/decline request
- `GET /api/friends/list` - Get friends list
- `GET /api/friends/stats/:friendId` - Get shared statistics
- `GET /api/friends/runs/:friendId` - Get shared run history

### Run Sessions
- `POST /api/sessions` - Create run session
- `GET /api/sessions/:id` - Get session details
- `PUT /api/sessions/:id/location` - Update run location
- `POST /api/sessions/:id/join` - Join a run session
- `POST /api/sessions/:id/leave` - Leave a run session

## Project Structure

### Frontend
```
frontend/
├── lib/
│   ├── core/           # Core functionality (theme, utils, etc.)
│   ├── features/       # Feature modules
│   │   ├── auth/       # Authentication feature
│   │   ├── feed/       # Social feed feature
│   │   ├── run/        # Run tracking feature
│   │   └── profile/    # User profile feature
│   ├── routes/         # App routing
│   └── main.dart       # App entry point
```

### Backend
```
backend/
├── src/
│   ├── config/         # Configuration files
│   ├── controllers/    # Route controllers
│   ├── middleware/     # Express middleware
│   ├── models/         # Database models
│   ├── routes/         # API routes
│   ├── socket/         # Socket.IO handlers
│   └── index.js        # Server entry point
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
