import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:vim_mobile/models/driver_checks/CreateDriverCheckQuestions.dart';
import 'package:vim_mobile/models/engineer/job_question_answers/job_ans_model.dart';
import 'package:vim_mobile/models/lease_checks/CreateLeaseCheckQuestions.dart';
import 'package:vim_mobile/models/verification_checks/CreateVerificationCheckQuestions.dart';
import 'package:vim_mobile/models/wellbeing_checks/CreateWellbeingCheckQuestions.dart';
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsSwitch.dart';

class CreateWellbeingSwitch extends StatelessWidget
    implements CardSettingsWidget {
  @required
  final CreateWellbeingCheckAnswers controller;
  @required
  final String questionType;
  @required
  final String questionLabel;
  @required
  final String trueLabel;
  @required
  final String falseLabel;
  @required
  final String hintText;
  @required
  final String notesLabel;
  @required
  final int numLines;
  @required
  final Function stateFunction;
  @required
  final bool hideOnFail;

  @override
  final bool visible = true;
  @override
  final bool showMaterialonIOS = true;

  const CreateWellbeingSwitch({
    Key key,
    this.controller, //controller
    this.questionType, //driver, lease, wellbeing or verification.
    this.questionLabel, //label for the question
    this.trueLabel, //label if switch is turned on
    this.falseLabel, //label if switch is turned off
    this.notesLabel, //label for the extra details section
    this.hintText, //label for the extra details hint text
    this.numLines, //number of lines in the extra details field
    this.stateFunction, //state function
    this.hideOnFail, //check if extra details should hide on fail
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hideOnFail == true) {
      return Column(children: <Widget>[
        VimCardSettingsSwitch(
          label: questionLabel,
          trueLabel: trueLabel,
          falseLabel: falseLabel,
          onChanged: (value) => stateFunction(
              () => {controller.answer = value ? trueLabel : falseLabel}),
        ),
        Visibility(
          visible: controller.answer == "Fail",
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
              child: Column(children: [
                CardSettingsParagraph(
                  label: notesLabel,
                  contentOnNewLine: true,
                  hintText: hintText,
                  numberOfLines: numLines,
                  onChanged: (val) => controller.notes = val,
                ),
              ])),
        )
      ]);
    } else if (hideOnFail == false) {
      return Column(children: <Widget>[
        VimCardSettingsSwitch(
          label: questionLabel,
          trueLabel: trueLabel,
          falseLabel: falseLabel,
          onChanged: (value) => stateFunction(
              () => {controller.answer = value ? trueLabel : falseLabel}),
        ),
        Visibility(
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
              child: Column(children: [
                CardSettingsParagraph(
                  label: notesLabel,
                  contentOnNewLine: true,
                  hintText: hintText,
                  numberOfLines: numLines,
                  onChanged: (val) => controller.notes = val,
                ),
              ])),
        )
      ]);
    }
  }
}

class CreateDriverSwitch extends StatelessWidget implements CardSettingsWidget {
  @required
  final CreateDriverCheckAnswers controller;
  @required
  final String questionType;
  @required
  final String questionLabel;
  @required
  final String trueLabel;
  @required
  final String falseLabel;
  @required
  final String hintText;
  @required
  final String notesLabel;
  @required
  final int numLines;
  @required
  final Function stateFunction;
  @required
  final bool hideOnFail;
  final Function imagesFunction;

  @override
  final bool visible = true;
  @override
  final bool showMaterialonIOS = true;

  const CreateDriverSwitch({
    Key key,
    this.controller, //controller
    this.questionType, //driver, lease, wellbeing or verification.
    this.questionLabel, //label for the question
    this.trueLabel, //label if switch is turned on
    this.falseLabel, //label if switch is turned off
    this.notesLabel, //label for the extra details section
    this.hintText, //label for the extra details hint text
    this.numLines, //number of lines in the extra details field
    this.stateFunction, //state function
    this.imagesFunction, //images function
    this.hideOnFail, //check if extra details should hide on fail
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hideOnFail == true) {
      return Column(children: <Widget>[
        VimCardSettingsSwitch(
          label: questionLabel,
          trueLabel: trueLabel,
          falseLabel: falseLabel,
          onChanged: (value) => stateFunction(
              () => {controller.answer = value ? trueLabel : falseLabel}),
        ),
        Visibility(
          visible: controller.answer == "Fail",
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
              child: Column(children: [
                CardSettingsParagraph(
                  label: notesLabel,
                  contentOnNewLine: true,
                  hintText: hintText,
                  numberOfLines: numLines,
                  onChanged: (val) => controller.notes = val,
                ),
                if (imagesFunction != null) ...imagesFunction(controller)
              ])),
        )
      ]);
    } else if (hideOnFail == false) {
      return Column(children: <Widget>[
        VimCardSettingsSwitch(
          label: questionLabel,
          trueLabel: trueLabel,
          falseLabel: falseLabel,
          onChanged: (value) => stateFunction(
              () => {controller.answer = value ? trueLabel : falseLabel}),
        ),
        Visibility(
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
              child: Column(children: [
                CardSettingsParagraph(
                  label: notesLabel,
                  contentOnNewLine: true,
                  hintText: hintText,
                  numberOfLines: numLines,
                  onChanged: (val) => controller.notes = val,
                ),
                if (imagesFunction != null) ...imagesFunction(controller)
              ])),
        )
      ]);
    }
  }
}

