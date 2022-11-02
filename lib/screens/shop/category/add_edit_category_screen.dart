import '../../../provider/shop.dart';
import '../../../values/strings_en.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddEditCategoryScreen extends StatefulWidget {
  const AddEditCategoryScreen({Key? key}) : super(key: key);

  @override
  AddEditCategoryScreenState createState() => AddEditCategoryScreenState();
}

class AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedCategory = Category(
    id: null,
    name: '',
    description: '',
    status: '',
  );

  var _initValues = {
    'name': '',
    'description': '',
    'status': '',
  };

  var _isInit = true;
  var _isLoading = false;
  // ignore: prefer_typing_uninitialized_variables
  var _categoryArg;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      _categoryArg =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

      if (_categoryArg != null) {
        Provider.of<Shop>(context, listen: false)
            .fetchCategoryById(_categoryArg['id'], context: context)
            .then((value) {
          _editedCategory = value;
          _initValues = {
            'name': value.name,
            'description': value.description!,
            'status': value.status,
          };

          setState(() {
            _isLoading = false;
          });
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();

    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    var status = '';
    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedCategory.id != null) {
      final response = await Provider.of<Shop>(context, listen: false)
          .updateCategory(_editedCategory.id!, _editedCategory, context);
      if (response == true) {
        status = 'Updated';
      }
    } else {
      try {
        final response = await Provider.of<Shop>(context, listen: false)
            .addCategory(_editedCategory, context);

        if (response == true) {
          status = 'Added';
        }
      } catch (error) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(TITLE_ERROR_OCCURED),
            content: const Text(TITLE_ERROR_WENT_WRONG),
            actions: [
              TextButton(
                child: const Text(TITLE_OKAY),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    if (status != '') {}

    // for close the soft keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.of(context).pop(status);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dotenv.get('APP_TITLE'),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              height: deviceSize.height,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: deviceSize.height * 0.27,
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      children: [
                        SizedBox(
                          height: deviceSize.height * 0.0319,
                        ),
                        Icon(
                          Icons.category,
                          size: deviceSize.height * 0.0511,
                        ),
                        Text(
                          TITLE_CATEGORY,
                          style: TextStyle(
                            fontSize: deviceSize.height * 0.0383,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: deviceSize.height * 0.164,
                    left: 10.0,
                    right: 10.0,
                    child: Form(
                      key: _form,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 8,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          height: deviceSize.height * 0.6,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextFormField(
                                  initialValue: _initValues['name'],
                                  decoration:
                                      const InputDecoration(labelText: TITLE_NAME),
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_descriptionFocusNode);
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return TITLE_ENTER_NAME;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedCategory = Category(
                                      id: _editedCategory.id,
                                      name: value!,
                                      description: _editedCategory.description,
                                      status: _editedCategory.status,
                                    );
                                  },
                                ),
                                TextFormField(
                                  initialValue: _initValues['description'],
                                  decoration: const InputDecoration(
                                      labelText: TITLE_DESCRIPTION),
                                  keyboardType: TextInputType.multiline,
                                  focusNode: _descriptionFocusNode,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return TITLE_ENTER_DESCRIPTION;
                                    }
                                    if (value.length < 10) {
                                      return TITLE_ENTER_DESCRIPTION_LIMIT;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedCategory = Category(
                                      id: _editedCategory.id,
                                      name: _editedCategory.name,
                                      description: value!,
                                      status: _editedCategory.status,
                                    );
                                  },
                                ),
                                DropdownButtonFormField(
                                  value: _initValues['status'] == null ||
                                          _initValues['status'] == ''
                                      ? 'Active'
                                      : _initValues['status'],
                                  isExpanded: true,
                                  validator: (value) {
                                    if (value == null || value == '') {
                                      return TITLE_SELECT_STATUS;
                                    }
                                    return null;
                                  },
                                  hint: const Text(TITLE_SELECT_STATUS),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  items: ['Active', 'Inactive']
                                      .map((label) => DropdownMenuItem(
                                            value: label,
                                            child: Text(label.toString()),
                                          ))
                                      .toList(),
                                  onChanged: (val) {},
                                  onSaved: (value) {
                                    _editedCategory = Category(
                                      id: _editedCategory.id,
                                      name: _editedCategory.name,
                                      description: _editedCategory.description,
                                      status: value as String,
                                    );
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: deviceSize.height * 0.0639,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).primaryColor),
                                        onPressed: _saveForm,
                                        child: _editedCategory.id != null
                                            ? const Text(TITLE_UPDATE)
                                            : const Text(TITLE_ADD),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).primaryColor),
                                        child: const Text(TITLE_CANCEL),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
