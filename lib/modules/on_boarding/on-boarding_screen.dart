import 'package:flutter/material.dart';
import 'package:shoping/modules/login/login_screen.dart';
import 'package:shoping/shared/component/components.dart';
import 'package:shoping/shared/network/local/cach_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../shared/styles/colors.dart';

class BoardingModel{
  final String image;
  final String title;
  final String body;
  BoardingModel({required this.title, required this.image, required this.body});
}

class OnBoardingScreen extends StatefulWidget {

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardControler=PageController();
  bool isLast=false;

  List<BoardingModel>  boardingModel=[
    BoardingModel(
      image: 'assets/images/I3.jpg',
      title: 'Title 1',
      body: 'Body of the First screen',
    ),
    BoardingModel(
      image: 'assets/images/Happy father with children buying products in supermarket.jpg',
      title: 'Title 2',
      body: 'Body of the Second screen',
    ),
    BoardingModel(
      image: 'assets/images/5245.jpg',
      title: 'Title 3',
      body: 'Body of the Third screen',
    ),
  ];

  void done(){
    CashHelper.putData(key: 'onBoarding', value: true).
    then((value){
      if(value){
        navigateAndDelete(context, LoginScreen());
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          deafultTextButtom(
              function:() {
                done();
              },
              text: 'SKIP'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardControler,
                  itemBuilder: (context,index)=>buildOnBoardingItem(boardingModel[index]),
                itemCount: boardingModel.length,
                onPageChanged: (int index){
                  if(index == boardingModel.length-1 ){
                    setState((){
                      isLast=true;
                    });
                  }
                  else{
                    isLast=false;
                  }
                },
                physics: BouncingScrollPhysics(),
              ),
            ),
            SizedBox(height: 40.0,),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: boardControler,
                    count: boardingModel.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    dotWidth: 10,
                    expansionFactor: 4.0, // spaces between dots
                    activeDotColor: defaultColor,
                  ),
                ),
                Spacer(),//بياخد كل المسافه الباقية فى السطر و تنفع لل column
                FloatingActionButton(
                    onPressed: (){
                      if(isLast){
                        done();
                      }
                      else {
                      boardControler.nextPage(
                          duration: Duration(milliseconds: 850),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios_outlined),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //هحطوا هنا علشان ملوش استخدام غير هنا
  Widget buildOnBoardingItem(BoardingModel item)=>Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: Image(image: AssetImage('${item.image}'))),
      const SizedBox(height: 15.0,),
      Text(
        '${item.title}',
        style: TextStyle(fontSize: 30.0,fontWeight:FontWeight.bold ),
      ),
      const SizedBox(height: 15.0,),
      Text(
        '${item.body}',
        style:  TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 15.0,),
    ],
  );
}
