import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/Models/tag_model.dart';
import 'package:hey_plan/Widgets/custom_dialog.dart';
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
  final CustomDialog cd = CustomDialog();
  List<TagModel> tagSelectedForDelete = [];

  late List<MultiSelectItem<TagModel?>> tagDropdownItems = [];

  @override
  void initState() {
    List<TagModel> dropDownTags = widget.tags;
    dropDownTags.removeWhere((element) => widget.profileTags.map((e) => e.uid).contains(element.uid));
    tagDropdownItems = dropDownTags.map((e) => MultiSelectItem<TagModel?>(e, e.name)).toList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  Color tagColor(TagModel? tag) {
    return const Color(accentColor);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration:
            const BoxDecoration(color: Color(backgroundColor), borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              MultiSelectBottomSheetField(
                  items: tagDropdownItems,
                  buttonText: const Text("Añadir tags", style: TextStyle(fontSize: defaultFontSize - 2)),
                  searchable: true,
                  backgroundColor: const Color(darkerAccentColor),
                  buttonIcon: const Icon(Icons.add),
                  selectedColor: const Color(accentColor),
                  selectedItemsTextStyle: const TextStyle(color: Colors.black87),
                  confirmText: const Text("Añadir", style: TextStyle(fontSize: defaultFontSize, color: Colors.black)),
                  cancelText: const Text("Cancelar", style: TextStyle(fontSize: defaultFontSize, color: Colors.black)),
                  title: const Text("Gustos", style: TextStyle(fontSize: defaultFontSize * 1.3)),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (o) async {
                    if (widget.profileTags.length + o.length <= 10) {
                      await widget.onConfirmTagSelect(o);
                      o.clear();
                    } else {
                      cd.showCustomDialog(context, "Solo pueden seleccionar-se hasta 10 tags");
                    }
                  }),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Tags(
                  itemCount: widget.profileTags.length,
                  itemBuilder: (int index) {
                    final tag = widget.profileTags[index];
                    return ItemTags(
                      index: index,
                      key: Key(index.toString()),
                      title: tag.name,
                      textStyle: GoogleFonts.farro(fontSize: defaultFontSize * 0.8),
                      onPressed: (i) {
                        tagSelected(i);
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
              tagSelectedForDelete.isNotEmpty
                  ? ElevatedButton.icon(
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: const Text("Eliminar selección", style: TextStyle(fontSize: defaultFontSize)),
                      onPressed: () async {
                        await widget.onDeleteTagPress(tagSelectedForDelete);
                        tagSelectedForDelete.clear();
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
