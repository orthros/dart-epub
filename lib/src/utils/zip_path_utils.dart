class ZipPathUtils {
  static String GetDirectoryPath(String filePath) {
    int lastSlashIndex = filePath.lastIndexOf('/');
    if (lastSlashIndex == -1)
      return "";
    else
      return filePath.substring(0, lastSlashIndex);
  }

  static String Combine(String directory, String fileName) {
    if (directory == null || directory == "")
      return fileName;
    else
      return directory + "/" + fileName;
  }
}
