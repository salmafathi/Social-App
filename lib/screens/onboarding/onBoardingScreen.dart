import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_app/screens/LoginScreen/LoginScreen.dart';
import 'package:social_app/shared/Network/local/cache_helper.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> titles = ['CONNECT', 'CHAT'];
    List<AssetImage> onBoardingImages = [
      AssetImage('assets/images/onBoardSocial1.png'),
      AssetImage('assets/images/onBoardSocial3.png'),
    ];

    var boardPageController = PageController();
    bool isLastPage = false ;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          TextButton(onPressed: onSubmitSkipOnBoard,
              child: Text('SKIP',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: PageView.builder(
                itemBuilder: (context, index) => onBoardpageViewItem(titles[index], onBoardingImages[index]),
                itemCount: titles.length,
                controller: boardPageController,
                physics: BouncingScrollPhysics(),
                onPageChanged: (index){
                  if(index == titles.length-1)
                    {

                        isLastPage = true ;
                        print('Screen index : $index  - isLastPage : $isLastPage');
                    }
                  else{
                    setState(() {
                      isLastPage = false ;
                    });
                      print('Screen index : $index  - isLastPage : $isLastPage');
                  }
                },
              ),
            ),

            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    defaultButton(
                      buttonFunction: () {
                        if(isLastPage)
                        {
                          onSubmitSkipOnBoard();
                        }

                        else
                        {
                          boardPageController.nextPage(duration: Duration(milliseconds: 150), curve: Curves.fastLinearToSlowEaseIn,);
                          print('on pressed isLastPage : $isLastPage');
                        }
                      },
                      buttonText: 'NEXT',
                    ),
                    Spacer(),
                    SmoothPageIndicator(
                      controller: boardPageController,
                      count: titles.length,
                      effect: ExpandingDotsEffect(
                          dotColor: Colors.black26.withOpacity(0.15),
                          activeDotColor: secondaryColor,
                          dotHeight: 15.0,
                          dotWidth: 15.0,
                          expansionFactor: 1.01,
                          spacing: 5.0),


                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget onBoardpageViewItem(String title, AssetImage image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Container(
                decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(95.0)),
            child: CircleAvatar(
              radius: 100.0,
              backgroundImage: AssetImage(image.assetName),),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headline6!.copyWith(color: primaryColor),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing',
              maxLines: 4,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );
  }

  void onSubmitSkipOnBoard(){
    // save in the shared prefs that on boarding finished.
    CachHelper.putDataInSharedPreference(value: true, key: 'onboard')
    .then((value) {
      if(value)
        navigateAndFinish(context ,LoginScreen());
    });

  }
}