class CreateVerificationSwitch extends StatelessWidget
    implements CardSettingsWidget {
  @required
  final CreateVerificationCheckAnswers controller;
  @required
  final String questionType;
  @required
  final String questionLabel;
  @required
  final String trueLabel;
  @required
  final String falseLabel;
  @required
  final String hintText;
  @required
  final String notesLabel;
  @required
  final int numLines;
  @required
  final Function stateFunction;
  @required
  final bool hideOnFail;
  final Function imagesFunction;

  @override
  final bool visible = true;
  @override
  final bool showMaterialonIOS = true;

  const CreateVerificationSwitch({
    Key key,
    this.controller, //controller
    this.questionType, //driver, lease, wellbeing or verification.
    this.questionLabel, //label for the question
    this.trueLabel, //label if switch is turned on
    this.falseLabel, //label if switch is turned off
    this.notesLabel, //label for the extra details section
    this.hintText, //label for the extra details hint text
    this.numLines, //number of lines in the extra details field
    this.stateFunction, //state function
    this.imagesFunction, //images function
    this.hideOnFail, //check if extra details should hide on fail
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hideOnFail == true) {
      return Column(children: <Widget>[
        VimCardSettingsSwitch(
          label: questionLabel,
          trueLabel: trueLabel,
          falseLabel: falseLabel,
          onChanged: (value) => stateFunction(
              () => {controller.answer = value ? trueLabel : falseLabel}),
        ),
        Visibility(
          visible: controller.answer == "Fail",
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
              child: Column(children: [
                CardSettingsParagraph(
                  label: notesLabel,
                  contentOnNewLine: true,
                  hintText: hintText,
                  numberOfLines: numLines,
                  onChanged: (val) => controller.notes = val,
                ),
                ...imagesFunction(controller)
              ])),
        )
      ]);
    } else if (hideOnFail == false) {
      return Column(children: <Widget>[
        VimCardSettingsSwitch(
          label: questionLabel,
          trueLabel: trueLabel,
          falseLabel: falseLabel,
          onChanged: (value) => stateFunction(
              () => {controller.answer = value ? trueLabel : falseLabel}),
        ),
        Visibility(
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
              child: Column(children: [
                CardSettingsParagraph(
                  label: notesLabel,
                  contentOnNewLine: true,
                  hintText: hintText,
                  numberOfLines: numLines,
                  onChanged: (val) => controller.notes = val,
                ),
                if (imagesFunction != null) ...imagesFunction(controller)
              ])),
        )
      ]);
    }
  }
}

class CreateLeaseSwitch extends StatelessWidget implements CardSettingsWidget {
  @required
  final CreateLeaseCheckAnswers controller;
  @required
  final String questionType;
  @required
  final String questionLabel;
  @required
  final String trueLabel;
  @required
  final String falseLabel;
  @required
  final String hintText;
  @required
  final String notesLabel;
  @required
  final int numLines;
  @required
  final Function stateFunction;
  @required
  final bool hideOnFail;
  final Function imagesFunction;

  @override
  final bool visible = true;
  @override
  final bool showMaterialonIOS = true;

