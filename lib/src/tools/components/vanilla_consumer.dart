import 'package:flutter/widgets.dart';
import 'package:vanilla_state/vanilla_state.dart';

/// [VanillaConsumer] is a widget that builds itself based on the latest [S] state.
///
/// You can control when [VanillaConsumer] rebuilds by providing a [buildWhen] function
class VanillaConsumer<Notifier extends VanillaNotifier<S>, S>
    extends StatefulWidget {
  final VanillaWidgetBuilder<S> builder;
  final VanillaSelectorCallback<S>? buildWhen;
  final VanillaListenerCallback<S> listener;
  final VanillaSelectorCallback<S>? listenWhen;

  const VanillaConsumer({
    Key? key,
    required this.builder,
    required this.listener,
    this.listenWhen,
    this.buildWhen,
  }) : super(key: key);

  @override
  State<VanillaConsumer<Notifier, S>> createState() =>
      _VanillaConsumerState<Notifier, S>();
}

class _VanillaConsumerState<Notifier extends VanillaNotifier<T>, T>
    extends State<VanillaConsumer<Notifier, T>> {
  Notifier? notifier;

  T? previousState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startListening();
  }

  void startListening() {
    if (notifier != null) {
      notifier!.removeListener(listener);
    }
    notifier = context.read<Notifier>();
    notifier?.addListener(listener);
  }

  /// listener is called whenever the state changes.
  ///
  /// If [listenWhen] is provided, it is used to check if listener should be called.
  void listener() {
    if (!mounted) return;

    final T currentState = notifier!.state;

    if (currentState == previousState) return;

    if (widget.buildWhen != null) {
      final bool shouldNotify = widget.buildWhen!(previousState, currentState);
      if (shouldNotify) {
        update();
      }
      final bool shouldNotifyListener = widget.listenWhen?.call(
            previousState,
            currentState,
          ) ??
          true;
      if (shouldNotifyListener) {
        widget.listener(previousState, currentState);
      }
      return;
    }

    update();

    previousState = currentState;
  }

  void update() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant VanillaConsumer<Notifier, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    notifier?.removeListener(listener);
    startListening();
  }

  @override
  void dispose() {
    notifier?.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      previousState ?? notifier!.state,
    );
  }
}
