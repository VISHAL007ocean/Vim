import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vim_mobile/common/custom_widgets/title_icon.dart';
import 'package:vim_mobile/ui/components/pageComponents/CardSettingsGenericWidget.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';

class ContactPageWidget extends StatefulWidget {
  ContactPageWidget({
    Key key,
  }) : super(key: key);

  @override
  _ContactPageWidgetState createState() => _ContactPageWidgetState();
}

class _ContactPageWidgetState extends State<ContactPageWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();

  final telephone = "tel:08455443035";
  final email = "";

  _emailPopup() async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CardSettings(children: <CardSettingsSection>[
                CardSettingsSection(children: <CardSettingsWidget>[
                  CardSettingsHeader(
                    showMaterialonIOS: true,
                    label: 'Send Email',
                    color: vimPrimary,
                  ),
                  CardSettingsInstructions(
                    showMaterialonIOS: true,
                    text:
                        'We aim to reply to our customers as soon as possible...',
                  ),
                  CardSettingsText(
                    showMaterialonIOS: true,
                    label: 'Subject:',
                    controller: subjectController,
                    hintText: "Text",
                  ),
                  CardSettingsParagraph(
                      showMaterialonIOS: true,
                      label: 'Body:',
                      controller: emailController,
                      hintText: "Text"),
                  CardSettingsButton(
                    backgroundColor: vimPrimary,
                    showMaterialonIOS: true,
                    label: 'Send',
                    textColor: Colors.white,
                    onPressed: () async {
                      try {
                        // TODO: Send API call to backend to send email using Sendgrid.
                        // final Email email = Email(
                        //     body: emailController.text,
                        //     subject: subjectController.text,
                        //     recipients: ['general@vim-ltd.com']);
                        // await FlutterEmailSender.send(email);
                      } catch (e) {
                        print(e.toString());
                        Alert(
                                title:
                                    "Could not start Email service! Make sure you have set up a default email provider on your device.",
                                context: context)
                            .show();
                      }
                    },
                  ),
                ])
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              }),
          backgroundColor: Colors.white,
          title: titleIcon(),
          centerTitle: true,
        ),
        body: Container(
            child: CardSettings(
          children: <CardSettingsSection>[
            CardSettingsSection(children: <CardSettingsWidget>[
              CardSettingsGenericWidget(
                children: <Widget>[
                  CardSettingsHeader(
                    label: "Contact Vim:",
                    color: vimPrimary,
                  ),
                  GestureDetector(
                      onTap: () {
                        try {
                          launch(telephone);
                        } catch (e) {
                          Alert(
                                  context: context,
                                  title: "Could not load phone!")
                              .show();
                        }
                      },
                      child: CardSettingsText(
                        showMaterialonIOS: true,
                        enabled: false,
                        label: "Telephone",
                        initialValue: "0845 544 3035",
                      )),
                  CardSettingsText(
                    showMaterialonIOS: true,
                    enabled: false,
                    label: "Email",
                    initialValue: "general@vim-ltd.com",
                  )
                ],
              )
            ])
          ],
        )));
  }
}
