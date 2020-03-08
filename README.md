# jump_rope_counter_v2

This project is a Flutter project, which leverages TFLite to count how many jumps your kid makes by camera. Please note this is purely a practice with some interesting technologies, e.g. Tensorflow and Flutter. 

However if you really need to count jumps for your kid, I recommend you to buy [this](https://www.alibaba.com/trade/search?fsb=y&IndexArea=product_en&CatId=&SearchText=jump+rope+count).

## Introduction

I list some features of Flutter used in this project.

- `lib/home.dart` teaches how to use `logging` plugin for a nicely logging.
- `lib/json_localizations.dart`, `lib/json_localizations_delegate.dart`, `locale/` are about how to localize your app. `JsonLocalizations.of(context).text('start'),` in `home.dart` is a case of retrieving a localized text.
- `lib/camera_preview_widget.dart` is about how to TFlite.
- `lib/camera_preview_widget.dart` and `lib/main.dart` are also showing how to use a plugin `camera` to preview the video captured by phone camera.
- `lib/recognition_found_notifier.dart` shows how to use ValueNotifier for sharing the data between widgets (`lib/camera_preview_widget.dart` and `lib/counter_widget.dart`).
- `lib/bounding_box.dart` shows how to paint on widget `lib/counter_widget.dart`.
 

## Thanks

- Learn how to use tflite in flutter from [shaqian/flutter_realtime_detection](https://github.com/shaqian/flutter_realtime_detection)