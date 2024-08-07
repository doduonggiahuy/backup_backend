class ApiPath {
  static String endpoint = 'http://127.0.0.1:5000';
  static String baseUrl = 'http://127.0.0.1:5000';
  static String users = '/users/';
  static String uploadAvatar = '/users/upload-avatar/';
  static String login = '/users/login';
  static String loginByGG = '/users/gg-login';
  static String loginByFB = '/users/fb-login';
  static String signup = '/sign-up';
  static String changePassword = '/users/change-password/';
  static String forgotPassword = '/users/getcode/';
  static String checkCode = '/users/checkcode/';
  static String resetPassword = '/users/resetpassword/';
  static String questions = '/questions/';
  static String addQuestion = '/questions/create/';
  static String voteQuestion = '/votes/voting/';
  static String posts = '/posts/';
  static String favoritePosts = '/favoriteposts/';
  static String comments = '/comments/';
  static String conversations = '/conversations/';
  static String conversationsByUser = '/conversations/user';
  static String conversationsWithDoctor = '/conversations/doctor';
  static String messages = '/messages/';
  static String messagesByConversation = '/messages/conversation/';
  static String messagesWithAttchment = '/messages/attchment/';
  static String attachments = '/attachments/';
  static String notifications = '/notifications/';
  static String notificationByUserId = '/notifications/user/';
  static String status = '/statuses/';
  static String statusAccept = '/statuses/accept/';
  static String favoritesStatus = '/favoritestatus/';
  static String favoritesStatusById = '/favoritestatus/status/';
  static String address = '/addresses/';
  static String events = '/events/';
}
