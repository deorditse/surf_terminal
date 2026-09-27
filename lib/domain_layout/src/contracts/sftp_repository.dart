import '../entities/sftp_entry.dart';

abstract interface class SftpRepository {
  SftpPreviewState get previewState;
  String get path;
  List<SftpEntry> list();
  void setPreviewState(SftpPreviewState state);
  void openFolder(String name);
  void goToParent();
}
