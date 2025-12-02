part of '../../ui.dart';

class InstructionImage extends StatefulWidget {
  final String imagePath;
  const InstructionImage({super.key, required this.imagePath});

  @override
  InstructionImageState createState() => InstructionImageState();
}

class InstructionImageState extends State<InstructionImage> {
  @override
  Widget build(BuildContext context) {
    String _imagePath = widget.imagePath;
    Image image;
    _imagePath = widget.imagePath;

    if (_imagePath.startsWith('http')) {
      image = Image.network(
        _imagePath,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return Container();
        },
      );
    } else {
      image = Image.asset(_imagePath);
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: image.width ?? constraints.maxWidth,
              height: image.height ?? constraints.maxHeight,
              child: image,
            ),
          ),
        );
      },
    );
  }
}
