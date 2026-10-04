import 'package:flutter_test/flutter_test.dart';
import 'package:surf_terminal/data_layout/data_layout.dart';

void main() {
  const parser = TailscaleUserauthBannerParser();
  const marker = '# Tailscale SSH requires an additional check.';
  const prompt = '# To authenticate, visit:';
  const validUri = 'https://login.tailscale.com/a/fictional_token-42';

  test('ignores an ordinary user-auth banner', () {
    expect(
      parser.parse('Authorized access only. Activity may be monitored.'),
      isA<TailscaleBannerIgnored>(),
    );
  });

  test('accepts the exact markers and strict challenge URI', () {
    final result = parser.parse('$marker\n$prompt $validUri');

    expect(result, isA<TailscaleBannerChallenge>());
    expect((result as TailscaleBannerChallenge).uri, Uri.parse(validUri));
  });

  final rejected = <String, String>{
    'uppercase scheme':
        '$marker\n$prompt HTTPS://login.tailscale.com/a/fictional_token',
    'uppercase host':
        '$marker\n$prompt https://LOGIN.tailscale.com/a/fictional_token',
    'lookalike host':
        '$marker\n$prompt https://login.tailscale.com.invalid/a/fictional_token',
    'HTTP scheme':
        '$marker\n$prompt http://login.tailscale.com/a/fictional_token',
    'user info':
        '$marker\n$prompt https://user@login.tailscale.com/a/fictional_token',
    'explicit port':
        '$marker\n$prompt https://login.tailscale.com:443/a/fictional_token',
    'query':
        '$marker\n$prompt https://login.tailscale.com/a/fictional_token?next=1',
    'fragment':
        '$marker\n$prompt https://login.tailscale.com/a/fictional_token#next',
    'encoded token':
        '$marker\n$prompt https://login.tailscale.com/a/fictional%2Ftoken',
    'slashed token':
        '$marker\n$prompt https://login.tailscale.com/a/fictional/token',
    'empty token': '$marker\n$prompt https://login.tailscale.com/a/',
    'multiple URLs':
        '$marker\n$prompt $validUri\nhttps://example.invalid/fictional',
    'missing prompt line': '$marker\n$validUri',
    'missing challenge marker': '$prompt $validUri',
  };

  for (final MapEntry(key: name, value: banner) in rejected.entries) {
    test('rejects $name', () {
      expect(parser.parse(banner), isA<TailscaleBannerRejected>());
    });
  }
}
