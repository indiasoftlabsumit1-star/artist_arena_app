




import 'package:artist_arena_app/Models/commentModel.dart';
import 'package:artist_arena_app/Models/likeModel,dart.dart';
import 'package:artist_arena_app/Service/apiService.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/feedModel.dart';

class FeedController extends GetxController{


  final Apiservice apiservice = Apiservice();

  final RxList<FeedItem> feedList = <FeedItem>[].obs;

  final RxList<CommentItem> commentList=<CommentItem>[].obs;
final RxList<LikeItem>  likeItem=<LikeItem>[].obs;
  final RxBool loading= false.obs;

  Future<void>  getFeed()async{

    try{
      final pref=await SharedPreferences.getInstance();
      final token=pref.getString('token');

      if(token==null||token.isEmpty){
        print("token not found ");
        return;
      }
      final response=await apiservice.getFeed(token: token);
feedList.value=response.data.items;
print("response fedd apiu  :$response");
    }
    catch(e){
      print(e);
    }

  }


  Future<void> getComment(int postId)async{


    try{
     loading.value=true;
      final pref=await SharedPreferences.getInstance();
      final token=pref.getString('token');

      if(token==null||token.isEmpty){
        print("token not found");
        return ;
      }

      final response=await apiservice.getComment(token: token, postId: postId);
      commentList.value=response.data.items;
      print(" response comment :  $response");
    }catch(e){
      print("comment api error : $e");
    }
    finally{
      loading.value=false;
    }
  }


  Future<void> getLikes(int postId)async{


    try{
      loading.value=true;

      final pref=await SharedPreferences.getInstance();
      final token=pref.getString('token');

      if(token==null||token.isEmpty){
        print("token not found");
        return;
      }

      final response=await apiservice.getLikes(token: token, postId: postId);
      likeItem.value=response.data.items;
      print('likes api response : $response');
    }catch(e){
      print(" likes api error : $e");
    }finally{
      loading.value=false;
    }
  }

}