part of '../pages.dart';

class NotedPage extends StatefulWidget {
  const NotedPage({super.key});

  @override
  State<NotedPage> createState() => _NotedPageState();
}

class _NotedPageState extends State<NotedPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  void _addNote() async {
    if (_titleController.text.isNotEmpty && _imageController.text.isNotEmpty) {
      await _firebaseService.addNote(
          _titleController.text, _imageController.text);
      _titleController.clear();
      _imageController.clear();
    }
  }

  void _deleteNote(String noteId) async {
    await _firebaseService.deleteNote(noteId);
  }

  void _editNote(String noteId, String currentTitle, String currentImage) {
    _titleController.text = currentTitle;
    _imageController.text = currentImage;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: _imageController,
                decoration: InputDecoration(labelText: "Image URL"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _firebaseService.updateNote(
                    noteId, _titleController.text, _imageController.text);
                Navigator.pop(context);
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noted Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: _imageController,
                  decoration: InputDecoration(labelText: "Image URL"),
                ),
                ElevatedButton(
                  onPressed: _addNote,
                  child: Text("Add Note"),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getNotes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No Notes Found"));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    String noteId = doc.id;

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: data['image'] != null && data['image'].isNotEmpty
                            ? Image.network(
                          data['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image, color: Colors.red, size: 50);
                          },
                        )
                            : Icon(Icons.image),
                        title: Text(data['title'] ?? "No Title"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editNote(noteId, data['title'], data['image']),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteNote(noteId),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
