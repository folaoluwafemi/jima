enum UploadStatus { started, progress, success, failure }

class UploadEvent {
  final String taskId;
  final UploadStatus status;
  final int? progress;
  final String? error;

  UploadEvent({
    required this.taskId,
    required this.status,
    this.progress,
    this.error,
  });
}
