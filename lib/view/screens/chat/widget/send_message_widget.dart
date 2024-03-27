import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/body/message_body.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/chat_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';


class SendMessageWidget extends StatefulWidget {
  final int? id;
  const SendMessageWidget({Key? key, this.id}) : super(key: key);

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Card(
        color: Theme.of(context).highlightColor,
        shadowColor: Colors.grey[200],
        elevation: 2,
        margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor,width: 1),
              borderRadius: BorderRadius.circular(50)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: titilliumRegular,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: getTranslated('type_here', context),
                    hintStyle: titilliumRegular.copyWith(color: ColorResources.hintTextColor),
                    border: InputBorder.none,
                  ),
                  onChanged: (String newText) {
                    if(newText.isNotEmpty && !Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                      Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                    }else if(newText.isEmpty && Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                      Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                    }
                  },
                ),
              ),

              InkWell(
                onTap: () {
                  if(Provider.of<ChatProvider>(context, listen: false).isSendButtonActive){
                    MessageBody messageBody = MessageBody(sellerId: widget.id, message: _controller.text.trim());
                    Provider.of<ChatProvider>(context, listen: false).sendMessage(messageBody,  context).then((value){
                      if(value.response!.statusCode ==200){
                        _controller.clear();
                      }
                    });

                  }
                },
                child: SizedBox(width: Dimensions.iconSizeLarge,height: Dimensions.iconSizeLarge,
                  child: Image.asset(
                    Images.send,
                    color: Provider.of<ChatProvider>(context).isSendButtonActive ? Theme.of(context).primaryColor : ColorResources.hintTextColor,

                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
