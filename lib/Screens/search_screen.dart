

import 'package:artist_arena_app/Utils/appThemeStyle.dart';
import 'package:artist_arena_app/Widgets/profile_container_widget.dart';
import 'package:artist_arena_app/Widgets/textField_widget.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:artist_arena_app/Controllers/search_controller.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {


  List<Map<String,String>> searchItem=[
    {
      'image':"assets/images/searchimg1.webp",
      'type':"Singer & band"

    },
    {
      'image':"assets/images/searchimg2.webp",
      'type':"Anchor & Emcee"
    },
    {
      'image':"assets/images/searchimg3.png",
      'type':"CHOREOGRAPHER"
    },
    {
      'image':"assets/images/searchimg4.png",
      'type':"COMEDIAN"
    },{
      'image':"assets/images/searchimg5.webp",
      'type':"DANCE TROUPE"
    },{
      'image':"assets/images/search6.png",
      'type':"MEHANDI"
    },{
      'image':"assets/images/searchimg7.webp",
      'type':"MUSICIAN"
    },{
      'image':"assets/images/searchimg8.webp",
      'type':"POETS"
    },{
      'image':"assets/images/searchimg9.webp",
      'type':"BAR TENDER"
    },{
      'image':"assets/images/searchimg10.webp",
      'type':"LEAD PREFORMER"
    },{
      'image':"assets/images/searchimg11.webp",
      'type':"PHOTOGRAPHER"
    },{
      'image':"assets/images/searchimg12.webp",
      'type':"DHOL TROUPE"
    },{
      'image':"assets/images/searchimg13.webp",
      'type':"MAGICIAN"
    },{
      'image':"assets/images/searchimg14.webp",
      'type':"WADDING PLANER"
    },{
      'image':"assets/images/searchimg15.webp",
      'type':"RUSSIAN ARTIST"
    },{
      'image':"assets/images/searchimg16.webp",
      'type':"ACTORS & ACTRESSES"
    },{
      'image':"assets/images/searchimg17.webp",
      'type':"BOUTIQUE DESIGNER"
    },{
      'image':"assets/images/searchimg18.webp",
      'type':"GRAPHIC DESIGNER"
    },{
      'image':"assets/images/searchimg19.webp",
      'type':"2D & 3D DESIGNER"
    },{
      'image':"assets/images/searchimg20.webp",
      'type':"RANGOLI ARTIST"
    },{
      'image':"assets/images/searchimg21.webp",
      'type':"SKETCH ARTIST"
    },{
      'image':"assets/images/searchimg22.webp",
      'type':"TATTOO ARTIST"
    },{
      'image':"assets/images/searchimg23.webp",
      'type':"PAINTING ARTIST"
    },{
      'image':"assets/images/searchimg24.webp",
      'type':"THERMOCOL ARTIST"
    },{
      'image':"assets/images/searchimg25.webp",
      'type':"BALLOON ARTIST"
    },{
      'image':"assets/images/searchimg26.webp",
      'type':"JUNIOR DUPLICATE ARTIST"
    },{
      'image':"assets/images/searchimg27.webp",
      'type':"MAKEUP ARTIST"
    },{
      'image':"assets/images/searchimg28.webp",
      'type':"SAFA WALA"
    },{
      'image':"assets/images/searchimg29.webp",
      'type':"SET DESIGNER"
    },{
      'image':"assets/images/searchimg30.webp",
      'type':"D3 UDS"
    },{
      'image':"assets/images/searchimg31.webp",
      'type':"PUPPET SHOW"
    },{
      'image':"assets/images/searchimg32.webp",
      'type':"SCULPTURE"
    },{
      'image':"assets/images/searchimg33.webp",
      'type':"MOTIVATIONAL SPEAKERS"
    },{
      'image':"assets/images/searchimg34.webp",
      'type':"FASHION BLOGS"
    },{
      'image':"assets/images/searchimg35.webp",
      'type':"MODELS MALE FEMALE"
    },{
      'image':"assets/images/searchimg36.webp",
      'type':"BENGALI ARTIST"
    },
  ];



  final List<Map<String ,String>> searchTapItem=[
    {
      "SearchTap":'assets/images/searchtapimg.webp'
    },
    {
      "SearchTap":'assets/images/searchtapimg1.webp'
    },
    {
      "SearchTap":'assets/images/profileimg3.webp'
    },
    {
      "SearchTap":'assets/images/searchtapimg3.webp'
    },
    {
      "SearchTap":'assets/images/searchtapimg1.webp'
    },
    {
      "SearchTap":'assets/images/searchtapimg2.webp'
    },
  ];


  final SearchController searchController=Get.put(SearchController());
  @override
  void dispose() {
    searchController.clearSelection();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    // final size=MediaQuery.of(context).size.width;
    return Scaffold(


      body:  LayoutBuilder(
        builder: (context, constraints) {
          final double width=constraints.maxWidth;
          final double height=constraints.maxHeight;

          bool landescape = width>height&&height<500;
          final double gridAspectRatio = landescape
              ? 1.5
              : width >= 1024
              ? 1.0
              : 1.0;


          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width>=1024?width*0.85:landescape?width*0.85:double.infinity
              ),
              child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: width >= 1024||landescape ? 0.w : 7.w,),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 3.w),

                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(51.sp)
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search,color: Colors.white,),
                        SizedBox(width: width>=800?2.w:5.w,),
                        Expanded(child: TextfieldWidget(hint: 'Search',hintText: TextStyle(color: Colors.white),))
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h,),

                   Expanded(
                     child:  Obx(() {
                  if (searchController.selectedItem.value == null) {
                  // Pehla GridView
                  return GridView.builder( itemCount: searchItem.length,
              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: width >=1024?4:2,
                  crossAxisSpacing: 2.w ,
                  mainAxisSpacing: 2.h,childAspectRatio: gridAspectRatio
              ),
              itemBuilder: (context, index) {
              final item= searchItem[index];
              return GestureDetector(
                onTap: () {
                  searchController.selectItem(item);
                },
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsetsGeometry.only(bottom: 3.h),
                  decoration: BoxDecoration( borderRadius: BorderRadius.circular(15.sp),
                    image: DecorationImage( image: AssetImage(item['image']!), fit: BoxFit.cover,
                    ), ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item['type']!.toUpperCase(),
                      maxLines: 1,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      style: Appthemestyle.searchType,
                    ),
                  ),),
              ); },);
                  }

                  // Container tap hone ke baad second GridView
                  return GridView.builder(
              itemCount: searchTapItem.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width >= 1024 ? 4 : 2,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: gridAspectRatio
                      ),
              itemBuilder: (context, index) {
                final tapItem = searchTapItem[index];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.sp),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileContainerWidget(
                        img: tapItem['SearchTap']!,
                        width: width >= 1024 ? 8.w : 15.w,
                        height: width >= 1024 ? 8.w : 15.w,
                      ),

                      SizedBox(height: 1.h),

                      Text(
                        "Gurashish Singh",
                        style: Appthemestyle.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 14.sp.clamp(7.0, 14.0),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 1.h),

                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Lorem ipsum, or lipsum as it is sometimes known...",
                          style: Appthemestyle.poppins(
                            fontSize: 12.sp.clamp(6.0, 12.0),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21.sp),
                          border: Border.all(
                            color: AppColores.custtombtnColor,
                          ),
                        ),
                        child: Text(
                          "Book Now",
                          style: Appthemestyle.poppins(
                            color: AppColores.custtombtnColor,
                            fontSize: 14.sp.clamp(7.0, 14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
                  );
                      })
                   )
                ],
              ),
              ),
            ),
          );
        }
      ),
    );
  }
}
