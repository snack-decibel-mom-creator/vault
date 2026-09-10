import 'package:flutter_test/flutter_test.dart';
import 'package:vault/main.dart';
void main(){ testWidgets('Vault dashboard renders', (tester) async { await tester.pumpWidget(const VaultApp()); expect(find.text('VAULT'), findsOneWidget); expect(find.text('Good afternoon.'), findsOneWidget); expect(find.text('Quick capture'), findsWidgets); }); }
