sealed class TailscaleBannerParseResult {
  const TailscaleBannerParseResult();
}

final class TailscaleBannerIgnored extends TailscaleBannerParseResult {
  const TailscaleBannerIgnored();
}

final class TailscaleBannerChallenge extends TailscaleBannerParseResult {
  const TailscaleBannerChallenge(this.uri);

  final Uri uri;
}

final class TailscaleBannerRejected extends TailscaleBannerParseResult {
  const TailscaleBannerRejected();
}

final class TailscaleUserauthBannerParser {
  const TailscaleUserauthBannerParser();

  static const _challengeMarker =
      '# Tailscale SSH requires an additional check.';
  static const _promptMarker = '# To authenticate, visit:';
  static final _challengeUri = RegExp(
    r'^https://login\.tailscale\.com/a/[A-Za-z0-9_-]+$',
  );
  static final _uriInText = RegExp(r'[A-Za-z][A-Za-z0-9+.-]*://[^\s]+');

  TailscaleBannerParseResult parse(String banner) {
    final lines = banner
        .split('\n')
        .map(
          (line) =>
              line.endsWith('\r') ? line.substring(0, line.length - 1) : line,
        )
        .toList(growable: false);
    final challengeMarkers = lines.where((line) => line == _challengeMarker);
    final promptLines = lines.where((line) => line.startsWith(_promptMarker));
    final isChallengeLike =
        banner.contains('login.tailscale.com') ||
        banner.contains('Tailscale SSH requires an additional check') ||
        banner.contains('To authenticate, visit:');

    if (!isChallengeLike) {
      return const TailscaleBannerIgnored();
    }
    if (challengeMarkers.length != 1 || promptLines.length != 1) {
      return const TailscaleBannerRejected();
    }

    final promptLine = promptLines.single;
    final expectedPrefix = '$_promptMarker ';
    if (!promptLine.startsWith(expectedPrefix)) {
      return const TailscaleBannerRejected();
    }
    final candidate = promptLine.substring(expectedPrefix.length);
    final urls = _uriInText.allMatches(banner).map((match) => match.group(0));
    if (urls.length != 1 || urls.single != candidate) {
      return const TailscaleBannerRejected();
    }
    if (!_challengeUri.hasMatch(candidate)) {
      return const TailscaleBannerRejected();
    }

    return TailscaleBannerChallenge(Uri.parse(candidate));
  }
}
