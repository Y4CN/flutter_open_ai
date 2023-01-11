import 'dart:convert';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_ai/Api/imageApi.dart';
import 'package:flutter_open_ai/Api/textApi.dart';
import 'package:flutter_open_ai/models/chatModel.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<String> sizes = ['Small', 'Medium', 'Large'];
List<String> valueSizes = ['256x256', "512x512", "1024x1024"];
String? dropValue;
bool? isLoadingImage;
TextEditingController _textEditingController = TextEditingController();
String image = '';

List<ChatModel> chatModellst = [];
bool isLoadingChat = false;

ScrollController _scrollController = ScrollController();
late Size fullSize;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fullSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'OpenAI',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                indicator: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                splashBorderRadius: BorderRadius.circular(20),
                tabs: [
                  _myTabs('Chat'),
                  _myTabs('Image'),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    chatWidget(context),
                    Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: fullSize.width * .65,
                                    height: 50,
                                    child: TextField(
                                      controller: _textEditingController,
                                      decoration: InputDecoration(
                                        hintText: 'example : \' a flower \' ',
                                        fillColor: Colors.grey.shade300,
                                        contentPadding: const EdgeInsets.all(8),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: fullSize.width * .3,
                                    height: 50,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey.shade300,
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          hint: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Select Items',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          icon: const Icon(
                                            CupertinoIcons.chevron_down,
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                          value: dropValue,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          items: List.generate(
                                            sizes.length,
                                            (index) => DropdownMenuItem(
                                              value: valueSizes[index],
                                              child: Text(
                                                sizes[index],
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              dropValue = value.toString();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(300, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.grey.shade300,
                                    elevation: 8),
                                onPressed: () async {
                                  if (dropValue != null) {
                                    if (dropValue!.isEmpty &&
                                        _textEditingController.text.trim() ==
                                            '') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Plz Enter The subject and Size'),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        isLoadingImage = true;
                                      });
                                      image = await ImageApi.generateImage(
                                        _textEditingController.text.trim(),
                                        dropValue!,
                                      );
                                      setState(() {
                                        isLoadingImage = false;
                                      });
                                      print(image);
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Plz Enter The Size'),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Generate',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: isLoadingImage != null
                              ? isLoadingImage!
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.grey.shade300,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(image),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    )
                              : const Center(child: Text('Enter Subject')),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _myTabs(String txt) {
    return Tab(
      child: Text(
        txt,
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }

  Widget chatWidget(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                // reverse: true,
                itemCount: chatModellst.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: BubbleSpecialThree(
                      text: chatModellst[index].txt,
                      color: chatModellst[index].chatEnum == ChatEnum.user
                          ? const Color(0xff1C97F3)
                          : Colors.grey.shade300,
                      isSender: chatModellst[index].chatEnum == ChatEnum.user
                          ? true
                          : false,
                      textStyle: chatModellst[index].chatEnum == ChatEnum.user
                          ? const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            )
                          : const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                    ),
                  );
                },
              ),
            ),
            MessageBar(
              onSend: (p0) async {
                //user add
                chatModellst.add(
                  ChatModel(
                    txt: p0,
                    chatEnum: ChatEnum.user,
                  ),
                );
                var input = p0;
                setState(() {
                  isLoadingChat = true;
                });
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeIn,
                );
                String botChat = await generateResponse(input);
                chatModellst.add(
                  ChatModel(txt: botChat, chatEnum: ChatEnum.bot),
                );
                setState(() {
                  isLoadingChat = false;
                });
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeIn,
                );
              },
            )
          ],
        ),
        Visibility(
          visible: isLoadingChat,
          child: Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height / 10,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ),
          ),
        )
      ],
    );
  }
}
