import 'package:flutter/material.dart';

class DynamicDropdown extends StatefulWidget {
  final bool isSearchEnable;
  final bool isMultiSelect;
  final List<String> items;

  DynamicDropdown({
    required this.isSearchEnable,
    required this.isMultiSelect,
    required this.items,
  });

  @override
  _DynamicDropdownState createState() => _DynamicDropdownState();
}

class _DynamicDropdownState extends State<DynamicDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  TextEditingController _controller = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  List<String> _selectedItems = [];
  bool _isOverlayVisible = false;

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  OverlayEntry _createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final height = MediaQuery.sizeOf(context).height;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          height: height*0.3,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0.0, 62.0), // Overlay 12 pixels below TextFormField
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: widget.items.length > 5 ? 200 : double.infinity,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isSearchEnable)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Search...',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              // Implement search logic to filter items
                            });
                          },
                        ),
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: widget.items.map((item) {
                            bool isSelected = _selectedItems.contains(item);
                            return ListTile(
                              leading: widget.isMultiSelect
                                  ? Checkbox(
                                value: isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedItems.add(item);
                                    } else {
                                      _selectedItems.remove(item);
                                    }
                                  });
                                },
                              )
                                  : null,
                              title: Text(item),
                              onTap: () {
                                if (widget.isMultiSelect) {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedItems.remove(item);
                                    } else {
                                      _selectedItems.add(item);
                                    }
                                  });
                                } else {
                                  setState(() {
                                    _selectedItems = [item];
                                    _controller.text = item;
                                  });
                                  _removeOverlay();
                                }
                              },
                              selected: isSelected,
                              selectedTileColor: Colors.blue[100],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    if (widget.isMultiSelect)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            _removeOverlay();
                          },
                          child: Text('OK'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOverlayVisible = false;
    });
  }

  void _toggleOverlay() {
    if (_isOverlayVisible) {
      _removeOverlay();
    } else {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
      setState(() {
        _isOverlayVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print("Outsid");
          if (!_isOverlayVisible) {
            _removeOverlay();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            controller: _controller,
            readOnly: true, // Always read-only
            onTap: (){
              _toggleOverlay();
            },
            decoration: InputDecoration(
              labelText: 'Select Item',
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
          ),
        ),
        if (_selectedItems.isNotEmpty && widget.isMultiSelect)
    Wrap(
        spacing: 8.0,
        children: _selectedItems.map((item) {
      return Chip(
          label: Text(item),
          onDeleted: () {
          setState(() {
          _selectedItems.remove(item);
          });
          },
          );
        }).toList(),
    ),
          ],
        ),
    );
  }
}