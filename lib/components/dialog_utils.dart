import 'package:flutter/material.dart';

// references : https://zenn.dev/pressedkonbu/books/flutter-reverse-lookup-dictionary/viewer/016-input-text-on-dialog

class DialogUtils {
  DialogUtils._();

  // タイトルのみを表示するシンプルなダイアログを表示する
  static Future<void> showOnlyTitleDialog(
    BuildContext context,
    String title,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
        );
      },
    );
  }

  // 入力されてた文字列を返すダイアログ
  static Future<String?> showEditingDialog(
    BuildContext context,
    String? text,
  ) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return TextEditingDialog(text: text);
      },
    );
  }

  // 複数の値をDialogで入力して返すAlertDialog＋ChildScrollView
  static Future<(String, String, String)?> showEditingRecordDialog(
    BuildContext context,
    String? title,
    String? person,
    String? date,
  ) async {
    return showDialog<(String, String, String)>(
      context: context,
      builder: (context) {
        return RecordEditingDialog(title: title, person: person, date: date);
      },
    );
  }
}

// 状態を持ったダイアログ
class TextEditingDialog extends StatefulWidget {
  const TextEditingDialog({Key? key, this.text}) : super(key: key);
  final String? text;

  @override
  State<TextEditingDialog> createState() => _TextEditingDialogState();
}

class _TextEditingDialogState extends State<TextEditingDialog> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TextFormFieldに初期値を入れる
    controller.text = widget.text ?? '';
    focusNode.addListener(
      () {
        if (focusNode.hasFocus) {
          controller.selection = TextSelection(
              baseOffset: 0, extentOffset: controller.text.length);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        autofocus: true,
        focusNode: focusNode,
        controller: controller,
        onFieldSubmitted: (_) {
          Navigator.of(context).pop(controller.text);
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
          child: const Text('完了'),
        ),
      ],
    );
  }
}

class RecordEditingDialog extends StatefulWidget {
  const RecordEditingDialog({Key? key, this.title, this.person, this.date})
      : super(key: key);
  final String? title;
  final String? person;
  final String? date;

  @override
  State<RecordEditingDialog> createState() => _RecordEditingDialogState();
}

class _RecordEditingDialogState extends State<RecordEditingDialog> {
  final titleController = TextEditingController();
  final personController = TextEditingController();
  final dateController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    titleController.dispose();
    personController.dispose();
    dateController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    titleController.text = widget.title ?? '';
    personController.text = widget.person ?? '';
    dateController.text = widget.date ?? '';
    focusNode.addListener(
      () {
        if (focusNode.hasFocus) {
          // 一旦何もしない
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(
//            minHeight: viewportConstraints.maxHeight,
                  ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: TextFormField(
                      autofocus: true,
                      focusNode: focusNode,
                      controller: titleController,
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      autofocus: false,
                      controller: personController,
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      autofocus: false,
                      controller: dateController,
                    ),
                  ),
                ],
              ))),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop((
              titleController.text,
              personController.text,
              dateController.text
            ));
          },
          child: const Text('完了'),
        )
      ],
    );
  }
}
