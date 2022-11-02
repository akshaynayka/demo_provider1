import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../provider/services.dart';
import '../../values/strings_en.dart';

class AddEditServiceScreen extends StatefulWidget {
  const AddEditServiceScreen({Key? key}) : super(key: key);

  @override
  AddEditServiceScreenState createState() => AddEditServiceScreenState();
}

class AddEditServiceScreenState extends State<AddEditServiceScreen> {
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedService = Service(
    id: null,
    name: '',
    description: '',
    price: '',
    favorite: '',
    status: 'Active',
  );

  var _initValues = {
    'name': '',
    'description': '',
    'price': '',
    'favorite': '',
    'status': '',
  };

  var _isFavorite = false;
  var _isInit = true;
  var _isLoading = false;
  // ignore: prefer_typing_uninitialized_variables
  var _serviceArg;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _serviceArg =
          ModalRoute.of(context)!.settings.arguments as Map<String, String?>?;

      if (_serviceArg != null) {
        Provider.of<Services>(context, listen: false)
            .fetchServiceById(_serviceArg['id'], context: context)
            .then((value) {
          _editedService = value;
          _initValues = {
            'name': value.name,
            'description': value.description ?? '',
            'price': value.price,
            'favorite': value.favorite,
            'status': value.status,
          };
          _isFavorite = _initValues['favorite'] == 'yes' ? true : false;
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

    if (_editedService.id != null) {
      final response = await Provider.of<Services>(context, listen: false)
          .updateService(_editedService.id!, _editedService, context);
      if (response == true) {
        status = 'Updated';
      }
    } else {
      try {
        final response = await Provider.of<Services>(context, listen: false)
            .addService(_editedService, context);

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

    if (!mounted) return;
    // for close the soft keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.of(context).pop(status);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double height = deviceSize.height * 0.01;
    double width = deviceSize.width * 0.02;
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
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.841,
                      margin: EdgeInsets.all(width * 1.5),
                      padding: EdgeInsets.all(width * 1.5),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Form(
                        key: _form,
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
                                _editedService = Service(
                                  id: _editedService.id,
                                  name: value!,
                                  description: _editedService.description,
                                  price: _editedService.price,
                                  favorite: _editedService.favorite,
                                  status: _editedService.status,
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
                                _editedService = Service(
                                  id: _editedService.id,
                                  name: _editedService.name,
                                  description: value!,
                                  price: _editedService.price,
                                  favorite: _editedService.favorite,
                                  status: _editedService.status,
                                );
                              },
                            ),
                            TextFormField(
                              initialValue: _initValues['price'],
                              decoration:
                                  const InputDecoration(labelText: TITLE_PRICE),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return TITLE_ENTER_PRICE;
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedService = Service(
                                  id: _editedService.id,
                                  name: _editedService.name,
                                  description: _editedService.description,
                                  price: value!,
                                  favorite: _editedService.favorite,
                                  status: _editedService.status,
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width * 15,
                                  child: Row(
                                    children: <Widget>[
                                      const Text(
                                        'Favorite',
                                        style: TextStyle(fontSize: 17.0),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Checkbox(
                                        value: _isFavorite,
                                        onChanged: (value) {
                                          setState(() {
                                            _isFavorite = value!;
                                          });
                                          _editedService = Service(
                                            id: _editedService.id,
                                            name: _editedService.name,
                                            description:
                                                _editedService.description,
                                            price: _editedService.price,
                                            favorite:
                                                _isFavorite ? 'yes' : 'no',
                                            status: _editedService.status,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                //  Expanded(child: SizedBox()),
                                SizedBox(
                                  width: width * 15,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        _editedService.status,
                                        style: TextStyle(
                                            color: _editedService.status ==
                                                    'Active'
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      CupertinoSwitch(
                                          value:
                                              _editedService.status == 'Active',
                                          onChanged: (_) {
                                            setState(() {
                                              if (_editedService.status ==
                                                  'Active') {
                                                _editedService.status =
                                                    'Inactive';
                                              } else {
                                                _editedService.status =
                                                    'Active';
                                              }
                                            });
                                          })
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Expanded(child: SizedBox()),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Theme.of(context).primaryColor),
                                    onPressed: _saveForm,
                                    child: _editedService.id != null
                                        ? const Text(TITLE_MODIFY)
                                        : const Text(TITLE_ADD),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height * 0.06,
                      padding: EdgeInsets.only(bottom: height * 1.5),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.all(height),
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(height)),
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            TITLE_SERVICE,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
