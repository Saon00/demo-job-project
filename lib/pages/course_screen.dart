import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// import 'package:interndemo/components/course_curriculum.dart';
import 'package:interndemo/components/fixedvalues.dart';
import 'package:interndemo/model/course_details.dart';
import 'package:interndemo/model/network_utils.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../components/overlaycontrol.dart';

CourseDetails courseDetails = CourseDetails();
String videoUrl =
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late VideoPlayerController videoPlayerController;
  late Future<void> future;

  @override
  void initState() {
    super.initState();
    getAll();
    playVideo(videoUrl);
    future = videoPlayerController.initialize();
  }

  void playVideo(String videoUrl) {
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

    // videoPlayerController.play();
    videoPlayerController.addListener(() {
      setState(() {});
    });
  }

  Future<void> getAll() async {
    final response = await NetworkUtils.getMethod(apiUrl);
    setState(() {});
    if (response != null) {
      courseDetails = CourseDetails.fromJson(response);
    } else {
      // SnackBar(context, 'Unable to fetch data', true);
      Get.snackbar("FAILED", "Unable to fetch data",
          backgroundColor: Colors.red);
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purple,
      // appbar
      appBar: AppBar(
        backgroundColor: purple,
        title: const Text(
          "Course Details",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {},
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset(
                'assets/icons/menu_bar.png',
                color: white,
              ),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Image.asset(
                'assets/icons/shopping_cart.png',
                color: white,
              ),
            ),
          )
        ],
      ),

      // body
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Color(0xfff7f8fa)),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),

                // video place
                FutureBuilder(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AspectRatio(
                          aspectRatio: videoPlayerController.value.aspectRatio,
                          //     child: videoPlayerController.value.isInitialized ?
                          //     GestureDetector(
                          //       onTap: (){
                          //         setState(() {
                          //           videoPlayerController.play();
                          //         });
                          //       },
                          //       child: Image.network(
                          //         "https://getlearn-admin.getbuildfirst.com/storage/app/public/course/17114492716602a4b794245.png",
                          //         fit: BoxFit.cover,),
                          //     )
                          // :
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              VideoPlayer(videoPlayerController),
                              ControlsOverlay(
                                  controller: videoPlayerController),
                              VideoProgressIndicator(videoPlayerController,
                                  allowScrubbing: true),
                            ],
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),

                SizedBox(
                  height: 30,
                ),

                // title text
                Text(
                  courseDetails.data?.title.toString() ?? "Title Missing",
                  style: popinsTitle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),

                // subtitle
                Text(
                  courseDetails.data?.subTitle.toString() ?? "Subtitle Missing",
                  style: popinsTitle.copyWith(fontSize: 15, color: Colors.grey),
                ),
                const SizedBox(
                  height: 10,
                ),

                // ratings
                Row(
                  children: [
                    // rating
                    Text(
                      "5.0",
                      style: popinsTitle.copyWith(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 20,
                    ),

                    // stars
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 20),
                        Icon(Icons.star, color: Colors.yellow, size: 20),
                        Icon(Icons.star, color: Colors.yellow, size: 20),
                        Icon(Icons.star, color: Colors.yellow, size: 20),
                        Icon(Icons.star, color: Colors.yellow, size: 20),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),

                    // total ratings
                    Text(
                      "(25,00)",
                      style: popinsTitle.copyWith(
                          fontSize: 15,
                          // fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                // total students
                Text(
                  "9,591 students",
                  style: popinsTitle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),

                const SizedBox(
                  height: 15,
                ),

                // mentor
                Row(
                  children: [
                    Text(
                      "Mentor",
                      style: popinsTitle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    // mentor Name
                    Text(
                      "Ashutosh Pawar",
                      style: popinsTitle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: purple),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                // last update
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Last update ${courseDetails.data?.updatedAt?.substring(0, 10)}",
                      style: popinsTitle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                // language
                Row(
                  children: [
                    Icon(
                      Icons.language_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "English",
                      style: popinsTitle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 15,
                ),

                // total students
                Text(
                  "BDT ${courseDetails.data?.price}",
                  style: popinsTitle.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                const SizedBox(
                  height: 15,
                ),

                // buy now button
                SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                      ),
                      onPressed: () {},
                      child: Text("Buy Now",
                          style: popinsTitle.copyWith(
                              fontSize: 25,
                              color: white,
                              fontWeight: FontWeight.bold)),
                    )),
                const SizedBox(
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 55,
                      child: OutlinedButton(
                          onPressed: () {}, child: Text('Add to cart')),
                    ),
                    SizedBox(
                      height: 55,
                      child: OutlinedButton(
                          onPressed: () {}, child: Text('Add to wishlist')),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),

                // what you will learn
                Text(
                  "What you'll learn",
                  style: popinsTitle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: Colors.purple,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                courseDetails.data?.learningTopic?[index]
                                        .trim() ??
                                    "None",
                                style: popinsTitle.copyWith(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(
                            height: 10,
                          ),
                      itemCount:
                          courseDetails.data?.learningTopic?.length ?? 0),
                ),

                const SizedBox(
                  height: 15,
                ),

                // course curriculum
                Text(
                  "Course Curriculum",
                  style: popinsTitle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),

                Steps(),

                Text(
                  "This course includes",
                  style: popinsTitle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                CourseIncludedWidget(
                  text: 'Support Files',
                  icon: Icons.file_copy_outlined,
                ),
                const SizedBox(
                  height: 5,
                ),
                CourseIncludedWidget(
                  text: '34.5 total hours on- demand vedio',
                  icon: Icons.play_circle_outline_rounded,
                ),
                const SizedBox(
                  height: 5,
                ),
                CourseIncludedWidget(
                  text: '10 Articles',
                  icon: Icons.article_outlined,
                ),
                const SizedBox(
                  height: 5,
                ),
                CourseIncludedWidget(
                  text: 'Full lifetime access',
                  icon: Icons.access_time_filled_outlined,
                ),
                const SizedBox(
                  height: 5,
                ),
                CourseIncludedWidget(
                  text: 'Access on mobile, desktop, and TV',
                  icon: Icons.phone_android_outlined,
                ),
                const SizedBox(
                  height: 5,
                ),
                CourseIncludedWidget(
                  text: 'Certificate of Completion',
                  icon: Icons.newspaper_outlined,
                ),
                const SizedBox(
                  height: 15,
                ),
                // requierments
                Text(
                  "Requirements",
                  style: popinsTitle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.purple,
                      size: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(
                        courseDetails.data?.requirements ?? "None",
                        style: popinsTitle.copyWith(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // descriptions
                Text(
                  "Descriptions",
                  style: popinsTitle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  courseDetails.data?.description.toString() ??
                      "Description Missing",
                  style: popinsTitle.copyWith(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseIncludedWidget extends StatelessWidget {
  final String text;
  final IconData icon;

  const CourseIncludedWidget({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.purple[400],
          size: 20,
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(
            text,
            style: popinsTitle.copyWith(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        )
      ],
    );
  }
}

// class Step {
//   Step(this.title, this.body, [this.isExpanded = false]);
//
//   String title;
//   String body;
//   bool isExpanded;
// }

// List<Step> getSteps() {
//   return [
//     Step(courseDetails.data?.sections?[0].topic.toString() ?? "awd",
//         'Install Flutter development tools according to the official documentation.'),
//     Step('Step 1: Create a project',
//         'Open your terminal, run `flutter create <project_name>` to create a new project.'),
//     // Step('Step 2: Run the app', 'Change your terminal directory to the project directory, enter `flutter run`.'),
//   ];
// }

// ListView? getSteps(){
//    ListView.builder(itemBuilder: (context, index){
//     return Column(
//       children: [],
//     );
//   });
// }

class Steps extends StatefulWidget {
  const Steps({Key? key}) : super(key: key);

  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  // final List<Step> _steps = getSteps();
  // final List<dynamic> _steps = getSteps();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
          itemCount: courseDetails.data?.sections?.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                child: _renderSteps(index),
              ),
            );
          }),
    );
  }

  Widget _renderSteps(int i) {
    return ExpansionPanelList.radio(children: [
      ExpansionPanelRadio(
          value:
              courseDetails.data?.sections![i].description.toString() ?? "Null",
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                  courseDetails.data?.sections![i].topic.toString() ??
                      "Null Title",
                  style: popinsTitle.copyWith(
                      color: purple,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            );
          },
          body: SizedBox(
            height: 200,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: courseDetails.data?.sections?[i].lessons?.length,
                itemBuilder: (contex, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              videoUrl = courseDetails.data?.sections![i]
                                      .lessons![index].videoLinkPath
                                      .toString() ??
                                  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.play_circle_outline,
                                color: Colors.purple[200],
                              ),
                              SizedBox(width: 5),
                              Text(
                                courseDetails.data?.sections![i].lessons?[index]
                                        .lectureTitle
                                        .toString() ??
                                    "Null Title",
                                style: popinsTitle.copyWith(
                                    fontSize: 20, color: Colors.grey),
                              ),
                              // SizedBox(height: 50,),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }),
          )
          // body: ListTile(
          //
          //   title: Text(
          //       courseDetails.data?.sections![i].description.toString() ??
          //           "Null Description"),
          // ),
          )
    ]

        // children: _steps.map<ExpansionPanelRadio>((Step step) {
        //   return ExpansionPanelRadio(
        //       headerBuilder: (BuildContext context, bool isExpanded) {
        //         return ListTile(
        //           title: Text(step.title),
        //         );
        //       },
        //       body: ListTile(
        //         title: Text(step.body),
        //       ),
        //       value: step.title
        //   );
        // }).toList(),
        );
  }
}
