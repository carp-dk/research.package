import 'package:carp_themes_package/carp_themes_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/research_package.dart';

/// Verifies that the permission sections each have their own illustration, so
/// a study asking for several permissions does not show the same picture on
/// every screen.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// The section types which exist to explain one permission, and the asset
  /// each is expected to show.
  const iconOf = {
    RPConsentSectionType.Location: 'assets/icons/location.png',
    RPConsentSectionType.ActivityRecognition: 'assets/icons/activity.png',
    RPConsentSectionType.Bluetooth: 'assets/icons/bluetooth.png',
    RPConsentSectionType.Notification: 'assets/icons/notification.png',
    RPConsentSectionType.Microphone: 'assets/icons/microphone.png',
    RPConsentSectionType.Camera: 'assets/icons/camera.png',
    RPConsentSectionType.BackgroundSensing: 'assets/icons/settings.png',
    RPConsentSectionType.Health: 'assets/icons/health.png',
  };

  setUp(() => ResearchPackage.ensureInitialized());

  testWidgets('each permission section shows its own icon', (tester) async {
    final rendered = <String>[];

    for (final entry in iconOf.entries) {
      await tester.pumpWidget(
        MaterialApp(
          theme: carpTheme,
          home: RPUIVisualConsentStep(
            step: RPVisualConsentStep(
              identifier: 'visualStep',
              consentDocument: RPConsentDocument(
                title: 'Consent',
                sections: [
                  RPConsentSection(type: entry.key, summary: 'Why we ask'),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final image = tester.widget<Image>(find.byType(Image).first);
      final asset = (image.image as AssetImage).assetName;
      expect(
        asset,
        entry.value,
        reason: '${entry.key.name} shows the wrong illustration',
      );
      rendered.add(asset);
    }

    // Each explains a different permission, so sharing a picture would make
    // the screens indistinguishable.
    expect(rendered.toSet(), hasLength(iconOf.length));
  });
}
