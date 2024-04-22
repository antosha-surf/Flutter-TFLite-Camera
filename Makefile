# Runs pub get
pg:
	fvm flutter pub get

# Runs flutter clean
clean:
	fvm flutter clean

cpg:
	make clean
	make pg

rr:
	fvm flutter run --release

# Sorts arb files alphabetically
sort_arb:
	fvm dart pub run arb_utils:sort lib/l10n/arb/intl_en.arb
	fvm dart pub run arb_utils:sort lib/l10n/arb/intl_ru.arb

# Spider -> https://pub.dev/packages/spider
spider:
	spider build

# Makes lint
lint:
	fvm flutter analyze

# Codegen
codegen:
	fvm dart pub run build_runner build --delete-conflicting-outputs

# Codegen watch
cgw:
	fvm dart pub run build_runner watch --delete-conflicting-outputs

# Unit and widget tests
tests:
	fvm flutter test

# Update goldens
ug:
	fvm flutter test --update-goldens

# Runs pre-push operations
prepush:
	make lint && make sort_arb && make ug

# Pod install
pods:
	pod install --repo-update --project-directory=ios

# Validating script
validate:
	make lint && make tests

# Opens iOS simulator
open_ios_sim:
	xcrun simctl boot "iPhone 14"

# Closes iOS simulator
close_ios_sim:
	xcrun simctl shutdown "iPhone 14"

outdated:
	fvm flutter pub outdated
