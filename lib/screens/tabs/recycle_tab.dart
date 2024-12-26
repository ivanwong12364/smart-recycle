import 'package:flutter/material.dart';

import '../image_classification_screen.dart';
import '../todo_list_screen.dart';

class RecycleTab extends StatelessWidget {
  final List<RecycleCategory> categories = [
    RecycleCategory(
      title: 'Waste Paper',
      icon: Icons.description,
      items: [
        'Newspapers and magazines',
        'Cardboard boxes',
        'Office paper',
        'Books and notebooks',
        'Paper bags'
      ],
      instructions: 'Make sure paper is clean and dry. Remove any plastic covers, '
          'metal bindings, or tape. Flatten cardboard boxes before recycling.',
    ),
    RecycleCategory(
      title: 'Plastic',
      icon: Icons.local_drink,
      items: [
        'PET bottles (beverage bottles)',
        'HDPE containers (milk jugs, shampoo bottles)',
        'Plastic bags and wraps',
        'Food containers',
        'Plastic cups and utensils'
      ],
      instructions: 'Rinse containers clean of food and liquids. Check for recycling '
          'numbers (1-7) on the bottom. Remove caps and lids before recycling.',
    ),
    RecycleCategory(
      title: 'Metal',
      icon: Icons.settings,
      items: [
        'Aluminum cans',
        'Steel cans',
        'Metal bottle caps',
        'Clean aluminum foil',
        'Metal containers'
      ],
      instructions: 'Rinse all metal items clean. Crush cans to save space. '
          'Remove paper labels when possible. Keep metals separate from other materials.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycling Guide'),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageClassificationScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.checklist),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoListScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                initiallyExpanded: index == 0,
                leading: Icon(
                  category.icon,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
                title: Text(
                  category.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What to Recycle:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        ...category.items.map((item) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle,
                                      size: 20,
                                      color: Theme.of(context).primaryColor),
                                  SizedBox(width: 8),
                                  Expanded(child: Text(item)),
                                ],
                              ),
                            )),
                        SizedBox(height: 16),
                        Text(
                          'Instructions:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          category.instructions,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RecycleCategory {
  final String title;
  final IconData icon;
  final List<String> items;
  final String instructions;

  RecycleCategory({
    required this.title,
    required this.icon,
    required this.items,
    required this.instructions,
  });
} 