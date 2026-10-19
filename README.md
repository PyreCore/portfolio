# Portfolio — PyreCore

Personal developer portfolio built with Flutter (web).

## Live

https://pyrecore.github.io/portfolio/

## Content

- Hero + tagline
- About
- Featured projects: `jarvis-OS`, `medigo`, `powershel_Admin`, `Linux_Admin`
- Skills & contact

Content lives in `lib/data.dart`, colors and text styles in `lib/theme.dart`.

## Local usage

```bash
flutter pub get
flutter run -d chrome
```

## Deployment

Every push to `main` runs `.github/workflows/deploy.yml`, which tests the app,
builds it with `flutter build web --base-href /portfolio/` and publishes it to
GitHub Pages (Settings → Pages → Source must be set to **GitHub Actions**).

## License

MIT — see [LICENSE](LICENSE).
