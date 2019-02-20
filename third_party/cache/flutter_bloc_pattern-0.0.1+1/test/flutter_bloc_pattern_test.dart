import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBloc extends Mock implements BaseBloc {}

class ValueBuilder<T extends BaseBloc> extends Mock {
  T call();
}

// ignore: must_be_immutable
class BlocCaptor<T extends BaseBloc> extends StatelessWidget {
  static const Key captorKey = Key('BlocCaptor');

  T bloc;

  BlocCaptor() : super(key: captorKey);

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<T>(context);
    return Container();
  }
}

void main() {
  group('Flutter bloc pattern provider', () {
    testWidgets('passes a bloc down to its descendants',
        (WidgetTester tester) async {
      final bloc = MockBloc();

      final widget = BlocProvider<MockBloc>(
        initBloc: () => bloc,
        child: BlocCaptor<MockBloc>(),
      );

      await tester.pumpWidget(widget);

      final captor = tester.firstWidget<BlocCaptor<MockBloc>>(
        find.byKey(BlocCaptor.captorKey),
      );

      expect(captor.bloc, bloc);
    });

    testWidgets('calls initBloc only once', (tester) async {
      final builder = ValueBuilder<MockBloc>();
      when(builder.call()).thenReturn(MockBloc());

      await tester.pumpWidget(
        BlocProvider<MockBloc>(
          child: Container(),
          initBloc: builder,
        ),
      );
      await tester.pumpWidget(
        BlocProvider<MockBloc>(
          child: Container(),
          initBloc: builder,
        ),
      );
      await tester.pumpWidget(Container());

      verify(builder()).called(1);
    });

    testWidgets('dispose', (tester) async {
      final bloc = MockBloc();

      final widget = BlocProvider<MockBloc>(
        initBloc: () => bloc,
        child: Container(),
      );
      await tester.pumpWidget(widget);
      await tester.pumpWidget(Container());
      verify(bloc.dispose()).called(1);
    });
  });
}