  const CreateLeaseSwitch({
    Key key,
    this.controller, //controller
    this.questionType, //driver, lease, wellbeing or verification.
    this.questionLabel, //label for the question
    this.trueLabel, //label if switch is turned on
    this.falseLabel, //label if switch is turned off
    this.notesLabel, //label for the extra details section
    this.hintText, //label for the extra details hint text
    this.numLines, //number of lines in the extra details field
    this.stateFunction, //state function
    this.imagesFunction, //images function
    this.hideOnFail, //check if extra details should hide on fail
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hideOnFail == true) {
      return Column(children: <Widget>[
        VimCardSettingsSwitch(
          label: questionLabel,
          trueLabel: trueLabel,
          falseLabel: falseLabel,
          onChanged: (value) => stateFunction(
              () => {controller.answer = value ? trueLabel : falseLabel}),
        ),
        Visibility(
          visible: controller.answer == "Fail",
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
              child: Column(children: [
                CardSettingsParagraph(
                  label: notesLabel,
                  contentOnNewLine: true,
                  hintText: hintText,
                  numberOfLines: numLines,
                  onChanged: (val) => controller.notes = val,
                ),
                if (imagesFunction != null) ...imagesFunction(controller)
              ])),
        )
      ]);
    } else if (hideOnFail == false) {
      return Column(children: <Widget>[
        VimCardSettingsSwitch(
          label: questionLabel,
          trueLabel: trueLabel,
          falseLabel: falseLabel,
          onChanged: (value) => stateFunction(
              () => {controller.answer = value ? trueLabel : falseLabel}),
        ),
        Visibility(
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
              child: Column(children: [
                CardSettingsParagraph(
                  label: notesLabel,
                  contentOnNewLine: true,
                  hintText: hintText,
                  numberOfLines: numLines,
                  onChanged: (val) => controller.notes = val,
                ),
                if (imagesFunction != null) ...imagesFunction(controller)
              ])),
        )
      ]);
    }
  }
}

class CreateJobSwitch extends StatelessWidget implements CardSettingsWidget {
  @required
  final QuestionAnswer controller;
  @required
  final String questionType;
  @required
  final String questionLabel;
  @required
  final String trueLabel;
  @required
  final String falseLabel;
  @required
  final String hintText;
  @required
  final String notesLabel;
  @required
  final int numLines;
  @required
  final Function stateFunction;
  @required
  final bool hideOnFail;
  final Function imagesFunction;
  // final TextEditingController controllerForText;

  @override
  final bool visible = true;
  @override
  final bool showMaterialonIOS = true;

  CreateJobSwitch({
    Key key,
    this.controller, //controller
    this.questionType, //driver, lease, wellbeing or verification.
    this.questionLabel, //label for the question
    this.trueLabel, //label if switch is turned on
    this.falseLabel, //label if switch is turned off
    this.notesLabel, //label for the extra details section
    this.hintText, //label for the extra details hint text
    this.numLines, //number of lines in the extra details field
    this.stateFunction, //state function
    this.imagesFunction, //images function
    this.hideOnFail, //check if extra details should hide on fail
    // this.controllerForText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hideOnFail == true) {
      return Column(children: <Widget>[
        VimCardSettingsSwitch(
          label: questionLabel,
          trueLabel: trueLabel,
          falseLabel: falseLabel,
          onChanged: (value) => stateFunction(
              () => {controller.answer = value ? trueLabel : falseLabel}),
        ),
        Visibility(
          visible: controller.answer == "Fail",
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
              child: Column(children: [
                CardSettingsParagraph(
                  label: notesLabel,
                  contentOnNewLine: true,
                  hintText: hintText,
                  numberOfLines: numLines,
                  onChanged: (val) => controller.notes = val,
                ),
                if (imagesFunction != null) ...imagesFunction(controller)
              ])),
        )
      ]);
    } else if (hideOnFail == false) {
      return Column(children: <Widget>[
        // GITHUB

        VimCardSettingsSwitch(
          label: questionLabel,
          trueLabel: trueLabel,
          falseLabel: falseLabel,
          onChanged: (value) => stateFunction(
              () => {controller.answer = value ? trueLabel : falseLabel}),
        ),
        Visibility(
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
              child: Column(children: [
                CardSettingsParagraph(
                  // controller: controllerForText,
                  label: notesLabel,
                  contentOnNewLine: true,
                  hintText: hintText,
                  numberOfLines: numLines,
                  keyboardType: notesLabel.contains("Notes")
                      ? TextInputType.text
                      : TextInputType.number,
                  maxLength: notesLabel.contains("Notes") ? 250 : 4,

                  controller: TextEditingController(text: controller.notes),

                  onChanged: (val) => notesLabel.contains("Notes")
                      ? controller.notes = val
                      : controller.qty = stringToDouble(val),
                ),
                if (controller.imgdisable == "0")
                  CardSettingsParagraph(
                    label: "Serial No",
                    contentOnNewLine: true,
                    hintText: "Enter Serial No.",
                    numberOfLines: 1,
                    maxLength: 100,
                    keyboardType: TextInputType.text,
                    // contentPadding: EdgeInsets.all(5.0),
                    controller:
                        TextEditingController(text: controller.serialNumber),
                    onChanged: (val) => controller.serialNumber = val,
                  ),
                if (imagesFunction != null) ...imagesFunction(controller)
              ])),
        )
      ]);
    }
  }

  double stringToDouble(String val) {
    double value = 0.0;
    if (val.contains(".")) {
      value = double.parse(val);
    } else if (val.contains(".") == false) {
      var it = int.parse(val);
      value = it.toDouble();
    }

    return value;
  }
}

