



class Apiurl {

   static const baseUrl="https://indiasoftlabs.com/artist/public/api/";

   static const signUp="${baseUrl}auth/register";
   static const signupOTP="${baseUrl}auth/verify-otp";
   static const sendOtp="${baseUrl}auth/send-otp";
   static const logOut="${baseUrl}auth/logout";
   static const profile="${baseUrl}profile";

static const upload="${baseUrl}upload";
   static const update="${baseUrl}profile/update";
   static const resendOtp="${baseUrl}auth/resend-otp";
   static const  feed = "${baseUrl}posts/feed";

   static String comment(int postId){
      return   '${baseUrl}posts/$postId/comments';
   }
   static String likes(int postId){
      return   '${baseUrl}posts/$postId/likes';
   }

   static String like(int postId){
      return   '${baseUrl}posts/$postId/like';
   }
   static String unLike(int postId){
      return   '${baseUrl}posts/$postId/unlike';
   }
   static String addComment(int postId){
      return   '${baseUrl}posts/$postId/comments';
   }
   static const  post = "${baseUrl}posts/create";
   static const  createStory = "${baseUrl}stories/create";
   static const stories="${baseUrl}stories";








}