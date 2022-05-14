import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/Models/tag_model.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class TagPicker extends StatefulWidget {
  const TagPicker(
      {Key? key,
      required this.profileTags,
      required this.tags,
      required this.onConfirmTagSelect,
      required this.onDeleteTagPress})
      : super(key: key);

  final List<TagModel> profileTags;
  final List<TagModel> tags;
  final Function onConfirmTagSelect;
  final Function onDeleteTagPress;

  @override
  State<TagPicker> createState() => _TagPickerState();
}

class _TagPickerState extends State<TagPicker> {
  List<TagModel> tagSelectedForDelete = [];

  late List<MultiSelectItem<TagModel?>> tagDropdownItems = [];

  @override
  void initState() {
    tagDropdownItems = widget.tags.map((e) => MultiSelectItem<TagModel?>(e, e.name)).toList();
    super.initState();
  }

  void tagSelected(i) {
    TagModel clickedTag = widget.profileTags[i.index!];
    if (tagSelectedForDelete.any((tag) => tag.uid == clickedTag.uid)) {
      tagSelectedForDelete.removeWhere((tag) => tag.uid == clickedTag.uid);
    } else {
      tagSelectedForDelete.add(clickedTag);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 0,
                left: 10,
                child: MultiSelectBottomSheetField(
                    items: tagDropdownItems,
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (o) {
                      widget.onConfirmTagSelect(o);
                      o.clear();
                    })),
            tagSelectedForDelete.isNotEmpty
                ? Positioned(
                    child: TextButton(
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await widget.onDeleteTagPress(tagSelectedForDelete);
                      tagSelectedForDelete.clear();
                    },
                  ))
                : Container(),
            Positioned(
              bottom: 0,
              child: Tags(
                itemCount: widget.profileTags.length,
                itemBuilder: (int index) {
                  final tag = widget.profileTags[index];
                  return ItemTags(
                    index: index,
                    //key: Key(index.toString()),
                    title: tag.name,
                    textStyle: GoogleFonts.farro(fontSize: defaultFontSize * 0.8),
                    onPressed: (i) {
                      tagSelected(i);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
