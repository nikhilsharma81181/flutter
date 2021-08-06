class User {
  final String username;
  final String profileImageUrl;
  final String subscribers;

  const User({
    required this.username,
    required this.profileImageUrl,
    required this.subscribers,
  });
}

const User currentUser = User(
  username: "_username",
  profileImageUrl: '_profile image url',
  subscribers: '_100k',
);

class Video {
  final String id;
  final User author;
  final String title;
  final String thumbnailUrl;
  final String duration;
  final DateTime timestamp;
  final String viewCount;
  final String likes;
  final String dislikes;

  const Video({
    required this.id,
    required this.author,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.timestamp,
    required this.viewCount,
    required this.likes,
    required this.dislikes,
  });
}

final List<Video> videos = [
  Video(
    id: '1',
    author: currentUser,
    title: 'title one will be wiritten here',
    thumbnailUrl: 'kdfkdfjm',
    duration: '2:20',
    timestamp: DateTime(2020, 7, 12),
    viewCount: '10k',
    likes: '789',
    dislikes: '1',
  ),
  Video(
    id: '2',
    author: currentUser,
    title: 'title one will be wiritten here',
    thumbnailUrl: 'kdfkdfjm',
    duration: '5:20',
    timestamp: DateTime(2020, 7, 12),
    viewCount: '10k',
    likes: '789',
    dislikes: '1',
  ),
  Video(
    id: '3',
    author: currentUser,
    title: 'title one will be wiritten here',
    thumbnailUrl: 'kdfkdfjm',
    duration: '12:00',
    timestamp: DateTime(2020, 7, 12),
    viewCount: '10k',
    likes: '789',
    dislikes: '1',
  ),
  Video(
    id: '4',
    author: currentUser,
    title: 'title one will be wiritten here',
    thumbnailUrl: 'kdfkdfjm',
    duration: '9:08',
    timestamp: DateTime(2020, 7, 12),
    viewCount: '10k',
    likes: '789',
    dislikes: '1',
  ),
];

final List<Video> suggestedVideos = [
  Video(
    id: '1',
    author: currentUser,
    title: 'title one will be wiritten here',
    thumbnailUrl: 'kdfkdfjm',
    duration: '2:20',
    timestamp: DateTime(2020, 7, 12),
    viewCount: '10k',
    likes: '789',
    dislikes: '1',
  ),
  Video(
    id: '2',
    author: currentUser,
    title: 'title one will be wiritten here',
    thumbnailUrl: 'kdfkdfjm',
    duration: '5:20',
    timestamp: DateTime(2020, 7, 12),
    viewCount: '10k',
    likes: '789',
    dislikes: '1',
  ),
  Video(
    id: '3',
    author: currentUser,
    title: 'title one will be wiritten here',
    thumbnailUrl: 'kdfkdfjm',
    duration: '12:00',
    timestamp: DateTime(2020, 7, 12),
    viewCount: '10k',
    likes: '789',
    dislikes: '1',
  ),
  Video(
    id: '4',
    author: currentUser,
    title: 'title one will be wiritten here',
    thumbnailUrl: 'kdfkdfjm',
    duration: '9:08',
    timestamp: DateTime(2020, 7, 12),
    viewCount: '10k',
    likes: '789',
    dislikes: '1',
  ),
];