//damage
class CreateDamageSwitch extends StatelessWidget implements CardSettingsWidget {
  @required
  final CreateDriverCheckAnswers controller;
  @required
  final String questionType;
  @required
  final String questionLabel;
  @required
  final String trueLabel;
  @required
  final String falseLabel;
  @required
  final String hintText;
  @required
  final String notesLabel;
  @required
  final int numLines;
  @required
  final Function stateFunction;
  @required
  final bool hideOnFail;
  final Function imagesFunction;

  @override
  final bool visible = true;
  @override
  final bool showMaterialonIOS = true;

  const CreateDamageSwitch({
    Key key,
    this.controller, //controller
    this.questionType, //driver, lease, wellbeing or verification.
    this.questionLabel, //label for the question
    this.trueLabel, //label if switch is turned on
    this.falseLabel, //label if switch is turned off
    this.notesLabel, //label for the extra details section
    this.hintText, //label for the extra details hint text
    this.numLines, //number of lines in the extra details field
    this.stateFunction, //state function
    this.imagesFunction, //images function
    this.hideOnFail, //check if extra details should hide on fail
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hideOnFail == true) {
      return Column(children: <Widget>[
        VimCardSettingsSwitch(
          label: questionLabel,
          trueLabel: trueLabel,
          falseLabel: falseLabel,
          onChanged: (value) => stateFunction(
              () => {controller.answer = value ? trueLabel : falseLabel}),
        ),
        // Visibility(
        //   visible: controller.answer == "Fail",
        //   child: Padding(
        //       padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
        //       child: Column(children: [
        //         CardSettingsParagraph(
        //           label: notesLabel,
        //           contentOnNewLine: true,
        //           hintText: hintText,
        //           numberOfLines: numLines,
        //           onChanged: (val) => controller.notes = val,
        //         ),
        //         if(imagesFunction!=null)
        //           ...imagesFunction(controller)
        //       ])),
        // )
      ]);
    } else if (hideOnFail == false) {
      return Column(children: <Widget>[
        VimCardSettingsSwitch(
          label: questionLabel,
          trueLabel: trueLabel,
          falseLabel: falseLabel,
          onChanged: (value) => stateFunction(
              () => {controller.answer = value ? trueLabel : falseLabel}),
        ),
        // Visibility(
        //   child: Padding(
        //       padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
        //       child: Column(children: [
        //         CardSettingsParagraph(
        //           label: notesLabel,
        //           contentOnNewLine: true,
        //           hintText: hintText,
        //           numberOfLines: numLines,
        //           onChanged: (val) => controller.notes = val,
        //         ),
        //         if(imagesFunction!=null)
        //           ...imagesFunction(controller)
        //       ])),
        // )
      ]);
    }
  }
}

//dropdown

class CreateDriverDropdown extends StatelessWidget
    implements CardSettingsWidget {
  @required
  final CreateDriverCheckAnswers controller;
  @required
  final String questionType;
  @required
  final String questionLabel;
  @required
  final String trueLabel;
  @required
  final String falseLabel;
  @required
  final String hintText;
  @required
  final String notesLabel;
  @required
  final int numLines;
  @required
  final Function stateFunction;
  @required
  final bool hideOnFail;
  final Function imagesFunction;

  @override
  final bool visible = true;
  @override
  final bool showMaterialonIOS = true;

  const CreateDriverDropdown({
    Key key,
    this.controller, //controller
    this.questionType, //driver, lease, wellbeing or verification.
    this.questionLabel, //label for the question
    this.trueLabel, //label if switch is turned on
    this.falseLabel, //label if switch is turned off
    this.notesLabel, //label for the extra details section
    this.hintText, //label for the extra details hint text
    this.numLines, //number of lines in the extra details field
    this.stateFunction, //state function
    this.imagesFunction, //images function
    this.hideOnFail, //check if extra details should hide on fail
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.answer = "Third-Party";
    return Column(children: <Widget>[
      VimCardSettingsDropDown(
        label: questionLabel,
        trueLabel: trueLabel,
        falseLabel: falseLabel,
        onChanged: (value) => stateFunction(() {
          controller.answer = value;
          print("value changed");
          print(value);
        }),
      ),
      // Visibility(
      //   child: Padding(
      //       padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
      //       child: Column(children: [
      //         CardSettingsParagraph(
      //           label: notesLabel,
      //           contentOnNewLine: true,
      //           hintText: hintText,
      //           numberOfLines: numLines,
      //           onChanged: (val) => controller.notes = val,
      //         ),
      //         if(imagesFunction!=null)
      //           ...imagesFunction(controller)
      //       ])),
      // )
    ]);
  }
}
